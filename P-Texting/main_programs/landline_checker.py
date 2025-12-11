#!/usr/bin/env python3
"""
Landline Checker - Standalone Tool
Checks if phone numbers are landlines using carrier lookup APIs
Does NOT integrate with P-Texting - completely separate for testing
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox, scrolledtext
import pandas as pd
import phonenumbers
from pathlib import Path
import requests
import json
from datetime import datetime

class LandlineChecker:
    def __init__(self, root):
        self.root = root
        self.root.title("Landline Checker - Testing Tool")
        self.root.geometry("900x700")
        
        # API credentials
        self.api_key_var = tk.StringVar()
        
        # Main frame
        main_frame = ttk.Frame(root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        # Header
        header = ttk.Label(main_frame, text="📞 LANDLINE CHECKER", 
                          font=('Arial', 16, 'bold'), foreground='blue')
        header.grid(row=0, column=0, columnspan=3, pady=10)
        
        # Info
        info_text = (
            "⚠️ TESTING TOOL - Does not affect P-Texting database\n"
            "Use this to test phone numbers and identify landlines"
        )
        ttk.Label(main_frame, text=info_text, foreground='orange', 
                 justify=tk.LEFT).grid(row=1, column=0, columnspan=3, pady=5)
        
        row = 2
        
        # API Selection
        ttk.Label(main_frame, text="API Service:").grid(row=row, column=0, sticky=tk.W, pady=5)
        self.api_service = tk.StringVar(value="numverify")
        api_combo = ttk.Combobox(main_frame, textvariable=self.api_service, 
                                 values=["numverify", "twilio", "manual"], width=20)
        api_combo.grid(row=row, column=1, sticky=tk.W, pady=5)
        ttk.Label(main_frame, text="(numverify: 250 free/month)", 
                 foreground='gray', font=('Arial', 8)).grid(row=row, column=2, sticky=tk.W, padx=5)
        row += 1
        
        # API Key
        ttk.Label(main_frame, text="API Key:").grid(row=row, column=0, sticky=tk.W, pady=5)
        ttk.Entry(main_frame, textvariable=self.api_key_var, width=50).grid(row=row, column=1, columnspan=2, pady=5)
        row += 1
        
        ttk.Label(main_frame, text="Get free key at: https://numverify.com/", 
                 foreground='blue', font=('Arial', 8), cursor="hand2").grid(row=row, column=1, sticky=tk.W)
        row += 1
        
        # Separator
        ttk.Separator(main_frame, orient='horizontal').grid(row=row, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=10)
        row += 1
        
        # Input Methods Frame
        input_frame = ttk.LabelFrame(main_frame, text="Input Method", padding="10")
        input_frame.grid(row=row, column=0, columnspan=3, pady=10, sticky=(tk.W, tk.E))
        row += 1
        
        # CSV File
        ttk.Label(input_frame, text="CSV File:").grid(row=0, column=0, sticky=tk.W, pady=5)
        self.csv_path_var = tk.StringVar()
        ttk.Entry(input_frame, textvariable=self.csv_path_var, width=60).grid(row=0, column=1, pady=5)
        ttk.Button(input_frame, text="Browse", command=self.browse_csv).grid(row=0, column=2, pady=5)
        
        # Single Number
        ttk.Label(input_frame, text="Single Number:").grid(row=1, column=0, sticky=tk.W, pady=5)
        self.single_number_var = tk.StringVar()
        ttk.Entry(input_frame, textvariable=self.single_number_var, width=30).grid(row=1, column=1, sticky=tk.W, pady=5)
        ttk.Button(input_frame, text="Check", command=self.check_single).grid(row=1, column=2, pady=5)
        
        # Buttons
        button_frame = ttk.Frame(main_frame)
        button_frame.grid(row=row, column=0, columnspan=3, pady=20)
        row += 1
        
        ttk.Button(button_frame, text="🔍 Check CSV File", 
                  command=self.check_csv, width=25).grid(row=0, column=0, padx=5)
        ttk.Button(button_frame, text="💾 Export Results", 
                  command=self.export_results, width=25).grid(row=0, column=1, padx=5)
        
        # Results Display
        ttk.Label(main_frame, text="Results:").grid(row=row, column=0, sticky=tk.W, pady=5)
        row += 1
        
        self.results_text = scrolledtext.ScrolledText(main_frame, width=100, height=20, 
                                                      font=('Courier', 9))
        self.results_text.grid(row=row, column=0, columnspan=3, pady=5)
        row += 1
        
        # Status
        self.status_var = tk.StringVar(value="Ready")
        status_label = ttk.Label(main_frame, textvariable=self.status_var, foreground='blue')
        status_label.grid(row=row, column=0, columnspan=3, pady=10)
        
        # Store results
        self.results = []
    
    def browse_csv(self):
        path = filedialog.askopenfilename(title="Select CSV File", 
                                         filetypes=[("CSV files", "*.csv"), ("All files", "*.*")])
        if path:
            self.csv_path_var.set(path)
    
    def check_single(self):
        """Check a single phone number"""
        number = self.single_number_var.get().strip()
        if not number:
            messagebox.showerror("Error", "Please enter a phone number")
            return
        
        self.results_text.delete("1.0", tk.END)
        self.status_var.set("Checking...")
        self.root.update()
        
        result = self.check_number(number)
        
        # Display result
        self.results_text.insert("1.0", f"Number: {number}\n")
        self.results_text.insert(tk.END, f"Type: {result['type']}\n")
        self.results_text.insert(tk.END, f"Carrier: {result['carrier']}\n")
        self.results_text.insert(tk.END, f"Valid: {result['valid']}\n")
        self.results_text.insert(tk.END, f"Status: {result['status']}\n")
        
        self.status_var.set("✅ Check complete")
    
    def check_csv(self):
        """Check all numbers in CSV file"""
        csv_path = self.csv_path_var.get()
        if not csv_path or not Path(csv_path).exists():
            messagebox.showerror("Error", "Please select a valid CSV file")
            return
        
        api_key = self.api_key_var.get().strip()
        if not api_key and self.api_service.get() != "manual":
            messagebox.showerror("Error", "Please enter your API key")
            return
        
        try:
            # Read CSV
            df = pd.read_csv(csv_path)
            
            if 'Phone' not in df.columns:
                messagebox.showerror("Error", "CSV must have 'Phone' column")
                return
            
            self.results = []
            self.results_text.delete("1.0", tk.END)
            
            total = len(df)
            self.results_text.insert(tk.END, f"Checking {total} numbers...\n\n")
            self.root.update()
            
            for idx, row in df.iterrows():
                phone = str(row['Phone']).strip()
                name = str(row.get('Name', '')).strip()
                
                self.status_var.set(f"Checking {idx+1}/{total}: {phone}")
                self.root.update()
                
                result = self.check_number(phone)
                result['name'] = name
                self.results.append(result)
                
                # Display in results
                emoji = "☎️" if result['type'] == 'landline' else "📱" if result['type'] == 'mobile' else "❓"
                self.results_text.insert(tk.END, 
                    f"{emoji} {phone:15s} {name:30s} → {result['type']:10s} ({result['carrier']})\n")
                self.root.update()
            
            # Summary
            landlines = sum(1 for r in self.results if r['type'] == 'landline')
            mobiles = sum(1 for r in self.results if r['type'] == 'mobile')
            unknown = sum(1 for r in self.results if r['type'] == 'unknown')
            
            self.results_text.insert(tk.END, f"\n{'='*80}\n")
            self.results_text.insert(tk.END, f"SUMMARY:\n")
            self.results_text.insert(tk.END, f"  📱 Mobile: {mobiles}\n")
            self.results_text.insert(tk.END, f"  ☎️  Landline: {landlines}\n")
            self.results_text.insert(tk.END, f"  ❓ Unknown: {unknown}\n")
            
            self.status_var.set(f"✅ Complete: {landlines} landlines found")
            
        except Exception as e:
            messagebox.showerror("Error", f"Failed to process CSV: {e}")
            self.status_var.set("❌ Error")
    
    def check_number(self, phone):
        """Check if number is landline using selected API"""
        api_service = self.api_service.get()
        
        if api_service == "numverify":
            return self.check_numverify(phone)
        elif api_service == "twilio":
            return self.check_twilio(phone)
        else:
            return self.check_manual(phone)
    
    def check_numverify(self, phone):
        """Check using numverify API"""
        api_key = self.api_key_var.get().strip()
        
        # Normalize phone
        clean = ''.join(filter(str.isdigit, phone))
        
        try:
            url = f"http://apilayer.net/api/validate"
            params = {
                'access_key': api_key,
                'number': clean,
                'country_code': 'US',
                'format': 1
            }
            
            response = requests.get(url, params=params, timeout=10)
            data = response.json()
            
            if data.get('valid'):
                line_type = data.get('line_type', 'unknown')
                carrier = data.get('carrier', 'Unknown')
                
                # Map line types
                if line_type in ['landline', 'fixed_line']:
                    phone_type = 'landline'
                elif line_type in ['mobile', 'cell']:
                    phone_type = 'mobile'
                else:
                    phone_type = 'unknown'
                
                return {
                    'phone': phone,
                    'type': phone_type,
                    'carrier': carrier,
                    'valid': True,
                    'status': 'success'
                }
            else:
                return {
                    'phone': phone,
                    'type': 'unknown',
                    'carrier': 'N/A',
                    'valid': False,
                    'status': data.get('error', {}).get('info', 'Invalid')
                }
        
        except Exception as e:
            return {
                'phone': phone,
                'type': 'unknown',
                'carrier': 'N/A',
                'valid': False,
                'status': f'API Error: {str(e)}'
            }
    
    def check_twilio(self, phone):
        """Check using Twilio Lookup API (requires Twilio account)"""
        # Placeholder - user needs to implement with their Twilio credentials
        return {
            'phone': phone,
            'type': 'unknown',
            'carrier': 'N/A',
            'valid': False,
            'status': 'Twilio integration not configured'
        }
    
    def check_manual(self, phone):
        """Manual check using phonenumbers library (basic validation only)"""
        try:
            clean = ''.join(filter(str.isdigit, phone))
            parsed = phonenumbers.parse('+1' + clean if not clean.startswith('1') else '+' + clean, 'US')
            
            if phonenumbers.is_valid_number(parsed):
                # phonenumbers library cannot determine landline vs mobile
                # This requires carrier lookup APIs
                return {
                    'phone': phone,
                    'type': 'unknown',
                    'carrier': 'Unknown (API required)',
                    'valid': True,
                    'status': 'Valid format but type unknown without API'
                }
            else:
                return {
                    'phone': phone,
                    'type': 'unknown',
                    'carrier': 'N/A',
                    'valid': False,
                    'status': 'Invalid number'
                }
        except:
            return {
                'phone': phone,
                'type': 'unknown',
                'carrier': 'N/A',
                'valid': False,
                'status': 'Parse error'
            }
    
    def export_results(self):
        """Export results to CSV"""
        if not self.results:
            messagebox.showinfo("Info", "No results to export. Check a CSV file first.")
            return
        
        try:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_file = Path("landline_check_results") / f"results_{timestamp}.csv"
            output_file.parent.mkdir(exist_ok=True)
            
            # Create DataFrame
            df = pd.DataFrame(self.results)
            df.to_csv(output_file, index=False)
            
            messagebox.showinfo("Success", f"Results exported to:\n{output_file}")
            self.status_var.set(f"✅ Exported to {output_file.name}")
            
        except Exception as e:
            messagebox.showerror("Error", f"Export failed: {e}")

if __name__ == "__main__":
    root = tk.Tk()
    app = LandlineChecker(root)
    root.mainloop()
