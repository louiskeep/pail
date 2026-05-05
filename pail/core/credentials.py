"""
Credentials management
Handles loading and saving of AWS and Matillion credentials from files
Converted from the original credentials.py
"""
import os
import logging
from pathlib import Path

# Setup logging
logger = logging.getLogger(__name__)

def load_credentials_from_file():
    """Load AWS credentials from credentials.txt
    
    Returns:
        dict: Dictionary with AWS credentials
    """
    creds = {
        'access_key': '',
        'secret_key': '',
        'session_token': '',
        'region': ''
    }
    
    try:
        with open('./aws_credentials.txt', 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith('AWS_ACCESS_KEY_ID='):
                    creds['access_key'] = line.split('=', 1)[1]
                elif line.startswith('AWS_SECRET_ACCESS_KEY='):
                    creds['secret_key'] = line.split('=', 1)[1]
                elif line.startswith('AWS_SESSION_TOKEN='):
                    creds['session_token'] = line.split('=', 1)[1]
                elif line.startswith('AWS_REGION='):
                    creds['region'] = line.split('=', 1)[1]
    except FileNotFoundError:
        logger.warning("AWS credentials file not found")
    except Exception as e:
        logger.error(f"Error loading AWS credentials: {str(e)}")
    
    return creds

def save_credentials_to_file(creds):
    """Save AWS credentials to file
    
    Args:
        creds (dict): Dictionary with AWS credentials
    
    Returns:
        bool: True if successful, False otherwise
    """
    try:
        with open('aws_credentials.txt', 'w') as f:
            f.write(f"AWS_ACCESS_KEY_ID={creds.get('access_key', '')}\n")
            f.write(f"AWS_SECRET_ACCESS_KEY={creds.get('secret_key', '')}\n")
            f.write(f"AWS_SESSION_TOKEN={creds.get('session_token', '')}\n")
            f.write(f"AWS_REGION={creds.get('region', '')}\n")
        return True
    except Exception as e:
        logger.error(f"Error saving AWS credentials: {str(e)}")
        return False

def load_matillion_credentials_from_file():
    """Load Matillion credentials from matillion_credentials.txt
    
    Returns:
        dict: Dictionary with Matillion credentials
    """
    creds = {
        'instance': '',
        'username': '',
        'password': ''
    }
    
    try:
        with open('matillion_credentials.txt', 'r') as f:
            for line in f:
                line = line.strip()
                if line.startswith('MATILLION_INSTANCE='):
                    creds['instance'] = line.split('=', 1)[1]
                elif line.startswith('MATILLION_USERNAME='):
                    creds['username'] = line.split('=', 1)[1]
                elif line.startswith('MATILLION_PASSWORD='):
                    creds['password'] = line.split('=', 1)[1]
    except FileNotFoundError:
        logger.warning("Matillion credentials file not found")
    except Exception as e:
        logger.error(f"Error loading Matillion credentials: {str(e)}")
    
    return creds

def save_matillion_credentials_to_file(creds):
    """Save Matillion credentials to file
    
    Args:
        creds (dict): Dictionary with Matillion credentials
    
    Returns:
        bool: True if successful, False otherwise
    """
    try:
        with open('matillion_credentials.txt', 'w') as f:
            f.write(f"MATILLION_INSTANCE={creds.get('instance', '')}\n")
            f.write(f"MATILLION_USERNAME={creds.get('username', '')}\n")
            f.write(f"MATILLION_PASSWORD={creds.get('password', '')}\n")
        return True
    except Exception as e:
        logger.error(f"Error saving Matillion credentials: {str(e)}")
        return False