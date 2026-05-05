# ui/s3_browser/dialogs.py

"""
S3 Browser dialogs
Contains dialog classes for S3 browser interactions
Converted from the original dialogs.py
"""
import os
from PyQt6.QtWidgets import (
    QDialog, QVBoxLayout, QHBoxLayout, QFormLayout, 
    QLabel, QLineEdit, QPushButton, QMessageBox,
    QCheckBox, QProgressBar, QDialogButtonBox
)
from PyQt6.QtCore import Qt, pyqtSignal, QSize

from core.credentials import load_credentials_from_file, save_credentials_to_file

class ConnectionDialog(QDialog):
    """Dialog for S3 connection settings"""
    
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setWindowTitle("Connect to AWS S3")
        self.setFixedSize(400, 240)
        self.setModal(True)
        
        # Load existing credentials
        self.creds = load_credentials_from_file()
        
        self.init_ui()
        self.center_on_parent()
    
    def init_ui(self):
        """Initialize the dialog UI"""
        # Main layout
        layout = QVBoxLayout(self)
        
        # Form layout for inputs
        form_layout = QFormLayout()
        
        # Access Key ID
        form_layout.addRow("AWS Access Key ID:", self.create_access_key_input())
        
        # Secret Access Key
        form_layout.addRow("AWS Secret Access Key:", self.create_secret_key_input())
        
        # Session Token
        form_layout.addRow("Session Token (optional):", self.create_session_token_input())
        
        # Region
        form_layout.addRow("AWS Region (optional):", self.create_region_input())
        
        # Add form to main layout
        layout.addLayout(form_layout)
        
        # Add save credentials checkbox
        self.save_checkbox = QCheckBox("Save credentials to file")
        self.save_checkbox.setChecked(True)
        layout.addWidget(self.save_checkbox)
        
        # Add buttons
        button_layout = QHBoxLayout()
        
        connect_button = QPushButton("Connect")
        connect_button.setDefault(True)
        connect_button.clicked.connect(self.on_connect)
        
        cancel_button = QPushButton("Cancel")
        cancel_button.clicked.connect(self.reject)
        
        button_layout.addWidget(connect_button)
        button_layout.addWidget(cancel_button)
        
        layout.addLayout(button_layout)
    
    def create_access_key_input(self):
        """Create and configure access key input field"""
        self.access_key_input = QLineEdit()
        self.access_key_input.setText(self.creds.get('access_key', ''))
        self.access_key_input.setMinimumWidth(300)
        return self.access_key_input
    
    def create_secret_key_input(self):
        """Create and configure secret key input field"""
        self.secret_key_input = QLineEdit()
        self.secret_key_input.setText(self.creds.get('secret_key', ''))
        self.secret_key_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.secret_key_input.setMinimumWidth(300)
        return self.secret_key_input
    
    def create_session_token_input(self):
        """Create and configure session token input field"""
        self.session_token_input = QLineEdit()
        self.session_token_input.setText(self.creds.get('session_token', ''))
        self.session_token_input.setMinimumWidth(300)
        return self.session_token_input
    
    def create_region_input(self):
        """Create and configure region input field"""
        self.region_input = QLineEdit()
        self.region_input.setText(self.creds.get('region', ''))
        self.region_input.setMinimumWidth(300)
        return self.region_input
    
    def center_on_parent(self):
        """Center the dialog on the parent window"""
        if self.parent():
            parent_geometry = self.parent().geometry()
            parent_center = parent_geometry.center()
            
            dialog_size = self.size()
            x = parent_center.x() - dialog_size.width() // 2
            y = parent_center.y() - dialog_size.height() // 2
            
            self.move(x, y)
    
    def on_connect(self):
        """Handle the connect button click"""
        access_key = self.access_key_input.text().strip()
        secret_key = self.secret_key_input.text().strip()
        session_token = self.session_token_input.text().strip()
        region = self.region_input.text().strip()
        
        if not access_key or not secret_key:
            QMessageBox.critical(self, "Error", "AWS Access Key ID and Secret Access Key are required.")
            return
        
        # Save credentials if checkbox is checked
        if self.save_checkbox.isChecked():
            creds = {
                'access_key': access_key,
                'secret_key': secret_key,
                'session_token': session_token,
                'region': region
            }
            from core.credentials import save_credentials_to_file
            save_credentials_to_file(creds)
        
        # Store result and accept dialog
        self.result_credentials = (access_key, secret_key, session_token, region)
        self.accept()
    
    def get_credentials(self):
        """Return the entered credentials
        
        Returns:
            tuple: (access_key, secret_key, session_token, region)
        """
        if hasattr(self, 'result_credentials'):
            return self.result_credentials
        return (None, None, None, None)

class ProgressDialog(QDialog):
    """Dialog for showing progress of S3 operations"""
    
    def __init__(self, parent=None, operation_type="Operation", filename=""):
        super().__init__(parent)
        self.setWindowTitle(f"S3 {operation_type}")
        self.setFixedSize(400, 150)
        self.setModal(True)
        
        self.filename = filename
        self.operation_type = operation_type
        self.canceled = False
        
        self.init_ui()
        self.center_on_parent()
    
    def init_ui(self):
        """Initialize the dialog UI"""
        layout = QVBoxLayout(self)
        
        # Operation label
        self.operation_label = QLabel(f"{self.operation_type} {self.filename}...")
        self.operation_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(self.operation_label)
        
        # Progress bar
        self.progress_bar = QProgressBar()
        self.progress_bar.setRange(0, 100)
        self.progress_bar.setValue(0)
        layout.addWidget(self.progress_bar)
        
        # Status label
        self.status_label = QLabel("Starting...")
        self.status_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        layout.addWidget(self.status_label)
        
        # Cancel button
        self.button_box = QDialogButtonBox(QDialogButtonBox.StandardButton.Cancel)
        self.button_box.rejected.connect(self.on_cancel)
        layout.addWidget(self.button_box)
    
    def center_on_parent(self):
        """Center the dialog on the parent window"""
        if self.parent():
            parent_geometry = self.parent().geometry()
            parent_center = parent_geometry.center()
            
            dialog_size = self.size()
            x = parent_center.x() - dialog_size.width() // 2
            y = parent_center.y() - dialog_size.height() // 2
            
            self.move(x, y)
    
    def update_progress(self, bytes_transferred, total_bytes):
        """Update the progress bar"""
        if total_bytes:
            percentage = int((bytes_transferred / total_bytes) * 100)
            self.progress_bar.setValue(percentage)
            
            # Calculate transfer rate and ETA
            # Implementation would depend on tracking timing data
            self.status_label.setText(f"{bytes_transferred / 1024 / 1024:.1f} MB of {total_bytes / 1024 / 1024:.1f} MB")
    
    def on_cancel(self):
        """Handle cancel button press"""
        self.canceled = True
        self.status_label.setText("Canceling...")
        # The actual cancellation logic would need to be handled by the caller
    
    def is_canceled(self):
        """Check if the operation was canceled
        
        Returns:
            bool: True if canceled, False otherwise
        """
        return self.canceled