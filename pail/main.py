# main.py
#!/usr/bin/env python3

"""
Pail - PyQt6 Version
Pure S3 Browser Application - Main entry point

Refactored to focus solely on S3 browsing functionality.
Removed all Matillion API integration for a cleaner, focused tool.

Developed for Telligen EDM3 team by Cameron Keeperman, 2025.
Contact: ckeeperman@telligen.com
"""

import sys
import os
import PyQt6
from PyQt6.QtWidgets import QApplication, QSplashScreen, QMessageBox
from PyQt6.QtCore import Qt, QTimer
from PyQt6.QtGui import QPixmap, QIcon

# Import the main application window
try:
    from ui.main_window import MainWindow
    from core.credentials import load_credentials_from_file
    from utils.theme import apply_theme, ThemeManager
except ImportError as e:
    # Show error and exit if imports fail
    app = QApplication(sys.argv)
    QMessageBox.critical(
        None, 
        "Import Error", 
        f"Error importing required modules:\n{str(e)}\n\nPlease ensure all dependencies are installed."
    )
    sys.exit(1)

def main():
    """Main application entry point"""
    # Create QApplication instance
    app = QApplication(sys.argv)
    app.setApplicationName("Pail")
    app.setOrganizationName("Telligen")
    
    # Set application icon
    icon_path = os.path.join(os.path.dirname(__file__), "resources", "sallythesalamander.png")
    if os.path.exists(icon_path):
        app.setWindowIcon(QIcon(icon_path))
    
    # Create and configure splash screen
    splash_pixmap = QPixmap(icon_path) if os.path.exists(icon_path) else QPixmap(256, 256)
    splash = QSplashScreen(splash_pixmap)
    splash.showMessage("Loading Pail...", Qt.AlignmentFlag.AlignBottom | Qt.AlignmentFlag.AlignCenter, Qt.GlobalColor.white)
    splash.show()
    
    # Process events to ensure splash screen displays
    app.processEvents()
    
    # Initialize theme manager
    theme_manager = ThemeManager()
    theme_manager.load_themes()
    
    # Apply default theme
    default_theme = "Classic"
    apply_theme(app, default_theme)
    
    # Initialize main window
    window = MainWindow(theme_manager)
    
    # Close splash and show main window after a short delay
    QTimer.singleShot(1000, lambda: display_main_window(splash, window))
    
    # Start the application event loop
    return app.exec()

def display_main_window(splash, window):
    """Close splash screen and display main window"""
    # Load AWS credentials in advance and show connection dialog if needed
    try:
        aws_creds = load_credentials_from_file()
        
        # Only show connection dialog if credentials are missing
        if not aws_creds.get('access_key') or not aws_creds.get('secret_key'):
            # Don't auto-show connection dialog - let user click Connect button
            # This provides better user experience and control
            pass
        
    except Exception as e:
        print(f"Error loading credentials: {e}")
    
    # Hide splash screen and show main window
    splash.finish(window)
    window.show()
    
    # Center the window on screen
    screen = QApplication.primaryScreen().geometry()
    window_size = window.size()
    window.move(
        (screen.width() - window_size.width()) // 2,
        (screen.height() - window_size.height()) // 2
    )

if __name__ == "__main__":
    sys.exit(main())