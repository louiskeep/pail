# utils/theme.py

"""
Theme management for the S3 Crawler application
Provides functionality for loading and applying themes
Converted from the Tkinter theming in the original application
"""
import os
import json
import logging
from PyQt6.QtWidgets import QApplication
from PyQt6.QtGui import QPalette, QColor

# Setup logging
logger = logging.getLogger(__name__)

# Define themes as QSS strings
THEMES = {
    "Classic": """
        QWidget {
            background-color: #fdf6e3;
            color: #222;
            font-family: Segoe UI, Arial, sans-serif;
            font-size: 13px;
        }
        QPushButton {
            background-color: #fffbe6;
            color: #222;
            border: 1px solid #e0cfa0;
            border-radius: 4px;
            padding: 6px 12px;
        }
        QPushButton:hover {
            background-color: #f5e9c8;
        }
        QLineEdit, QComboBox, QTreeWidget, QProgressBar {
            background-color: #ffffff;
            color: #222;
            border: 1px solid #e0cfa0;
            border-radius: 4px;
        }
        QMenu {
            background-color: #fdf6e3;
            color: #222;
        }
        QDialog, QMessageBox {
            background-color: #fdf6e3;
            color: #222;
        }
    """,
    "Dark": """
        QWidget {
            background-color: #232629;
            color: #e0e0e0;
            font-family: Segoe UI, Arial, sans-serif;
            font-size: 13px;
        }
        QPushButton {
            background-color: #444;
            color: #e0e0e0;
            border: 1px solid #666;
            border-radius: 4px;
            padding: 6px 12px;
        }
        QPushButton:hover {
            background-color: #555;
        }
        QLineEdit, QComboBox, QTreeWidget, QProgressBar {
            background-color: #2d2f31;
            color: #e0e0e0;
            border: 1px solid #666;
            border-radius: 4px;
        }
        QMenu {
            background-color: #232629;
            color: #e0e0e0;
        }
        QDialog, QMessageBox {
            background-color: #232629;
            color: #e0e0e0;
        }
    """,
    "Frog": """
        QWidget {
            background-color: #e6f4ea;
            color: #3e2f1c;
            font-family: Segoe UI, Arial, sans-serif;
            font-size: 13px;
        }
        QPushButton {
            background-color: #8fcf6a;
            color: #3e2f1c;
            border: 1px solid #7a5c2e;
            border-radius: 4px;
            padding: 6px 12px;
        }
        QPushButton:hover {
            background-color: #b7e28a;
        }
        QLineEdit, QComboBox, QTreeWidget, QProgressBar {
            background-color: #f5ecd7;
            color: #3e2f1c;
            border: 1px solid #7a5c2e;
            border-radius: 4px;
        }
        QMenu {
            background-color: #e6f4ea;
            color: #3e2f1c;
        }
        QDialog, QMessageBox {
            background-color: #f5ecd7;
            color: #3e2f1c;
        }
    """
}

class ThemeManager:
    """Manages themes for the application"""
    
    def __init__(self, custom_theme_file="themes.json"):
        """Initialize theme manager
        
        Args:
            custom_theme_file (str, optional): Path to custom theme file. Defaults to "themes.json".
        """
        self.themes = THEMES.copy()
        self.custom_theme_file = custom_theme_file
    
    def load_themes(self):
        """Load custom themes from file
        
        Returns:
            bool: True if themes were loaded, False otherwise
        """
        try:
            if os.path.exists(self.custom_theme_file):
                with open(self.custom_theme_file, 'r') as f:
                    custom_themes = json.load(f)
                
                # Merge with default themes, overriding existing ones
                self.themes.update(custom_themes)
                logger.info(f"Loaded {len(custom_themes)} custom themes")
                return True
            else:
                logger.info("No custom theme file found, using defaults")
                return False
        except Exception as e:
            logger.error(f"Error loading themes: {str(e)}")
            return False
    
    def save_themes(self):
        """Save custom themes to file
        
        Returns:
            bool: True if themes were saved, False otherwise
        """
        try:
            # Filter out default themes
            custom_themes = {name: theme for name, theme in self.themes.items() 
                            if name not in THEMES}
            
            with open(self.custom_theme_file, 'w') as f:
                json.dump(custom_themes, f, indent=4)
            
            logger.info(f"Saved {len(custom_themes)} custom themes")
            return True
        except Exception as e:
            logger.error(f"Error saving themes: {str(e)}")
            return False
    
    def get_theme(self, name):
        """Get a theme by name
        
        Args:
            name (str): Name of the theme
        
        Returns:
            dict: Theme settings or None if not found
        """
        return self.themes.get(name)
    
    def get_theme_names(self):
        """Get list of all theme names
        
        Returns:
            list: List of theme names
        """
        return list(self.themes.keys())
    
    def add_theme(self, name, theme_settings):
        """Add or update a theme
        
        Args:
            name (str): Name of the theme
            theme_settings (dict): Theme settings
        
        Returns:
            bool: True if theme was added, False if settings were invalid
        """
        # Validate theme settings
        required_keys = ["bg", "fg", "button_bg", "tree_bg", "input_bg"]
        if not all(key in theme_settings for key in required_keys):
            logger.error(f"Invalid theme settings for {name}")
            return False
        
        self.themes[name] = theme_settings
        return True

def get_theme_names():
    return list(THEMES.keys())

def apply_theme(app, theme_name):
    qss = THEMES.get(theme_name, "")
    app.setStyleSheet(qss)