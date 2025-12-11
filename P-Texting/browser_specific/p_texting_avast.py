#!/usr/bin/env python3
"""
P-TEXTING - VIVALDI VERSION
Standalone Vivaldi-only version with dedicated GUI

This is a completely separate program for Vivaldi browser.
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import json
import sys
import subprocess
from pathlib import Path
import os

class PTextingVivaldi:
    def __init__(self, root):
        self.root = root
        self.root.title("P-Texting - AVAST VERSION")
        self.root.geometry("800x900")
        
        # Config file
        self.config_file = "config_AVAST.json"
        
        # Create main frame
        main_frame = ttk.Frame(root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Header
        header = ttk.Label(main_frame, text="P-TEXTING - AVAST VERSION", 
                          font=('Arial', 16, 'bold'), foreground='darkgreen')
        header.grid(row=0, column=0, columnspan=3, pady=10)
        
        info_label = ttk.Label(main_frame, text="✅ AVAST keeps you logged in - Security-focused!", 
                              foreground='green')
        info_label.grid(row=1, column=0, columnspan=3, pady=5)
        
        row = 2
        
        # Note about AVAST profile - not needed for remote debugging
        note_label = ttk.Label(main_frame, text="ℹ️ AVAST profile auto-detected from running AVAST instance", 
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
        
        # Account Label (hardcoded for AVAST)
        ttk.Label(settings_frame, text="Account Label:").grid(row=1, column=0, sticky=tk.W, pady=5)
        self.account_label_var = tk.StringVar(value="account6")
        account_entry = ttk.Entry(settings_frame, textvariable=self.account_label_var, width=20, state='readonly')
        account_entry.grid(row=1, column=1, sticky=tk.W, pady=5)
        ttk.Label(settings_frame, text="(Auto: AVAST = account6)", foreground='gray', font=('Arial', 8)).grid(row=1, column=2, sticky=tk.W, padx=5)
        
        # Buttons Frame
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=row, column=0, columnspan=3, pady=20)
        row += 1
        
        ttk.Button(button_frame, text="💾 Save Config", command=self.save_config, width=20).grid(row=0, column=0, padx=5)
        ttk.Button(button_frame, text="📂 Load Config", command=self.load_config, width=20).grid(row=0, column=1, padx=5)
        ttk.Button(button_frame, text="🚀 Start AVAST Debug", command=self.start_AVAST_debug, width=20).grid(row=0, column=2, padx=5)
        
        ttk.Button(button_frame, text="✉️ SEND MESSAGES", command=self.send_messages, width=30, 
                  style='Accent.TButton').grid(row=1, column=0, columnspan=2, pady=10)
        ttk.Button(button_frame, text="⏸️ STOP SENDING", command=self.stop_sending, width=20).grid(row=1, column=2, pady=10)
        
        ttk.Button(button_frame, text="📊 Open Report", command=self.open_report, width=30).grid(row=3, column=0, columnspan=2, padx=5)
        
        # Status
        self.status_var = tk.StringVar(value="Ready - AVAST Version")
        status_label = ttk.Label(main_frame, textvariable=self.status_var, foreground='blue')
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
            "browser": "AVAST",
            "browser_profile_path": "C:\\temp\\AVAST_debug_profile",  # Auto from start_AVAST_debug.bat
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
            "database_path": "progress_AVAST.db",
            "log_path": ".\\logs\\run_AVAST.log",
            "remote_debugging_port": 9227
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
            
            # Profile path auto-detected from running AVAST, no need to show/load
            self.csv_path_var.set(config.get('input_path', ''))
            self.image_path_var.set(config.get('image_path', ''))
            self.salutation_var.set(config.get('salutation', 'Attn: {name},'))
            self.message_text.delete("1.0", tk.END)
            self.message_text.insert("1.0", config.get('message_text', ''))
            self.batch_size_var.set(config.get('batch_size', 7))
            self.daily_limit_var.set(config.get('daily_limit', 250))
            self.account_label_var.set(config.get('account_label', 'account6'))
            
            self.status_var.set(f"✅ Config loaded from {self.config_file}")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to load config: {e}")
    
    def start_AVAST_debug(self):
        """Launch AVAST with remote debugging"""
        bat_file = Path("start_AVAST_debug.bat")
        if not bat_file.exists():
            messagebox.showerror("Error", "start_AVAST_debug.bat not found!")
            return
        
        try:
            # Use CREATE_NEW_CONSOLE to show the batch file window
            subprocess.Popen([str(bat_file.absolute())], 
                           shell=True, 
                           creationflags=subprocess.CREATE_NEW_CONSOLE)
            self.status_var.set("🚀 AVAST debug mode started - Check the new window")
            messagebox.showinfo("AVAST Started", 
                              "AVAST has been started with remote debugging.\n\n"
                              "1. Log in to Google Voice if needed\n"
                              "2. Come back here and click 'SEND MESSAGES'")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to start AVAST: {e}")
    
    def stop_sending(self):
        """Create stop signal file to pause sending"""
        try:
            stop_file = Path("STOP_SENDING.txt")
            stop_file.write_text("STOP")
            self.status_var.set("⏸️ Stop signal sent - will stop after current message")
            messagebox.showinfo("Stop Signal Sent", 
                              "The sending will stop after the current message completes.\n\n"
                              "Your progress is saved!\n"
                              "Click 'SEND MESSAGES' again to resume.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to create stop signal: {e}")
    
    def send_messages(self):
        """Run the AVAST-specific send script"""
        # Remove stop signal file if it exists
        try:
            stop_file = Path("STOP_SENDING.txt")
            if stop_file.exists():
                stop_file.unlink()
        except:
            pass
        
        # Save config first
        self.save_config()
        
        script = Path("send_texts_date_filter_AVAST.py")
        if not script.exists():
            messagebox.showerror("Error", "send_texts_date_filter_AVAST.py not found!")
            return
        
        # Check if config has required fields
        if not self.csv_path_var.get():
            messagebox.showerror("Error", "Please select a CSV file first!")
            return
        
        if not self.message_text.get("1.0", tk.END).strip():
            messagebox.showerror("Error", "Please enter message text!")
            return
        
        try:
            self.status_var.set("📤 Sending messages via AVAST...")
            # Run in new console window so user can see progress
            subprocess.Popen([sys.executable, str(script.absolute())],
                           creationflags=subprocess.CREATE_NEW_CONSOLE)
            messagebox.showinfo("Started", 
                              "Message sending started!\n\n"
                              "Check the new console window for progress.\n"
                              "AVAST will stay open when done.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to start sending: {e}")
            self.status_var.set("❌ Error starting message send")
    
    def open_report(self):
        """Generate and open report"""
        try:
            subprocess.Popen([sys.executable, "generate_report.py", "config_AVAST.json"],
                           creationflags=subprocess.CREATE_NEW_CONSOLE)
            self.status_var.set("📊 Generating report...")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to generate report: {e}")
    

if __name__ == "__main__":
    root = tk.Tk()
    app = PTextingAVAST(root)
    root.mainloop()
