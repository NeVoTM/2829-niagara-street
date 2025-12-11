#!/usr/bin/env python3
"""
P-TEXTING - FIREFOX VERSION
Standalone Firefox-only version with dedicated GUI

⚠️ FIREFOX LIMITATIONS:
- Launches NEW Firefox instance each time
- You MUST log in to Google Voice every session  
- Use this as BACKUP when Chrome hits daily limit

RECOMMENDED: Use p_texting_chrome.py as your primary tool
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import json
import sys
import subprocess
from pathlib import Path
import os

class PTextingFirefox:
    def __init__(self, root):
        self.root = root
        self.root.title("P-Texting - FIREFOX VERSION (BACKUP)")
        self.root.geometry("800x950")
        
        # Config file
        self.config_file = "config_firefox.json"
        
        # Create main frame
        main_frame = ttk.Frame(root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Header
        header = ttk.Label(main_frame, text="P-TEXTING - FIREFOX VERSION", 
                          font=('Arial', 16, 'bold'), foreground='orange')
        header.grid(row=0, column=0, columnspan=3, pady=10)
        
        # Warning
        warning_frame = ttk.Frame(main_frame, relief='solid', borderwidth=2)
        warning_frame.grid(row=1, column=0, columnspan=3, pady=5, padx=10, sticky=(tk.W, tk.E))
        
        warning_text = (
            "⚠️ FIREFOX LIMITATIONS:\n"
            "• Launches NEW Firefox instance each time\n"
            "• You MUST log in to Google Voice every session\n"
            "• Use as BACKUP when Chrome hits daily limit\n\n"
            "✅ RECOMMENDED: Use Chrome version as primary"
        )
        ttk.Label(warning_frame, text=warning_text, foreground='red', 
                 justify=tk.LEFT, padding=10).pack()
        
        row = 2
        
        # Note about Firefox - launches new instance each time
        note_label = ttk.Label(main_frame, text="ℹ️ Firefox launches new instance each time (no profile needed)", 
                              foreground='gray', font=('Arial', 9, 'italic'))
        note_label.grid(row=row, column=0, columnspan=3, pady=5)
        row += 1
        
        # CSV File
        ttk.Label(main_frame, text="Contact CSV File:").grid(row=row, column=0, sticky=tk.W, pady=5)
        self.csv_path_var = tk.StringVar()
        ttk.Entry(main_frame, textvariable=self.csv_path_var, width=60).grid(row=row, column=1, pady=5)
        ttk.Button(main_frame, text="Browse", command=self.browse_csv).grid(row=row, column=2, pady=5)
        row += 1
        
        # Image File
        ttk.Label(main_frame, text="Image (Optional):").grid(row=row, column=0, sticky=tk.W, pady=5)
        self.image_path_var = tk.StringVar()
        ttk.Entry(main_frame, textvariable=self.image_path_var, width=60).grid(row=row, column=1, pady=5)
        ttk.Button(main_frame, text="Browse", command=self.browse_image).grid(row=row, column=2, pady=5)
        row += 1
        
        # Salutation
        ttk.Label(main_frame, text="Salutation (use {name}):").grid(row=row, column=0, sticky=tk.W, pady=5)
        self.salutation_var = tk.StringVar(value="Attn: {name},")
        ttk.Entry(main_frame, textvariable=self.salutation_var, width=60).grid(row=row, column=1, columnspan=2, pady=5)
        row += 1
        
        # Message Text
        ttk.Label(main_frame, text="Message Text:").grid(row=row, column=0, sticky=tk.W, pady=5)
        row += 1
        self.message_text = scrolledtext.ScrolledText(main_frame, width=70, height=8)
        self.message_text.grid(row=row, column=0, columnspan=3, pady=5)
        row += 1
        
        # Settings Frame
        settings_frame = ttk.LabelFrame(main_frame, text="Settings", padding="10")
        settings_frame.grid(row=row, column=0, columnspan=3, pady=10, sticky=(tk.W, tk.E))
        row += 1
        
        # Batch Size
        ttk.Label(settings_frame, text="Batch Size:").grid(row=0, column=0, sticky=tk.W)
        self.batch_size_var = tk.IntVar(value=7)
        ttk.Entry(settings_frame, textvariable=self.batch_size_var, width=10).grid(row=0, column=1, sticky=tk.W)
        
        # Daily Limit
        ttk.Label(settings_frame, text="Daily Limit:").grid(row=0, column=2, sticky=tk.W, padx=(20,0))
        self.daily_limit_var = tk.IntVar(value=250)
        ttk.Entry(settings_frame, textvariable=self.daily_limit_var, width=10).grid(row=0, column=3, sticky=tk.W)
        
        # Account Label (hardcoded for Firefox)
        ttk.Label(settings_frame, text="Account Label:").grid(row=1, column=0, sticky=tk.W, pady=5)
        self.account_label_var = tk.StringVar(value="account2")
        account_entry = ttk.Entry(settings_frame, textvariable=self.account_label_var, width=20, state='readonly')
        account_entry.grid(row=1, column=1, sticky=tk.W, pady=5)
        ttk.Label(settings_frame, text="(Auto: Firefox = account2)", foreground='gray', font=('Arial', 8)).grid(row=1, column=2, sticky=tk.W, padx=5)
        
        # Buttons Frame
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=row, column=0, columnspan=3, pady=20)
        row += 1
        
        ttk.Button(button_frame, text="💾 Save Config", command=self.save_config, width=20).grid(row=0, column=0, padx=5)
        ttk.Button(button_frame, text="📂 Load Config", command=self.load_config, width=20).grid(row=0, column=1, padx=5)
        
        ttk.Button(button_frame, text="✉️ SEND MESSAGES", command=self.send_messages, width=30, 
                  style='Accent.TButton').grid(row=1, column=0, columnspan=2, pady=10)
        
        # Stop button
        stop_btn = ttk.Button(button_frame, text="⏸️ STOP SENDING", command=self.stop_sending, width=30)
        stop_btn.grid(row=2, column=0, columnspan=2, pady=5)
        
        ttk.Button(button_frame, text="📊 Open Report", command=self.open_report, width=30).grid(row=3, column=0, columnspan=2, padx=5)
        
        # Status
        self.status_var = tk.StringVar(value="Ready - Firefox Version (Backup)")
        status_label = ttk.Label(main_frame, textvariable=self.status_var, foreground='orange')
        status_label.grid(row=row, column=0, columnspan=3, pady=10)
        
        # Load config on startup
        self.load_config()
    
    
    def browse_csv(self):
        path = filedialog.askopenfilename(title="Select CSV File", 
                                         filetypes=[("CSV files", "*.csv"), ("All files", "*.*")])
        if path:
            self.csv_path_var.set(path)
    
    def browse_image(self):
        path = filedialog.askopenfilename(title="Select Image", 
                                         filetypes=[("Image files", "*.jpg *.jpeg *.png"), ("All files", "*.*")])
        if path:
            self.image_path_var.set(path)
    
    def save_config(self):
        config = {
            "browser": "firefox",
            "browser_profile_path": "",  # Not used - Firefox launches new instance
            "browser_binary_path": "",
            "input_path": self.csv_path_var.get(),
            "phone_column": "Phone",
            "name_column": "Name",
            "date_column": "Date",
            "message_text": self.message_text.get("1.0", tk.END).strip(),
            "salutation": self.salutation_var.get(),
            "image_path": self.image_path_var.get(),
            "batch_size": self.batch_size_var.get(),
            "delay_between_batches_seconds": 45,
            "batch_delay_jitter_seconds": 10,
            "daily_limit": self.daily_limit_var.get(),
            "max_retries": 3,
            "per_message_delay_seconds": 2,
            "region_default_country_code": "US",
            "account_label": self.account_label_var.get(),
            "database_path": "progress_firefox.db",
            "log_path": ".\\logs\\run_firefox.log",
            "remote_debugging_port": 6000
        }
        
        try:
            with open(self.config_file, 'w') as f:
                json.dump(config, f, indent=2)
            self.status_var.set(f"✅ Config saved to {self.config_file}")
            messagebox.showinfo("Success", "Configuration saved successfully!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to save config: {e}")
    
    def load_config(self):
        if not Path(self.config_file).exists():
            self.status_var.set(f"No config file found - using defaults")
            return
        
        try:
            with open(self.config_file, 'r') as f:
                config = json.load(f)
            
            # Profile path not used for Firefox (launches new instance)
            self.csv_path_var.set(config.get('input_path', ''))
            self.image_path_var.set(config.get('image_path', ''))
            self.salutation_var.set(config.get('salutation', 'Attn: {name},'))
            self.message_text.delete("1.0", tk.END)
            self.message_text.insert("1.0", config.get('message_text', ''))
            self.batch_size_var.set(config.get('batch_size', 7))
            self.daily_limit_var.set(config.get('daily_limit', 250))
            self.account_label_var.set(config.get('account_label', 'account2'))
            
            self.status_var.set(f"✅ Config loaded from {self.config_file}")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load config: {e}")
    
    def send_messages(self):
        """Run the Firefox-specific send script"""
        # Save config first
        self.save_config()
        
        script = Path("send_texts_date_filter_firefox.py")
        if not script.exists():
            messagebox.showerror("Error", "send_texts_date_filter_firefox.py not found!")
            return
        
        # Check if config has required fields
        if not self.csv_path_var.get():
            messagebox.showerror("Error", "Please select a CSV file first!")
            return
        
        if not self.message_text.get("1.0", tk.END).strip():
            messagebox.showerror("Error", "Please enter message text!")
            return
        
        try:
            self.status_var.set("📤 Sending messages via Firefox...")
            # Run in new console window so user can see progress
            subprocess.Popen([sys.executable, str(script.absolute())],
                           creationflags=subprocess.CREATE_NEW_CONSOLE)
            messagebox.showinfo("Firefox Started", 
                              "Firefox is launching automatically!\n\n"
                              "What happens next:\n"
                              "1. Firefox will close/reopen\n"
                              "2. Google Voice will open\n"
                              "3. You have 30 seconds to log in\n"
                              "4. Messages will send automatically\n\n"
                              "Watch the console window for progress!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to start sending: {e}")
            self.status_var.set("❌ Error starting message send")
    
    def open_report(self):
        """Generate and open report"""
        try:
            subprocess.Popen([sys.executable, "generate_report.py", "config_firefox.json"],
                           creationflags=subprocess.CREATE_NEW_CONSOLE)
            self.status_var.set("📊 Generating report...")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to generate report: {e}")
    
    def stop_sending(self):
        """Create stop file to halt sending process"""
        try:
            stop_file = Path("STOP_SENDING.txt")
            with open(stop_file, 'w') as f:
                f.write("STOP")
            
            self.status_var.set("🛑 Stop signal sent - will stop after current message")
            messagebox.showinfo("Stop Signal", 
                              "Stop command sent!\n\n"
                              "The system will stop after the current message.\n"
                              "Progress is saved - you can resume later by clicking SEND MESSAGES.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to stop: {e}")

if __name__ == "__main__":
    root = tk.Tk()
    app = PTextingFirefox(root)
    root.mainloop()
