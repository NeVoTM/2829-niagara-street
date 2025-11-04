#!/usr/bin/env python3
"""
Multi-Browser SMS System
Main application that orchestrates parallel SMS sending across multiple browsers
"""

import os
import sys
import argparse
import signal
import time
from datetime import datetime
from pathlib import Path
from dotenv import load_dotenv
from colorama import Fore, Style, init

# Initialize colorama for Windows
init(autoreset=True)

# Add current directory to path for imports
sys.path.append(str(Path(__file__).parent))

from browser_config import BrowserConfigManager
from multi_browser_manager import MultiBrowserManager

class MultiBrowserSMSApp:
    def __init__(self):
        self.browser_config_manager = None
        self.multi_browser_manager = None
        self.config = {}
        self.setup_signal_handlers()
    
    def setup_signal_handlers(self):
        """Setup signal handlers for graceful shutdown"""
        def signal_handler(signum, frame):
            print(f"\n{Fore.YELLOW}🛑 Received shutdown signal, cleaning up...{Style.RESET_ALL}")
            if self.multi_browser_manager:
                self.multi_browser_manager.shutdown_gracefully()
            sys.exit(0)
        
        signal.signal(signal.SIGINT, signal_handler)  # Ctrl+C
        signal.signal(signal.SIGTERM, signal_handler)  # Termination
    
    def load_configuration(self):
        """Load configuration from .env file"""
        load_dotenv()
        
        self.config = {
            # Timing settings
            'MIN_DELAY': int(os.getenv('MIN_DELAY', 3)),
            'MAX_DELAY': int(os.getenv('MAX_DELAY', 8)),
            'BROWSER_START_DELAY': int(os.getenv('BROWSER_START_DELAY', 2)),
            
            # Safety limits
            'DAILY_MESSAGE_LIMIT': int(os.getenv('DAILY_MESSAGE_LIMIT', 1000)),
            'MAX_RETRIES': int(os.getenv('MAX_RETRIES', 3)),
            'RETRY_DELAY': int(os.getenv('RETRY_DELAY', 5)),
            
            # Browser settings
            'MAX_CONCURRENT_BROWSERS': int(os.getenv('MAX_CONCURRENT_BROWSERS', 10)),
            'HEADLESS_MODE': os.getenv('HEADLESS_MODE', 'false').lower() == 'true',
            
            # Logging
            'LOG_LEVEL': os.getenv('LOG_LEVEL', 'INFO'),
            'LOG_RETENTION_DAYS': int(os.getenv('LOG_RETENTION_DAYS', 7)),
            
            # Google Messages settings
            'PAGE_LOAD_TIMEOUT': int(os.getenv('PAGE_LOAD_TIMEOUT', 30)),
            'ELEMENT_WAIT_TIMEOUT': int(os.getenv('ELEMENT_WAIT_TIMEOUT', 10)),
            'AUTH_TIMEOUT': int(os.getenv('AUTH_TIMEOUT', 300)),
            
            # Performance
            'ENABLE_MONITORING': os.getenv('ENABLE_MONITORING', 'true').lower() == 'true',
            'MONITOR_INTERVAL': int(os.getenv('MONITOR_INTERVAL', 5)),
        }
    
    def create_directories(self):
        """Create necessary directories"""
        directories = ['logs', 'browser_profiles', 'drivers']
        for dir_name in directories:
            os.makedirs(dir_name, exist_ok=True)
    
    def print_banner(self):
        """Print application banner"""
        banner = f"""
{Fore.CYAN}
╔══════════════════════════════════════════════════════════╗
║                 🚀 MULTI-BROWSER SMS SYSTEM 🚀          ║
║                                                          ║
║  🌐 Parallel Processing Across Multiple Browsers        ║
║  ⚡ 5-10x Faster Than Single Browser                    ║
║  🛡️ Built-in Rate Limiting & Error Recovery             ║
║  📊 Real-time Monitoring & Statistics                   ║
╚══════════════════════════════════════════════════════════╝
{Style.RESET_ALL}
"""
        print(banner)
    
    def initialize_system(self):
        """Initialize browser configuration and multi-browser manager"""
        print(f"{Fore.YELLOW}🔧 Initializing system...{Style.RESET_ALL}")
        
        # Initialize browser configuration manager
        self.browser_config_manager = BrowserConfigManager()
        
        # Setup drivers
        self.browser_config_manager.setup_drivers()
        
        # Print browser summary
        self.browser_config_manager.print_summary()
        
        # Check if we have any browsers
        available_browsers = self.browser_config_manager.get_available_browsers()
        if not available_browsers:
            print(f"{Fore.RED}❌ No browsers detected! Please install at least one supported browser.{Style.RESET_ALL}")
            return False
        
        # Initialize multi-browser manager
        self.multi_browser_manager = MultiBrowserManager(
            self.browser_config_manager, 
            self.config
        )
        
        return True
    
    def validate_csv_file(self, csv_file: str) -> bool:
        """Validate CSV file exists and has required columns"""
        if not os.path.exists(csv_file):
            print(f"{Fore.RED}❌ CSV file not found: {csv_file}{Style.RESET_ALL}")
            return False
        
        try:
            import pandas as pd
            df = pd.read_csv(csv_file)
            
            required_columns = ['phone', 'message']
            missing_columns = [col for col in required_columns if col not in df.columns]
            
            if missing_columns:
                print(f"{Fore.RED}❌ CSV file missing required columns: {missing_columns}{Style.RESET_ALL}")
                return False
            
            if len(df) == 0:
                print(f"{Fore.RED}❌ CSV file is empty{Style.RESET_ALL}")
                return False
            
            print(f"{Fore.GREEN}✅ CSV file validated: {len(df)} messages found{Style.RESET_ALL}")
            return True
            
        except Exception as e:
            print(f"{Fore.RED}❌ Error reading CSV file: {e}{Style.RESET_ALL}")
            return False
    
    def select_browsers(self, available_browsers: list, max_browsers: int = None) -> list:
        """Allow user to select which browsers to use"""
        if max_browsers is None:
            max_browsers = self.config['MAX_CONCURRENT_BROWSERS']
        
        print(f"\\n{Fore.CYAN}🌐 Available Browsers:{Style.RESET_ALL}")
        for i, browser in enumerate(available_browsers, 1):
            print(f"  {i}. {browser.title()}")
        
        print(f"\\n{Fore.YELLOW}Select browsers to use (or press Enter for all):{Style.RESET_ALL}")
        user_input = input(f"Enter numbers separated by commas (1-{len(available_browsers)}): ").strip()
        
        if not user_input:
            # Use all browsers, but limit to max_browsers
            selected = available_browsers[:max_browsers]
        else:
            try:
                indices = [int(x.strip()) - 1 for x in user_input.split(',')]
                selected = [available_browsers[i] for i in indices if 0 <= i < len(available_browsers)]
                selected = selected[:max_browsers]  # Limit to max_browsers
            except (ValueError, IndexError):
                print(f"{Fore.YELLOW}⚠️ Invalid selection, using all available browsers{Style.RESET_ALL}")
                selected = available_browsers[:max_browsers]
        
        print(f"{Fore.GREEN}✅ Selected browsers: {', '.join([b.title() for b in selected])}{Style.RESET_ALL}")
        return selected
    
    def run_sms_campaign(self, csv_file: str, output_file: str = None, auto_select_browsers: bool = False):
        """Run the SMS campaign"""
        try:
            # Load messages from CSV
            messages = self.multi_browser_manager.load_messages_from_csv(csv_file)
            if not messages:
                print(f"{Fore.RED}❌ No messages to send{Style.RESET_ALL}")
                return False
            
            # Check daily limit
            if len(messages) > self.config['DAILY_MESSAGE_LIMIT']:
                print(f"{Fore.YELLOW}⚠️ Message count ({len(messages)}) exceeds daily limit ({self.config['DAILY_MESSAGE_LIMIT']}){Style.RESET_ALL}")
                if input("Continue anyway? (y/N): ").lower() != 'y':
                    return False
            
            # Select browsers to use
            available_browsers = self.browser_config_manager.get_available_browsers()
            
            if auto_select_browsers:
                selected_browsers = available_browsers[:self.config['MAX_CONCURRENT_BROWSERS']]
            else:
                selected_browsers = self.select_browsers(available_browsers)
            
            # Initialize browsers and authenticate
            active_drivers = self.multi_browser_manager.initialize_browsers(selected_browsers)
            
            if not active_drivers:
                print(f"{Fore.RED}❌ No browsers successfully initialized{Style.RESET_ALL}")
                return False
            
            # Start the SMS campaign
            print(f"\\n{Fore.CYAN}🚀 STARTING SMS CAMPAIGN{Style.RESET_ALL}")
            print("=" * 50)
            print(f"Messages to send: {len(messages)}")
            print(f"Active browsers: {len(active_drivers)}")
            print(f"Expected rate: {len(active_drivers) * 12:.0f}-{len(active_drivers) * 18:.0f} messages/minute")
            print()
            
            # Countdown
            for i in range(3, 0, -1):
                print(f"Starting in {i}...", end="\\r")
                time.sleep(1)
            print("🚀 LAUNCHING!     ")
            
            # Run parallel sending
            results = self.multi_browser_manager.run_parallel_sending(messages)
            
            # Print final report
            self.multi_browser_manager.print_final_report(results)
            
            # Save results if requested
            if output_file:
                self.multi_browser_manager.save_results_to_csv(results.get('results', []), output_file)
            
            return results.get('success', False)
            
        except Exception as e:
            print(f"{Fore.RED}❌ Fatal error during SMS campaign: {e}{Style.RESET_ALL}")
            return False
    
    def cleanup(self):
        """Cleanup resources"""
        if self.multi_browser_manager:
            self.multi_browser_manager.shutdown_gracefully()


