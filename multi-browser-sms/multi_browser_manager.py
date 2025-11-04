"""
Multi-Browser Manager
Orchestrates parallel SMS sending across multiple browsers
"""

import time
import threading
import queue
import random
import logging
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass, field
from typing import List, Dict, Optional, Callable
from threading import Lock
import pandas as pd
from colorama import Fore, Back, Style, init
from tqdm import tqdm
import psutil

# Initialize colorama for Windows
init(autoreset=True)

@dataclass
class BrowserWorkerStats:
    browser_name: str
    messages_sent: int = 0
    messages_failed: int = 0
    start_time: Optional[datetime] = None
    last_message_time: Optional[datetime] = None
    is_active: bool = False
    error_count: int = 0
    authentication_status: str = "pending"  # pending, authenticated, failed
    
    @property
    def success_rate(self) -> float:
        total = self.messages_sent + self.messages_failed
        return (self.messages_sent / total * 100) if total > 0 else 0
    
    @property
    def messages_per_minute(self) -> float:
        if not self.start_time or self.messages_sent == 0:
            return 0
        elapsed = (datetime.now() - self.start_time).total_seconds() / 60
        return self.messages_sent / elapsed if elapsed > 0 else 0

@dataclass
class MessageTask:
    phone: str
    message: str
    browser_assigned: str
    original_index: int
    retry_count: int = 0
    status: str = "pending"
    sent_time: Optional[datetime] = None
    error_message: str = ""

