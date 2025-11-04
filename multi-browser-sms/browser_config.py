"""
Multi-Browser Configuration Manager
Automatically detects and configures all available browsers
"""

import os
import sys
from pathlib import Path
from dataclasses import dataclass
from typing import Dict, List, Optional
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.edge.service import Service as EdgeService
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager
import undetected_chromedriver as uc

@dataclass
class BrowserInfo:
    name: str
    executable_path: str
    driver_path: str
    user_data_dir: str
    browser_type: str  # 'chrome', 'firefox', 'edge'
    is_available: bool = False

class BrowserConfigManager:
    def __init__(self, project_dir: str = None):
        self.project_dir = project_dir or os.getcwd()
        self.drivers_dir = os.path.join(self.project_dir, "drivers")
        self.profiles_dir = os.path.join(self.project_dir, "browser_profiles")
        self.browsers = {}
        
        # Ensure directories exist
        os.makedirs(self.drivers_dir, exist_ok=True)
        os.makedirs(self.profiles_dir, exist_ok=True)
        
        self._detect_browsers()
    
    def _detect_browsers(self):
        """Detect all available browsers on the system"""
        browser_configs = [
            # Chrome-based browsers
            {
                'name': 'chrome',
                'paths': [
                    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
                    r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
                ],
                'browser_type': 'chrome'
            },
            {
                'name': 'brave',
                'paths': [
                    os.path.expandvars(r"%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"),
                    r"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
                ],
                'browser_type': 'chrome'
            },
            {
                'name': 'vivaldi',
                'paths': [
                    os.path.expandvars(r"%LOCALAPPDATA%\Vivaldi\Application\vivaldi.exe"),
                    r"C:\Program Files\Vivaldi\Application\vivaldi.exe"
                ],
                'browser_type': 'chrome'
            },
            {
                'name': 'opera',
                'paths': [
                    os.path.expandvars(r"%APPDATA%\Opera Software\Opera GX Stable\opera.exe"),
                    os.path.expandvars(r"%LOCALAPPDATA%\Programs\Opera\opera.exe"),
                    r"C:\Program Files\Opera\opera.exe"
                ],
                'browser_type': 'chrome'
            },
            # Firefox
            {
                'name': 'firefox',
                'paths': [
                    r"C:\Program Files\Mozilla Firefox\firefox.exe",
                    r"C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
                ],
                'browser_type': 'firefox'
            },
            # Edge
            {
                'name': 'edge',
                'paths': [
                    r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
                    os.path.expandvars(r"%PROGRAMFILES%\Microsoft\Edge\Application\msedge.exe")
                ],
                'browser_type': 'edge'
            }
        ]
        
        for config in browser_configs:
            for path in config['paths']:
                if os.path.exists(path):
                    user_data_dir = os.path.join(self.profiles_dir, f"{config['name']}_profile")
                    os.makedirs(user_data_dir, exist_ok=True)
                    
                    browser_info = BrowserInfo(
                        name=config['name'],
                        executable_path=path,
                        driver_path="",  # Will be set when driver is downloaded
                        user_data_dir=user_data_dir,
                        browser_type=config['browser_type'],
                        is_available=True
                    )
                    self.browsers[config['name']] = browser_info
                    print(f"✅ Detected {config['name'].title()}: {path}")
                    break
    
    def setup_drivers(self):
        """Download and setup all required drivers"""
        print("\n🔧 Setting up browser drivers...")
        
        for browser_name, browser_info in self.browsers.items():
            try:
                if browser_info.browser_type == 'chrome':
                    # Use webdriver-manager for automatic driver management
                    driver_path = ChromeDriverManager().install()
                    browser_info.driver_path = driver_path
                    print(f"✅ {browser_name.title()} driver ready")
                    
                elif browser_info.browser_type == 'firefox':
                    driver_path = GeckoDriverManager().install()
                    browser_info.driver_path = driver_path
                    print(f"✅ {browser_name.title()} driver ready")
                    
                elif browser_info.browser_type == 'edge':
                    driver_path = EdgeChromiumDriverManager().install()
                    browser_info.driver_path = driver_path
                    print(f"✅ {browser_name.title()} driver ready")
                    
            except Exception as e:
                print(f"❌ Failed to setup driver for {browser_name}: {e}")
                browser_info.is_available = False
    
    def create_driver(self, browser_name: str, headless: bool = False):
        """Create a webdriver instance for the specified browser"""
        if browser_name not in self.browsers:
            raise ValueError(f"Browser '{browser_name}' not available")
        
        browser_info = self.browsers[browser_name]
        if not browser_info.is_available:
            raise ValueError(f"Browser '{browser_name}' is not properly configured")
        
        try:
            if browser_info.browser_type == 'chrome':
                return self._create_chrome_driver(browser_info, headless)
            elif browser_info.browser_type == 'firefox':
                return self._create_firefox_driver(browser_info, headless)
            elif browser_info.browser_type == 'edge':
                return self._create_edge_driver(browser_info, headless)
        except Exception as e:
            print(f"❌ Failed to create driver for {browser_name}: {e}")
            return None
    
    def _create_chrome_driver(self, browser_info: BrowserInfo, headless: bool):
        """Create Chrome-based driver (Chrome, Brave, Vivaldi, Opera)"""
        options = uc.ChromeOptions()
        
        # Basic options
        options.add_argument(f"--user-data-dir={browser_info.user_data_dir}")
        options.add_argument("--no-first-run")
        options.add_argument("--no-default-browser-check")
        options.add_argument("--disable-blink-features=AutomationControlled")
        options.add_experimental_option("excludeSwitches", ["enable-automation"])
        options.add_experimental_option('useAutomationExtension', False)
        
        if headless:
            options.add_argument("--headless")
        
        # Browser-specific executable path
        if browser_info.name != 'chrome':
            options.binary_location = browser_info.executable_path
        
        # Create undetected Chrome driver
        driver = uc.Chrome(
            options=options,
            driver_executable_path=browser_info.driver_path,
            version_main=None  # Auto-detect Chrome version
        )
        
        # Remove automation indicators
        driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
        
        return driver
    
    def _create_firefox_driver(self, browser_info: BrowserInfo, headless: bool):
        """Create Firefox driver"""
        from selenium.webdriver.firefox.options import Options as FirefoxOptions
        
        options = FirefoxOptions()
        options.binary_location = browser_info.executable_path
        
        if headless:
            options.add_argument("--headless")
        
        # Firefox profile
        options.add_argument(f"-profile")
        options.add_argument(browser_info.user_data_dir)
        
        service = FirefoxService(browser_info.driver_path)
        driver = webdriver.Firefox(service=service, options=options)
        
        return driver
    
    def _create_edge_driver(self, browser_info: BrowserInfo, headless: bool):
        """Create Edge driver"""
        from selenium.webdriver.edge.options import Options as EdgeOptions
        
        options = EdgeOptions()
        options.binary_location = browser_info.executable_path
        options.add_argument(f"--user-data-dir={browser_info.user_data_dir}")
        
        if headless:
            options.add_argument("--headless")
        
        service = EdgeService(browser_info.driver_path)
        driver = webdriver.Edge(service=service, options=options)
        
        return driver
    
    def get_available_browsers(self) -> List[str]:
        """Get list of available browser names"""
        return [name for name, info in self.browsers.items() if info.is_available]
    
    def get_browser_count(self) -> int:
        """Get number of available browsers"""
        return len(self.get_available_browsers())
    
    def print_summary(self):
        """Print summary of detected browsers"""
        available = self.get_available_browsers()
        print(f"\n🚀 Browser Arsenal Ready: {len(available)} browsers detected")
        for browser_name in available:
            browser_info = self.browsers[browser_name]
            print(f"   ✅ {browser_name.title()}: {browser_info.executable_path}")
        
        if len(available) == 0:
            print("❌ No browsers detected. Please install Chrome, Firefox, or Edge.")


if __name__ == "__main__":
    # Test the browser detection
    manager = BrowserConfigManager()
    manager.setup_drivers()
    manager.print_summary()