def main():
    """Main application entry point"""
    parser = argparse.ArgumentParser(
        description='Multi-Browser SMS System - Send messages via Google Messages using multiple browsers',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python multi_browser_sms.py --file sample_recipients.csv
  python multi_browser_sms.py --file contacts.csv --output results.csv --auto-browsers
  python multi_browser_sms.py --test
        """
    )
    
    parser.add_argument(
        '--file', '-f',
        type=str,
        help='CSV file containing phone numbers and messages'
    )
    
    parser.add_argument(
        '--output', '-o',
        type=str,
        help='Output CSV file for results (optional)'
    )
    
    parser.add_argument(
        '--auto-browsers',
        action='store_true',
        help='Automatically select all available browsers without prompting'
    )
    
    parser.add_argument(
        '--test',
        action='store_true',
        help='Test browser detection and driver setup only'
    )
    
    parser.add_argument(
        '--config',
        type=str,
        help='Path to custom .env configuration file'
    )
    
    args = parser.parse_args()
    
    # Initialize application
    app = MultiBrowserSMSApp()
    
    try:
        # Load custom config if specified
        if args.config:
            if os.path.exists(args.config):
                load_dotenv(args.config)
            else:
                print(f"{Fore.YELLOW}⚠️ Config file not found: {args.config}, using default settings{Style.RESET_ALL}")
        
        # Load configuration
        app.load_configuration()
        
        # Create directories
        app.create_directories()
        
        # Print banner
        app.print_banner()
        
        # Initialize system
        if not app.initialize_system():
            print(f"{Fore.RED}❌ System initialization failed{Style.RESET_ALL}")
            sys.exit(1)
        
        # Test mode - just check browser detection
        if args.test:
            print(f"\\n{Fore.GREEN}✅ Test completed successfully!{Style.RESET_ALL}")
            print("All browsers detected and drivers configured.")
            print("You can now run the SMS campaign with --file parameter.")
            return
        
        # Validate input file
        if not args.file:
            print(f"{Fore.RED}❌ Please specify a CSV file with --file parameter{Style.RESET_ALL}")
            print(f"Example: python multi_browser_sms.py --file sample_recipients.csv")
            sys.exit(1)
        
        if not app.validate_csv_file(args.file):
            sys.exit(1)
        
        # Set default output file if not specified
        if not args.output:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            args.output = f"results_{timestamp}.csv"
        
        # Run SMS campaign
        success = app.run_sms_campaign(
            csv_file=args.file,
            output_file=args.output,
            auto_select_browsers=args.auto_browsers
        )
        
        if success:
            print(f"\\n{Fore.GREEN}🎉 SMS campaign completed successfully!{Style.RESET_ALL}")
            print(f"Results saved to: {args.output}")
        else:
            print(f"\\n{Fore.YELLOW}⚠️ SMS campaign completed with issues{Style.RESET_ALL}")
            sys.exit(1)
    
    except KeyboardInterrupt:
        print(f"\\n{Fore.YELLOW}🛑 Application interrupted by user{Style.RESET_ALL}")
    
    except Exception as e:
        print(f"\\n{Fore.RED}❌ Unexpected error: {e}{Style.RESET_ALL}")
        sys.exit(1)
    
    finally:
        # Cleanup
        app.cleanup()
        print(f"\\n{Fore.CYAN}👋 Goodbye! Thanks for using Multi-Browser SMS System{Style.RESET_ALL}")


if __name__ == "__main__":
    main()