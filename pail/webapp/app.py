import boto3
from botocore.exceptions import ClientError
import re
from flask import Flask, jsonify, render_template, request, send_file, session, redirect, url_for
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from core.s3_manager import S3Manager

app = Flask(__name__)
app.secret_key = os.environ.get('FLASK_SECRET_KEY', 'devsecret')


# Copy an object between buckets
@app.route('/api/buckets/<bucket>/copy', methods=['POST'])
def copy_object(bucket):
    mgr = get_s3_manager()
    if not mgr:
        return jsonify({'error': 'Not authenticated'}), 401
    data = request.get_json()
    source_key = data.get('source_key')
    dest_bucket = data.get('dest_bucket')
    dest_key = data.get('dest_key')
    if not source_key or not dest_bucket or not dest_key:
        return jsonify({'error': 'Missing parameters'}), 400
    try:
        success = mgr.copy(bucket, source_key, dest_bucket, dest_key)
        if success:
            return jsonify({'success': True})
        else:
            return jsonify({'success': False, 'error': 'Copy failed'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

# Move an object between buckets
@app.route('/api/buckets/<bucket>/move', methods=['POST'])
def move_object(bucket):
    mgr = get_s3_manager()
    if not mgr:
        return jsonify({'error': 'Not authenticated'}), 401
    data = request.get_json()
    source_key = data.get('source_key')
    dest_bucket = data.get('dest_bucket')
    dest_key = data.get('dest_key')
    if not source_key or not dest_bucket or not dest_key:
        return jsonify({'error': 'Missing parameters'}), 400
    try:
        success = mgr.move_object(bucket, source_key, dest_bucket, dest_key)
        if success:
            return jsonify({'success': True})
        else:
            return jsonify({'success': False, 'error': 'Move failed'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

# Unzip a file in S3
@app.route('/api/buckets/<bucket>/unzip', methods=['POST'])
def unzip_file(bucket):
    mgr = get_s3_manager()
    if not mgr:
        return jsonify({'error': 'Not authenticated'}), 401
    data = request.get_json()
    zip_key = data.get('zip_key')
    prefix = data.get('prefix', '')
    if not zip_key:
        return jsonify({'error': 'Missing zip_key'}), 400
    try:
        success, error = mgr.unzip_file_in_s3(bucket, zip_key, prefix)
        if success:
            return jsonify({'success': True})
        else:
            return jsonify({'success': False, 'error': error})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

# List objects for file explorer (bucket & prefix as query params)
@app.route('/api/list-objects')
def api_list_objects():
    bucket = request.args.get('bucket')
    prefix = request.args.get('prefix', '')
    mgr = get_s3_manager()
    if not mgr:
        return jsonify({'error': 'Not authenticated'}), 401
    if not bucket:
        return jsonify({'error': 'Missing bucket'}), 400
    try:
        objects = mgr.list_objects(bucket, prefix)
        return jsonify({'objects': objects})
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Development endpoint to provide AWS credentials for autofill
@app.route('/api/dev-aws-creds')
def dev_aws_creds():
    creds_path = os.path.join(os.path.dirname(__file__), '..', 'aws_credentials.txt')
    creds = {'access_key': '', 'secret_key': '', 'session_token': '', 'region': ''}
    if os.path.exists(creds_path):
        with open(creds_path) as f:
            for line in f:
                m = re.match(r'AWS_ACCESS_KEY_ID=(.*)', line)
                if m:
                    creds['access_key'] = m.group(1).strip()
                m = re.match(r'AWS_SECRET_ACCESS_KEY=(.*)', line)
                if m:
                    creds['secret_key'] = m.group(1).strip()
                m = re.match(r'AWS_SESSION_TOKEN=(.*)', line)
                if m:
                    creds['session_token'] = m.group(1).strip()
                m = re.match(r'AWS_REGION=(.*)', line)
                if m:
                    creds['region'] = m.group(1).strip()
    return jsonify(creds)

def get_s3_manager():
    creds = session.get('aws_creds')
    if not creds:
        return None
    mgr = S3Manager(
        access_key=creds.get('access_key'),
        secret_key=creds.get('secret_key'),
        session_token=creds.get('session_token'),
        region=creds.get('region')
    )
    if not mgr.is_connected():
        return None
    return mgr


@app.route('/')
def index():
    if not session.get('aws_creds'):
        return redirect(url_for('login'))
    return render_template('index.html')

@app.route('/login')
def login():
    return render_template('login.html')

@app.route('/logout', methods=['POST', 'GET'])
def logout():
    session.pop('aws_creds', None)
    if request.method == 'GET':
        return redirect(url_for('login'))
    return jsonify({'success': True})


# Login API
@app.route('/api/login', methods=['POST'])
def api_login():
    data = request.get_json()
    access_key = data.get('access_key')
    secret_key = data.get('secret_key')
    session_token = data.get('session_token')
    region = data.get('region')
    # Try to authenticate with AWS using session token if provided
    try:
        aws_session = boto3.Session(
            aws_access_key_id=access_key,
            aws_secret_access_key=secret_key,
            aws_session_token=session_token if session_token else None,
            region_name=region
        )
        s3 = aws_session.client('s3')
        # Simple call to verify credentials
        s3.list_buckets()
        # Store credentials in Flask session for authentication
        session['aws_creds'] = {
            'access_key': access_key,
            'secret_key': secret_key,
            'session_token': session_token,
            'region': region
        }
        return jsonify({'success': True})
    except ClientError as e:
        return jsonify({'success': False, 'error': str(e)}), 401
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 500

@app.route('/api/buckets')
def list_buckets():
    print("[DEBUG] /api/buckets called")
    mgr = get_s3_manager()
    if not mgr:
        print("[DEBUG] Not authenticated in /api/buckets")
        return jsonify({'error': 'Not authenticated'}), 401
    try:
        buckets = mgr.list_buckets()
        print(f"[DEBUG] Buckets returned: {buckets}")
        return jsonify({'buckets': buckets})
    except Exception as e:
        print(f"[DEBUG] Exception in /api/buckets: {e}")
        return jsonify({'error': str(e)}), 500


# List objects in a bucket
@app.route('/api/buckets/<bucket>/objects', methods=['GET', 'DELETE'])
def list_objects(bucket):
    if request.method == 'GET':
        print(f"[DEBUG] /api/buckets/{bucket}/objects called")
        mgr = get_s3_manager()
        if not mgr:
            print("[DEBUG] Not authenticated in /api/buckets/<bucket>/objects")
            return jsonify({'error': 'Not authenticated'}), 401
        try:
            prefix = request.args.get('prefix', '')
            print(f"[DEBUG] Listing objects in bucket: {bucket}, prefix: '{prefix}'")
            objects = mgr.list_objects(bucket, prefix)
            #print(f"[DEBUG] Objects returned: {objects}")
            return jsonify({'objects': objects})
        except Exception as e:
            print(f"[DEBUG] Exception in /api/buckets/<bucket>/objects: {e}")
            return jsonify({'error': str(e)}), 500
    elif request.method == 'DELETE':
        mgr = get_s3_manager()
        if not mgr:
            return jsonify({'error': 'Not authenticated'}), 401
        key = request.json.get('key')
        if not key:
            return jsonify({'error': 'Missing key'}), 400
        try:
            mgr.delete_object(bucket, key)
            return jsonify({'success': True})
        except Exception as e:
            return jsonify({'error': str(e)}), 500

# Upload a file to a bucket
@app.route('/api/buckets/<bucket>/upload', methods=['POST'])
def upload_file(bucket):
    mgr = get_s3_manager()
    if not mgr:
        return jsonify({'error': 'Not authenticated'}), 401
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    key = request.form.get('key', file.filename)
    try:
        mgr.upload_fileobj(file, bucket, key)
        return jsonify({'success': True})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Download a file from a bucket
@app.route('/api/buckets/<bucket>/download')
def download_file(bucket):
    mgr = get_s3_manager()
    if not mgr:
        return jsonify({'error': 'Not authenticated'}), 401
    key = request.args.get('key')
    if not key:
        return jsonify({'error': 'Missing key'}), 400
    try:
        fileobj = mgr.download_fileobj(bucket, key)
        return send_file(fileobj, as_attachment=True, download_name=key)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