class MultiBrowserManager:
    def __init__(self, browser_config_manager, config: dict):
        self.browser_manager = browser_config_manager
        self.config = config
        self.stats = {}
        self.message_queue = queue.Queue()
        self.result_queue = queue.Queue()
        self.active_drivers = {}
        self.stats_lock = Lock()
        self.shutdown_event = threading.Event()
        
        # Progress tracking
        self.total_messages = 0
        self.completed_messages = 0
        self.failed_messages = 0
        
        # Setup logging
        self.setup_logging()
        
        # Colors for different browsers
        self.browser_colors = {
            'chrome': Fore.GREEN,
            'firefox': Fore.RED,
            'brave': Fore.YELLOW,
            'opera': Fore.MAGENTA,
            'vivaldi': Fore.CYAN,
            'edge': Fore.BLUE
        }
    
    def setup_logging(self):
        """Setup logging with browser-specific handlers"""
        logging.basicConfig(
            level=getattr(logging, self.config.get('LOG_LEVEL', 'INFO')),
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(f'logs/sms_run_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger(__name__)
    
    def load_messages_from_csv(self, csv_file: str) -> List[MessageTask]:
        """Load messages from CSV file and create message tasks"""
        try:
            df = pd.read_csv(csv_file)
            messages = []
            
            available_browsers = self.browser_manager.get_available_browsers()
            
            for idx, row in df.iterrows():
                # Auto-assign browser if not specified or not available
                if 'browser_assigned' not in row or row['browser_assigned'] not in available_browsers:
                    browser_assigned = available_browsers[idx % len(available_browsers)]
                else:
                    browser_assigned = row['browser_assigned']
                
                # Skip if already sent
                if row.get('status') == 'sent':
                    continue
                
                message_task = MessageTask(
                    phone=row['phone'],
                    message=row['message'],
                    browser_assigned=browser_assigned,
                    original_index=idx
                )
                messages.append(message_task)
            
            self.total_messages = len(messages)
            self.logger.info(f"Loaded {self.total_messages} messages from {csv_file}")
            return messages
            
        except Exception as e:
            self.logger.error(f"Failed to load messages from {csv_file}: {e}")
            return []
    
    def initialize_browsers(self, browsers_to_use: List[str]) -> Dict[str, any]:
        """Initialize browser drivers and authenticate"""
        self.logger.info(f"Initializing {len(browsers_to_use)} browsers...")
        
        print(f"\n{Fore.CYAN}🚀 LAUNCHING BROWSER ARSENAL{Style.RESET_ALL}")
        print("=" * 50)
        
        # Initialize stats for each browser
        for browser in browsers_to_use:
            self.stats[browser] = BrowserWorkerStats(
                browser_name=browser,
                start_time=datetime.now()
            )
        
        # Launch browsers with staggered delays
        for i, browser in enumerate(browsers_to_use):
            try:
                print(f"{self.browser_colors.get(browser, Fore.WHITE)}🌐 Launching {browser.title()}...{Style.RESET_ALL}")
                
                driver = self.browser_manager.create_driver(browser, headless=False)
                if driver:
                    self.active_drivers[browser] = driver
                    
                    # Navigate to Google Messages
                    driver.get("https://messages.google.com/web")
                    
                    # Staggered delay to avoid overwhelming Google
                    if i < len(browsers_to_use) - 1:
                        time.sleep(int(self.config.get('BROWSER_START_DELAY', 2)))
                    
                    print(f"{self.browser_colors.get(browser, Fore.WHITE)}✅ {browser.title()} ready for authentication{Style.RESET_ALL}")
                else:
                    self.logger.error(f"Failed to create driver for {browser}")
                    
            except Exception as e:
                self.logger.error(f"Failed to initialize {browser}: {e}")
                self.stats[browser].error_count += 1
        
        # Authentication phase
        if self.active_drivers:
            print(f"\n{Fore.YELLOW}📱 AUTHENTICATION REQUIRED{Style.RESET_ALL}")
            print("=" * 40)
            print("Please scan QR codes in each browser with your Google Messages app:")
            
            for browser in self.active_drivers.keys():
                print(f"{self.browser_colors.get(browser, Fore.WHITE)}📲 {browser.title()}: Scan QR code now...{Style.RESET_ALL}")
            
            # Wait for user confirmation
            input(f"\n{Fore.GREEN}Press ENTER when all QR codes have been scanned...{Style.RESET_ALL}")
            
            # Verify authentication
            authenticated_browsers = []
            for browser, driver in self.active_drivers.items():
                if self.verify_authentication(browser, driver):
                    authenticated_browsers.append(browser)
                    self.stats[browser].authentication_status = "authenticated"
                    self.stats[browser].is_active = True
                else:
                    self.stats[browser].authentication_status = "failed"
            
            print(f"\n{Fore.GREEN}🎉 {len(authenticated_browsers)} browsers authenticated successfully!{Style.RESET_ALL}")
            
        return self.active_drivers
    
    def verify_authentication(self, browser: str, driver) -> bool:
        """Verify that browser is authenticated to Google Messages"""
        try:
            # Look for elements that indicate successful authentication
            # This is a simplified check - in practice, you'd want more robust verification
            driver.implicitly_wait(5)
            
            # Check if we can find the compose button or conversation list
            from selenium.webdriver.common.by import By
            from selenium.webdriver.support.ui import WebDriverWait
            from selenium.webdriver.support import expected_conditions as EC
            
            wait = WebDriverWait(driver, 10)
            # Look for the "Start chat" button or conversation list
            start_chat_button = wait.until(
                EC.any_of(
                    EC.presence_of_element_located((By.CSS_SELECTOR, "[data-e2e-start-chat-button]")),
                    EC.presence_of_element_located((By.CSS_SELECTOR, "[aria-label*='Start chat']")),
                    EC.presence_of_element_located((By.CSS_SELECTOR, "button[aria-label*='compose']")),
                    EC.presence_of_element_located((By.CSS_SELECTOR, ".conversation-list"))
                )
            )
            
            if start_chat_button:
                self.logger.info(f"{browser} authenticated successfully")
                return True
                
        except Exception as e:
            self.logger.warning(f"{browser} authentication check failed: {e}")
            
        return False
    
    def send_message_worker(self, browser_name: str, driver, message_queue: queue.Queue):
        """Worker function for sending messages in a specific browser"""
        worker_logger = logging.getLogger(f"worker.{browser_name}")
        
        try:
            while not self.shutdown_event.is_set():
                try:
                    # Get message task with timeout
                    message_task = message_queue.get(timeout=1)
                    
                    if message_task is None:  # Shutdown signal
                        break
                    
                    # Send the message
                    success = self.send_single_message(browser_name, driver, message_task)
                    
                    with self.stats_lock:
                        if success:
                            self.stats[browser_name].messages_sent += 1
                            self.stats[browser_name].last_message_time = datetime.now()
                            message_task.status = "sent"
                            message_task.sent_time = datetime.now()
                        else:
                            self.stats[browser_name].messages_failed += 1
                            message_task.status = "failed"
                    
                    # Put result back for CSV update
                    self.result_queue.put(message_task)
                    
                    # Random delay between messages
                    delay = random.uniform(
                        float(self.config.get('MIN_DELAY', 3)),
                        float(self.config.get('MAX_DELAY', 8))
                    )
                    time.sleep(delay)
                    
                except queue.Empty:
                    continue
                except Exception as e:
                    worker_logger.error(f"Worker error in {browser_name}: {e}")
                    
        except Exception as e:
            worker_logger.error(f"Fatal error in {browser_name} worker: {e}")
            self.stats[browser_name].error_count += 1
        finally:
            worker_logger.info(f"Worker {browser_name} shutting down")
    
    def send_single_message(self, browser_name: str, driver, message_task: MessageTask) -> bool:
        """Send a single message using the specified browser"""
        try:
            from selenium.webdriver.common.by import By
            from selenium.webdriver.support.ui import WebDriverWait
            from selenium.webdriver.support import expected_conditions as EC
            from selenium.webdriver.common.keys import Keys
            
            wait = WebDriverWait(driver, int(self.config.get('ELEMENT_WAIT_TIMEOUT', 10)))
            
            # Find and click "Start chat" button
            start_chat_button = wait.until(
                EC.any_of(
                    EC.element_to_be_clickable((By.CSS_SELECTOR, "[data-e2e-start-chat-button]")),
                    EC.element_to_be_clickable((By.CSS_SELECTOR, "[aria-label*='Start chat']")),
                    EC.element_to_be_clickable((By.CSS_SELECTOR, "button[aria-label*='compose']"))
                )
            )
            start_chat_button.click()
            
            # Enter phone number
            phone_input = wait.until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "input[type='tel'], input[placeholder*='phone'], input[aria-label*='phone']"))
            )
            phone_input.clear()
            phone_input.send_keys(message_task.phone)
            phone_input.send_keys(Keys.ENTER)
            
            # Wait a moment for the conversation to load
            time.sleep(2)
            
            # Find message input and send message
            message_input = wait.until(
                EC.presence_of_element_located((By.CSS_SELECTOR, "[contenteditable='true'], textarea[aria-label*='message'], div[data-e2e-message-input]"))
            )
            message_input.clear()
            message_input.send_keys(message_task.message)
            message_input.send_keys(Keys.ENTER)
            
            # Wait for message to be sent (look for sent indicator)
            time.sleep(1)
            
            self.logger.info(f"{browser_name}: Message sent to {message_task.phone}")
            return True
            
        except Exception as e:
            self.logger.error(f"{browser_name}: Failed to send message to {message_task.phone}: {e}")
            message_task.error_message = str(e)
            return False
    
    def start_monitoring_thread(self):
        """Start the monitoring thread for real-time statistics"""
        def monitor():
            while not self.shutdown_event.is_set():
                self.display_realtime_stats()
                time.sleep(int(self.config.get('MONITOR_INTERVAL', 5)))
        
        monitor_thread = threading.Thread(target=monitor, daemon=True)
        monitor_thread.start()
    
    def display_realtime_stats(self):
        """Display real-time statistics for all browsers"""
        # Clear screen and move cursor to top
        print("\033[2J\033[H", end="")
        
        print(f"{Fore.CYAN}🚀 MULTI-BROWSER SMS DASHBOARD{Style.RESET_ALL}")
        print("=" * 60)
        print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print()
        
        # Browser statistics
        total_sent = 0
        total_failed = 0
        
        for browser_name, stats in self.stats.items():
            if stats.is_active:
                color = self.browser_colors.get(browser_name, Fore.WHITE)
                progress_bar = self.create_progress_bar(stats.messages_sent, 50 if self.total_messages < 50 else self.total_messages // len(self.stats))
                
                print(f"{color}[{browser_name.upper():8}] {progress_bar} {stats.success_rate:5.1f}% | {stats.messages_per_minute:4.1f} msg/min{Style.RESET_ALL}")
                print(f"{color}             Sent: {stats.messages_sent:3d} | Failed: {stats.messages_failed:2d} | Errors: {stats.error_count:2d}{Style.RESET_ALL}")
                
                total_sent += stats.messages_sent
                total_failed += stats.messages_failed
        
        print()
        print(f"{Fore.GREEN}📊 OVERALL PROGRESS{Style.RESET_ALL}")
        print("-" * 30)
        overall_progress = self.create_progress_bar(total_sent, self.total_messages, width=40)
        completion_pct = (total_sent / self.total_messages * 100) if self.total_messages > 0 else 0
        
        print(f"Total Progress: {overall_progress} {completion_pct:.1f}% ({total_sent}/{self.total_messages})")
        
        # Estimated time remaining
        if total_sent > 0:
            avg_rate = sum(s.messages_per_minute for s in self.stats.values() if s.is_active)
            remaining = self.total_messages - total_sent
            if avg_rate > 0:
                eta_minutes = remaining / avg_rate
                print(f"Estimated Time Remaining: {eta_minutes:.1f} minutes")
        
        print()
        print(f"{Fore.YELLOW}💻 SYSTEM STATS{Style.RESET_ALL}")
        print(f"CPU: {psutil.cpu_percent():.1f}% | RAM: {psutil.virtual_memory().percent:.1f}%")
    
    def create_progress_bar(self, current: int, total: int, width: int = 20) -> str:
        """Create a text-based progress bar"""
        if total == 0:
            return "█" * width
        
        filled_width = int(width * current // total)
        bar = "█" * filled_width + "░" * (width - filled_width)
        return f"{bar}"
    
    def run_parallel_sending(self, messages: List[MessageTask]) -> Dict[str, any]:
        """Main method to run parallel message sending"""
        if not messages:
            self.logger.error("No messages to send")
            return {"success": False, "error": "No messages provided"}
        
        # Get available browsers
        available_browsers = [b for b, s in self.stats.items() if s.is_active]
        
        if not available_browsers:
            self.logger.error("No authenticated browsers available")
            return {"success": False, "error": "No authenticated browsers"}
        
        # Distribute messages to browsers
        for i, message in enumerate(messages):
            if message.browser_assigned not in available_browsers:
                message.browser_assigned = available_browsers[i % len(available_browsers)]
            self.message_queue.put(message)
        
        # Start monitoring
        if self.config.get('ENABLE_MONITORING', True):
            self.start_monitoring_thread()
        
        # Start worker threads
        workers = []
        for browser_name in available_browsers:
            if browser_name in self.active_drivers:
                driver = self.active_drivers[browser_name]
                worker = threading.Thread(
                    target=self.send_message_worker,
                    args=(browser_name, driver, self.message_queue),
                    name=f"worker-{browser_name}"
                )
                worker.start()
                workers.append(worker)
        
        self.logger.info(f"Started {len(workers)} worker threads")
        
        # Wait for completion or handle interruption
        try:
            # Wait for all messages to be processed
            while True:
                total_processed = sum(s.messages_sent + s.messages_failed for s in self.stats.values())
                if total_processed >= self.total_messages:
                    break
                time.sleep(1)
            
            # Signal workers to stop
            self.shutdown_event.set()
            
            # Add None messages to wake up waiting workers
            for _ in available_browsers:
                self.message_queue.put(None)
            
            # Wait for all workers to finish
            for worker in workers:
                worker.join(timeout=10)
            
            # Collect results
            results = []
            while not self.result_queue.empty():
                results.append(self.result_queue.get())
            
            return {
                "success": True,
                "results": results,
                "stats": self.stats,
                "total_sent": sum(s.messages_sent for s in self.stats.values()),
                "total_failed": sum(s.messages_failed for s in self.stats.values())
            }
            
        except KeyboardInterrupt:
            self.logger.info("Received interrupt signal, shutting down...")
            self.shutdown_gracefully()
            return {"success": False, "error": "Interrupted by user"}
        
        except Exception as e:
            self.logger.error(f"Fatal error during parallel sending: {e}")
            self.shutdown_gracefully()
            return {"success": False, "error": str(e)}
    
    def shutdown_gracefully(self):
        """Gracefully shutdown all browsers and workers"""
        self.logger.info("Shutting down gracefully...")
        
        # Signal shutdown
        self.shutdown_event.set()
        
        # Close all browser drivers
        for browser_name, driver in self.active_drivers.items():
            try:
                driver.quit()
                self.logger.info(f"Closed {browser_name} browser")
            except Exception as e:
                self.logger.error(f"Error closing {browser_name}: {e}")
        
        # Clear active drivers
        self.active_drivers.clear()
    
    def save_results_to_csv(self, results: List[MessageTask], output_file: str):
        """Save results back to CSV file"""
        try:
            # Create DataFrame from results
            data = []
            for result in results:
                data.append({
                    'phone': result.phone,
                    'message': result.message,
                    'browser_assigned': result.browser_assigned,
                    'status': result.status,
                    'sent_time': result.sent_time.isoformat() if result.sent_time else '',
                    'error_message': result.error_message
                })
            
            df = pd.DataFrame(data)
            df.to_csv(output_file, index=False)
            self.logger.info(f"Results saved to {output_file}")
            
        except Exception as e:
            self.logger.error(f"Failed to save results to {output_file}: {e}")

    def print_final_report(self, results: Dict[str, any]):
        """Print final summary report"""
        print(f"\n{Fore.CYAN}📊 FINAL REPORT{Style.RESET_ALL}")
        print("=" * 40)
        
        total_sent = results.get('total_sent', 0)
        total_failed = results.get('total_failed', 0)
        
        print(f"{Fore.GREEN}✅ Messages Sent: {total_sent}{Style.RESET_ALL}")
        print(f"{Fore.RED}❌ Messages Failed: {total_failed}{Style.RESET_ALL}")
        print(f"{Fore.YELLOW}📈 Success Rate: {(total_sent/(total_sent+total_failed)*100):.1f}%{Style.RESET_ALL}")
        
        print(f"\n{Fore.CYAN}🌐 BROWSER PERFORMANCE{Style.RESET_ALL}")
        print("-" * 30)
        
        for browser_name, stats in results.get('stats', {}).items():
            if stats.is_active:
                color = self.browser_colors.get(browser_name, Fore.WHITE)
                print(f"{color}{browser_name.title():10} | Sent: {stats.messages_sent:3d} | Rate: {stats.messages_per_minute:5.1f} msg/min{Style.RESET_ALL}")