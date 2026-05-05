# core/s3_manager.py

"""
S3 Manager module
Handles AWS S3 operations for the Pail application
"""
import os
import boto3
import logging
import threading
import io
import zipfile
from botocore.exceptions import ClientError, NoCredentialsError
from pathlib import Path
from typing import List, Dict, Tuple, Any, Optional, Callable

# Setup logging
logger = logging.getLogger(__name__)

class S3Manager:
    """Singleton manager for AWS S3 operations"""
    
    # Class-level attributes for shared state
    _instance = None
    _lock = threading.Lock()
    
    # Shared connection state
    _s3_client = None
    _s3_resource = None
    _connected = False
    _region = None
    _credentials = None
    
    def __new__(cls, *args, **kwargs):
        """Ensure only one instance is created. Accepts and ignores extra args/kwargs for singleton compatibility."""
        if not cls._instance:
            with cls._lock:
                # Double-checked locking
                if not cls._instance:
                    cls._instance = super(S3Manager, cls).__new__(cls)
        return cls._instance
    
    def __init__(self, access_key=None, secret_key=None, session_token=None, region=None):
        """Initialize or return existing instance. Optionally connect with provided credentials."""
        # Prevent re-initialization
        if hasattr(self, '_initialized'):
            return
        self._initialized = True
        # If credentials are provided, connect immediately (for web app usage)
        if access_key and secret_key:
            self.connect(access_key, secret_key, session_token, region)
    
    @classmethod
    def connect(cls, access_key: str, secret_key: str, session_token: str = None, region: str = None) -> bool:
        """Connect to AWS S3 using provided credentials"""
        print("[DEBUG] S3Manager.connect: called with access_key=", access_key, "secret_key=", secret_key, "session_token=", session_token, "region=", region)
        if not region:
            region = "us-east-1"
        with cls._lock:
            try:
                # Store credentials for potential reconnection
                cls._credentials = {
                    'access_key': access_key,
                    'secret_key': secret_key,
                    'session_token': session_token,
                    'region': region
                }
                print(f"[DEBUG] S3Manager.connect: Credentials set: {cls._credentials}")
                # Set up connection parameters
                conn_params = {
                    'aws_access_key_id': access_key,
                    'aws_secret_access_key': secret_key,
                    'region_name': region
                }
                # Add session token if provided
                if session_token:
                    conn_params['aws_session_token'] = session_token
                cls._region = region
                print(f"[DEBUG] S3Manager.connect: conn_params: {conn_params}")
                # Create S3 client and resource
                cls._s3_client = boto3.client('s3', **conn_params)
                cls._s3_resource = boto3.resource('s3', **conn_params)
                print("[DEBUG] S3Manager.connect: boto3 client and resource created")
                # Test connection by listing buckets
                response = cls._s3_client.list_buckets()
                print(f"[DEBUG] S3Manager.connect: list_buckets response: {response}")
                cls._connected = True
                logger.info("Successfully connected to AWS S3")
                print("[DEBUG] S3Manager.connect: Successfully connected to AWS S3")
                return True
            except NoCredentialsError:
                logger.error("No credentials provided")
                print("[DEBUG] S3Manager.connect: No credentials provided")
                cls._connected = False
                return False
            except ClientError as e:
                logger.error(f"Failed to connect to AWS S3: {str(e)}")
                print(f"[DEBUG] S3Manager.connect: ClientError: {e}")
                cls._connected = False
                return False
            except Exception as e:
                logger.error(f"Unexpected error connecting to AWS S3: {str(e)}")
                print(f"[DEBUG] S3Manager.connect: Exception: {e}")
                cls._connected = False
                return False
    
    @classmethod
    def connect_with_dialog(cls, parent_widget=None) -> Tuple[bool, Optional[str]]:
        """Show connection dialog and connect to S3
        
        Args:
            parent_widget: Parent widget for the dialog

        Returns:
            Tuple[bool, Optional[str]]: (Success flag, Region if connected)
        """
        try:
            # Import here to avoid circular imports
            from ui.s3_browser.dialogs import ConnectionDialog
            from core.credentials import save_credentials_to_file
            
            # Create and show the dialog
            dialog = ConnectionDialog(parent_widget)
            result = dialog.exec()
            
            if result == 1:  # Accepted
                # Get credentials from dialog
                access_key, secret_key, session_token, region = dialog.get_credentials()
                
                # Connect to S3
                if cls.connect(access_key, secret_key, session_token, region):
                    return True, region
            
            return False, None
            
        except Exception as e:
            logger.error(f"Error in connect_with_dialog: {str(e)}")
            return False, None
    
    @classmethod
    def connect_with_session(cls, boto3_session, region: str = None) -> bool:
        """Connect using a pre-built boto3 Session (e.g. from a named profile or
        the default credential chain). Lets boto3 manage credential refresh."""
        if not region:
            region = boto3_session.region_name or "us-east-1"
        with cls._lock:
            try:
                if boto3_session.get_credentials() is None:
                    cls._connected = False
                    return False
                cls._s3_client = boto3_session.client('s3', region_name=region)
                cls._s3_resource = boto3_session.resource('s3', region_name=region)
                cls._region = region
                cls._credentials = None
                cls._s3_client.list_buckets()
                cls._connected = True
                return True
            except Exception as e:
                logger.error(f"connect_with_session failed: {e}")
                cls._connected = False
                return False

    @classmethod
    def disconnect(cls) -> None:
        """Disconnect from AWS S3"""
        with cls._lock:
            cls._s3_client = None
            cls._s3_resource = None
            cls._connected = False
            cls._region = None
            cls._credentials = None
            logger.info("Disconnected from AWS S3")
    
    @classmethod
    def is_connected(cls) -> bool:
        """Check if connected to AWS S3
        
        Returns:
            bool: True if connected, False otherwise
        """
        return cls._connected
    
    @classmethod
    def get_region(cls) -> Optional[str]:
        """Get the current region
        
        Returns:
            Optional[str]: Current region or None if not connected
        """
        return cls._region
    
    def list_buckets(self) -> List[Dict[str, Any]]:
        """List all S3 buckets using class-level client
        
        Returns:
            List[Dict[str, Any]]: List of bucket information dictionaries
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            print("[DEBUG] S3Manager.list_buckets: Not connected to AWS S3")
            return []
        try:
            print("[DEBUG] S3Manager.list_buckets: Calling self._s3_client.list_buckets()")
            response = self._s3_client.list_buckets()
            print(f"[DEBUG] S3Manager.list_buckets: Raw response: {response}")
            # Process response
            buckets = []
            for bucket in response.get('Buckets', []):
                # Try to get the bucket's region
                bucket_region = self.get_bucket_region(bucket['Name'])
                # Create bucket info dict
                bucket_info = {
                    'Name': bucket['Name'],
                    'CreationDate': bucket['CreationDate'],
                    'Region': bucket_region
                }
                buckets.append(bucket_info)
            print(f"[DEBUG] S3Manager.list_buckets: Processed buckets: {buckets}")
            return buckets
        except ClientError as e:
            logger.error(f"Failed to list buckets: {str(e)}")
            print(f"[DEBUG] S3Manager.list_buckets: ClientError: {e}")
            return []
        except Exception as e:
            logger.error(f"Unexpected error listing buckets: {str(e)}")
            print(f"[DEBUG] S3Manager.list_buckets: Exception: {e}")
            return []
    
    def get_bucket_region(self, bucket_name: str) -> str:
        """Get the region of a specific bucket
        
        Args:
            bucket_name (str): Name of the bucket
            
        Returns:
            str: Region of the bucket or empty string if error
        """
        if not self._connected or not self._s3_client:
            return ""
        
        try:
            response = self._s3_client.get_bucket_location(Bucket=bucket_name)
            location = response.get('LocationConstraint')
            
            # For US-East-1, LocationConstraint may be None
            if location is None:
                return "us-east-1"
            return location
        
        except ClientError:
            return ""
        
        except Exception:
            return ""
    
    def create_bucket(self, bucket_name: str, region: str = None) -> bool:
        """Create a new S3 bucket
        
        Args:
            bucket_name (str): Name for the new bucket
            region (str, optional): Region for the bucket. Defaults to None.
            
        Returns:
            bool: True if bucket created successfully, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            # Use provided region, or fallback to the connection region
            bucket_region = region or self._region
            
            # For us-east-1, don't include LocationConstraint in the request
            if bucket_region == "us-east-1":
                self._s3_client.create_bucket(Bucket=bucket_name)
            else:
                self._s3_client.create_bucket(
                    Bucket=bucket_name,
                    CreateBucketConfiguration={
                        'LocationConstraint': bucket_region
                    }
                )
            
            logger.info(f"Bucket '{bucket_name}' created successfully")
            return True
        
        except ClientError as e:
            logger.error(f"Failed to create bucket '{bucket_name}': {str(e)}")
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error creating bucket '{bucket_name}': {str(e)}")
            return False
    
    def create_bucket_with_dialog(self, parent_widget=None) -> bool:
        """Show dialog to create bucket and create it
        
        Args:
            parent_widget: Parent widget for the dialog
        
        Returns:
            bool: True if bucket created successfully, False otherwise
        """
        from PyQt6.QtWidgets import QInputDialog, QMessageBox
        
        if not self._connected:
            if parent_widget:
                QMessageBox.warning(
                    parent_widget,
                    "Not Connected",
                    "Please connect to AWS S3 first"
                )
            return False
        
        # Ask for bucket name
        bucket_name, ok = QInputDialog.getText(
            parent_widget,
            "Create Bucket",
            "Enter new bucket name:"
        )
        
        if not ok or not bucket_name:
            return False
        
        # Get region (optional)
        region, ok = QInputDialog.getText(
            parent_widget,
            "Create Bucket",
            "Enter region (leave empty for default):"
        )
        
        if not ok:
            return False
        
        # Create bucket
        success = self.create_bucket(bucket_name, region if region else None)
        
        # Show result
        if success and parent_widget:
            QMessageBox.information(
                parent_widget,
                "Bucket Created",
                f"Successfully created bucket {bucket_name}"
            )
        elif not success and parent_widget:
            QMessageBox.critical(
                parent_widget,
                "Create Failed",
                "Failed to create bucket. See log for details."
            )
        
        return success
    
    def list_objects(self, bucket_name: str, prefix: str = "") -> List[Dict[str, Any]]:
        """List objects in an S3 bucket
        
        Args:
            bucket_name (str): Name of the bucket
            prefix (str, optional): Prefix to filter objects. Defaults to "".
            
        Returns:
            List[Dict[str, Any]]: List of object information dictionaries
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return []
        
        try:
            # List objects with pagination 
            paginator = self._s3_client.get_paginator('list_objects_v2')
            objects = []
            
            # Handle "directories" (common prefixes) and files
            # Adjust the delimiter as needed for folder-like navigation
            page_iterator = paginator.paginate(
                Bucket=bucket_name,
                Prefix=prefix,
                Delimiter='/'
            )
            
            for page in page_iterator:
                # Handle "directories" (common prefixes)
                for prefix_dict in page.get('CommonPrefixes', []):
                    common_prefix = prefix_dict.get('Prefix')
                    
                    # Get folder name from prefix
                    folder_name = common_prefix
                    if folder_name.endswith('/'):
                        folder_name = folder_name[:-1]
                    if '/' in folder_name:
                        folder_name = folder_name.split('/')[-1]
                    
                    objects.append({
                        'Key': common_prefix,
                        'LastModified': None,
                        'Size': 0,
                        'IsFolder': True,
                        'DisplayName': folder_name,
                        'StorageClass': None
                    })
                
                # Handle files
                for obj in page.get('Contents', []):
                    # Skip items that are "directories" (end with /)
                    key = obj.get('Key')
                    if key == prefix or key.endswith('/'):
                        continue
                    
                    # Get file name from key
                    file_name = key
                    if '/' in key:
                        file_name = key.split('/')[-1]
                    
                    objects.append({
                        'Key': key,
                        'LastModified': obj.get('LastModified'),
                        'Size': obj.get('Size', 0),
                        'IsFolder': False,
                        'DisplayName': file_name,
                        'StorageClass': obj.get('StorageClass')
                    })
            
            return objects
        
        except ClientError as e:
            logger.error(f"Failed to list objects in bucket '{bucket_name}': {str(e)}")
            return []
        
        except Exception as e:
            logger.error(f"Unexpected error listing objects in bucket '{bucket_name}': {str(e)}")
            return []
    
    def upload_file(self, 
                   local_file_path: str, 
                   bucket_name: str, 
                   object_key: str = None,
                   callback=None) -> bool:
        """Upload a file to S3
        
        Args:
            local_file_path (str): Path to the local file
            bucket_name (str): Destination bucket name
            object_key (str, optional): S3 object key. Defaults to file name.
            callback (callable, optional): Callback for progress updates. Defaults to None.
            
        Returns:
            bool: True if upload successful, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            # If no object key provided, use file name
            if not object_key:
                object_key = os.path.basename(local_file_path)
            
            # Create a TransferConfig if needed
            if callback:
                from boto3.s3.transfer import TransferConfig
                config = TransferConfig(
                    multipart_threshold=8 * 1024 * 1024,  # 8MB
                    max_concurrency=10
                )
                
                # Create a custom callback class for progress
                from boto3.s3.transfer import S3Transfer
                
                transfer = S3Transfer(self._s3_client, config)
                transfer.upload_file(
                    local_file_path, 
                    bucket_name, 
                    object_key,
                    callback=callback
                )
            else:
                # Simple upload without callback
                self._s3_client.upload_file(
                    local_file_path, 
                    bucket_name, 
                    object_key
                )
            
            logger.info(f"Successfully uploaded {local_file_path} to {bucket_name}/{object_key}")
            return True
        
        except FileNotFoundError:
            logger.error(f"Local file not found: {local_file_path}")
            return False
        
        except ClientError as e:
            logger.error(f"Failed to upload file: {str(e)}")
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error uploading file: {str(e)}")
            return False
    
    def upload_file_with_dialog(self, parent_widget, bucket_name: str, prefix: str = "") -> bool:
        """Show dialog to select and upload a file
        
        Args:
            parent_widget: Parent widget for the dialog
            bucket_name (str): Destination bucket name
            prefix (str, optional): Prefix to use for the upload. Defaults to "".
            
        Returns:
            bool: True if upload successful, False otherwise
        """
        from PyQt6.QtWidgets import QFileDialog, QMessageBox
        from ui.s3_browser.dialogs import ProgressDialog
        
        if not self._connected or not bucket_name:
            if parent_widget:
                QMessageBox.warning(
                    parent_widget,
                    "Not Connected",
                    "Please connect to AWS S3 first and select a bucket"
                )
            return False
        
        # Show file dialog
        file_path, _ = QFileDialog.getOpenFileName(
            parent_widget,
            "Select File to Upload",
            "",
            "All Files (*.*)"
        )
        
        if not file_path:
            return False
        
        # Get file name
        file_name = os.path.basename(file_path)
        
        # Build S3 key with current prefix
        object_key = prefix + file_name
        
        # Create progress dialog
        progress_dialog = ProgressDialog(
            parent_widget,
            "Upload",
            file_name
        )
        
        # Define progress callback
        def update_progress(bytes_transferred, total_bytes):
            if progress_dialog.is_canceled():
                # Return False to cancel the transfer
                return False
            
            progress_dialog.update_progress(bytes_transferred, total_bytes)
            return True
        
        # Show dialog
        progress_dialog.show()
        
        # Upload file
        success = self.upload_file(
            file_path,
            bucket_name,
            object_key,
            update_progress
        )
        
        # Close progress dialog
        progress_dialog.close()
        
        # Show result
        if success and parent_widget:
            QMessageBox.information(
                parent_widget,
                "Upload Complete",
                f"Successfully uploaded {file_name}"
            )
        elif not success and parent_widget:
            QMessageBox.critical(
                parent_widget,
                "Upload Failed",
                "Failed to upload file. See log for details."
            )
        
        return success
    
    def download_file(self, 
                     bucket_name: str, 
                     object_key: str, 
                     local_file_path: str,
                     callback=None) -> bool:
        """Download a file from S3
        
        Args:
            bucket_name (str): Source bucket name
            object_key (str): S3 object key
            local_file_path (str): Path to save the file locally
            callback (callable, optional): Callback for progress updates. Defaults to None.
            
        Returns:
            bool: True if download successful, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            # Ensure the directory exists
            os.makedirs(os.path.dirname(local_file_path), exist_ok=True)
            
            # Configure download with callback if provided
            if callback:
                from boto3.s3.transfer import TransferConfig
                config = TransferConfig(
                    multipart_threshold=8 * 1024 * 1024,  # 8MB
                    max_concurrency=10
                )
                
                # Create a custom callback class for progress
                from boto3.s3.transfer import S3Transfer
                
                transfer = S3Transfer(self._s3_client, config)
                transfer.download_file(
                    bucket_name, 
                    object_key, 
                    local_file_path,
                    callback=callback
                )
            else:
                # Simple download without callback
                self._s3_client.download_file(
                    bucket_name, 
                    object_key, 
                    local_file_path
                )
            
            logger.info(f"Successfully downloaded {bucket_name}/{object_key} to {local_file_path}")
            return True
        
        except ClientError as e:
            logger.error(f"Failed to download file: {str(e)}")
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error downloading file: {str(e)}")
            return False
    
    def delete_object(self, bucket_name: str, object_key: str) -> bool:
        """Delete an object from S3
        
        Args:
            bucket_name (str): Bucket name
            object_key (str): S3 object key
            
        Returns:
            bool: True if deletion successful, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            self._s3_client.delete_object(
                Bucket=bucket_name,
                Key=object_key
            )
            
            logger.info(f"Successfully deleted {bucket_name}/{object_key}")
            return True
        
        except ClientError as e:
            logger.error(f"Failed to delete object: {str(e)}")
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error deleting object: {str(e)}")
            return False
    
    def delete_bucket(self, bucket_name: str, force: bool = False) -> bool:
        """Delete an S3 bucket
        
        Args:
            bucket_name (str): Bucket to delete
            force (bool, optional): Force deletion even if bucket not empty. Defaults to False.
            
        Returns:
            bool: True if deletion successful, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            # If force is True, empty the bucket first
            if force:
                bucket = self._s3_resource.Bucket(bucket_name)
                bucket.objects.all().delete()
            
            # Now delete the bucket
            self._s3_client.delete_bucket(Bucket=bucket_name)
            
            logger.info(f"Successfully deleted bucket {bucket_name}")
            return True
        
        except ClientError as e:
            logger.error(f"Failed to delete bucket: {str(e)}")
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error deleting bucket: {str(e)}")
            return False
    
    def create_folder(self, bucket_name: str, folder_path: str) -> bool:
        """Create a folder (empty object with slash) in S3
        
        Args:
            bucket_name (str): Bucket name
            folder_path (str): Folder path (will add trailing slash if missing)
            
        Returns:
            bool: True if successful, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            # Ensure folder path ends with slash
            if not folder_path.endswith('/'):
                folder_path += '/'
            
            # Create empty object with slash
            self._s3_client.put_object(
                Bucket=bucket_name,
                Key=folder_path,
                Body=''
            )
            
            logger.info(f"Successfully created folder {bucket_name}/{folder_path}")
            return True
        
        except ClientError as e:
            logger.error(f"Failed to create folder: {str(e)}")
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error creating folder: {str(e)}")
            return False
    
    def get_object_metadata(self, bucket_name: str, object_key: str) -> Dict[str, Any]:
        """Get metadata for an object
        
        Args:
            bucket_name (str): Bucket name
            object_key (str): S3 object key
            
        Returns:
            Dict[str, Any]: Object metadata
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return {}
        
        try:
            response = self._s3_client.head_object(
                Bucket=bucket_name,
                Key=object_key
            )
            
            # Format metadata
            metadata = {
                'ContentLength': response.get('ContentLength', 0),
                'ContentType': response.get('ContentType', 'application/octet-stream'),
                'LastModified': response.get('LastModified'),
                'ETag': response.get('ETag', '').strip('"'),
                'Metadata': response.get('Metadata', {})
            }
            
            return metadata
        
        except ClientError as e:
            logger.error(f"Failed to get object metadata: {str(e)}")
            return {}
        
        except Exception as e:
            logger.error(f"Unexpected error getting object metadata: {str(e)}")
            return {}
    
    def get_bucket_policy(self, bucket_name: str) -> str:
        """Get a bucket's policy
        
        Args:
            bucket_name (str): Bucket name
            
        Returns:
            str: Bucket policy as JSON string or empty string if error/no policy
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return ""
        
        try:
            response = self._s3_client.get_bucket_policy(Bucket=bucket_name)
            return response.get('Policy', '')
        
        except ClientError as e:
            if e.response['Error']['Code'] == 'NoSuchBucketPolicy':
                return ""
            logger.error(f"Failed to get bucket policy: {str(e)}")
            return ""
        
        except Exception as e:
            logger.error(f"Unexpected error getting bucket policy: {str(e)}")
            return ""
        
    def copy(self, 
                    source_bucket: str, 
                    source_key: str, 
                    dest_bucket: str, 
                    dest_key: str = None) -> bool:
        """Copy an object between S3 buckets
        
        Args:
            source_bucket (str): Source bucket name
            source_key (str): Source object key
            dest_bucket (str): Destination bucket name
            dest_key (str, optional): Destination object key. Defaults to source key.
        
        Returns:
            bool: True if copy successful, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            # If no destination key provided, use source key
            if dest_key is None:
                dest_key = source_key
            
            # Copy object
            self._s3_client.copy(
                Bucket=dest_bucket,
                CopySource={'Bucket': source_bucket, 'Key': source_key},
                Key=dest_key
            )
            
            logger.info(f"Successfully copied {source_bucket}/{source_key} to {dest_bucket}/{dest_key}")
            return True
        
        except ClientError as e:
            logger.error(f"Failed to copy object: {str(e)}")
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error copying object: {str(e)}")
            return False

    def move_object(self, 
                    source_bucket: str, 
                    source_key: str, 
                    dest_bucket: str, 
                    dest_key: str = None) -> bool:
        """Move an object between S3 buckets
        
        Args:
            source_bucket (str): Source bucket name
            source_key (str): Source object key
            dest_bucket (str): Destination bucket name
            dest_key (str, optional): Destination object key. Defaults to source key.
        
        Returns:
            bool: True if move successful, False otherwise
        """
        if not self._connected or not self._s3_client:
            logger.error("Not connected to AWS S3")
            return False
        
        try:
            # If no destination key provided, use source key
            if dest_key is None:
                dest_key = source_key
            
            # Copy object first
            copy_success = self.copy(source_bucket, source_key, dest_bucket, dest_key)
            
            # If copy succeeded, delete the source object
            if copy_success:
                delete_success = self.delete_object(source_bucket, source_key)
                
                if delete_success:
                    logger.info(f"Successfully moved {source_bucket}/{source_key} to {dest_bucket}/{dest_key}")
                    return True
                else:
                    logger.warning(f"Object copied but failed to delete source {source_bucket}/{source_key}")
                    return False
            
            return False
        
        except Exception as e:
            logger.error(f"Unexpected error moving object: {str(e)}")
            return False

    def _get_s3_client(self):
        """Get the current S3 client (for internal use)"""
        return self._s3_client
    
    def _get_s3_resource(self):
        """Get the current S3 resource (for internal use)"""
        return self._s3_resource
    
    def unzip_file_in_s3(self, bucket_name: str, zip_key: str, prefix: str) -> tuple[bool, str]:
        """
        Unzip a zip file in S3 and upload its contents in place under the given prefix.
        Args:
            bucket_name (str): S3 bucket name
            zip_key (str): S3 object key of the zip file
            prefix (str): S3 prefix/folder to extract to
        Returns:
            tuple[bool, str]: (success, error message)
        """
        if not self._connected or not self._s3_client:
            return False, "Not connected to AWS S3"

        try:
            # Download zip file as stream
            obj = self._s3_client.get_object(Bucket=bucket_name, Key=zip_key)
            zip_stream = io.BytesIO(obj['Body'].read())

            # Open zip file
            with zipfile.ZipFile(zip_stream) as zf:
                for zipinfo in zf.infolist():
                    if zipinfo.is_dir():
                        continue
                    file_data = zf.open(zipinfo)
                    s3_key = prefix + zipinfo.filename
                    # Upload file to S3 (streaming)
                    self._s3_client.upload_fileobj(file_data, bucket_name, s3_key)
                    file_data.close()
            return True, ""
        except Exception as e:
            logger.error(f"Failed to unzip file in S3: {str(e)}")
            return False, str(e)