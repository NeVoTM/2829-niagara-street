#!/usr/bin/env python3
"""
P-Texting - Simple Google Voice Automation with Date Filtering
Modern Mobile-First GUI Interface

Design Standards: See warpspeed/GUI-DESIGN-STANDARDS.md
- Mobile-first design (390px minimum width)
- 44px minimum touch targets
- Scrollable content areas
- High contrast colors
- Responsive layout
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox
from pathlib import Path
import json
import os
from datetime import datetime
import threading

class PTextingGUI:
    def __init__(self, root):
        self.root = root
        
        # Detect preset browser from environment variable
        self.preset_browser = os.environ.get('PTEXTING_BROWSER', None)
        
        # Browser display names
        self.browser_names = {
            'chrome': 'Chrome',
            'edge': 'Edge',
            'firefox': 'Firefox'
        }
        
        # Set window title based on browser
        if self.preset_browser:
            browser_name = self.preset_browser.capitalize()
            self.root.title(f"P-Texting ({browser_name}) - Google Voice Automation")
        else:
            self.root.title("P-Texting - Google Voice Automation")
        
        # Compact window size to fit content
        window_width = 750
        window_height = 550  # Reduced from 700
        
        # Get screen dimensions and center window
        screen_width = self.root.winfo_screenwidth()
        screen_height = self.root.winfo_screenheight()
        x = (screen_width - window_width) // 2
        y = (screen_height - window_height) // 2 - 50  # Slight offset up
        
        self.root.geometry(f"{window_width}x{window_height}+{x}+{y}")
        self.root.minsize(700, 500)  # Reduced from 650
        self.root.resizable(True, True)
        
        # Color scheme from dashboard-design.html (GUI-DESIGN-STANDARDS.md Rule 2.1)
        self.BG_PRIMARY = "#0d1117"
        self.BG_SECONDARY = "#161b22"
        self.ACCENT_BLUE = "#58a6ff"
        self.ACCENT_GREEN = "#3fb950"
        self.TEXT_PRIMARY = "#f0f6fc"
        self.TEXT_SECONDARY = "#8b949e"
        self.CARD_BG = "#ffffff"
        self.CARD_TEXT = "#2c3e50"
        self.SUCCESS = "#238636"
        self.DANGER = "#da3633"
        self.WARNING = "#bf8700"
        
        self.setup_ui()
        self.load_config()
    
    def show_copyable_dialog(self, title, message, dialog_type="info"):
        """Show a copyable dialog with scrollbar and right-click menu"""
        dialog = tk.Toplevel(self.root)
        dialog.title(title)
        dialog.geometry("500x300")
        
        # Create text widget with scrollbar
        text_frame = tk.Frame(dialog)
        text_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        scrollbar = tk.Scrollbar(text_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        text_widget = tk.Text(text_frame, wrap=tk.WORD, padx=10, pady=10, yscrollcommand=scrollbar.set)
        text_widget.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.config(command=text_widget.yview)
        
        # Add right-click context menu
        context_menu = tk.Menu(text_widget, tearoff=0)
        context_menu.add_command(label="Copy", command=lambda: text_widget.event_generate("<<Copy>>"))
        context_menu.add_command(label="Select All", command=lambda: text_widget.tag_add(tk.SEL, "1.0", tk.END))
        
        def show_context_menu(event):
            context_menu.tk_popup(event.x_root, event.y_root)
        
        text_widget.bind("<Button-3>", show_context_menu)
        text_widget.bind("<Control-a>", lambda e: text_widget.tag_add(tk.SEL, "1.0", tk.END))
        text_widget.bind("<Control-A>", lambda e: text_widget.tag_add(tk.SEL, "1.0", tk.END))
        
        # Insert message
        text_widget.insert("1.0", message)
        text_widget.config(state=tk.NORMAL)
        
        # Add close button
        button_frame = tk.Frame(dialog)
        button_frame.pack(pady=5)
        
        close_btn = tk.Button(button_frame, text="Close", command=dialog.destroy, padx=20, pady=5)
        close_btn.pack()
        
        # Make modal
        dialog.transient(self.root)
        dialog.grab_set()
        self.root.wait_window(dialog)
    
    def setup_ui(self):
        """Create mobile-first UI following GUI-DESIGN-STANDARDS.md"""
        
        # Main container with dark professional background
        main_frame = tk.Frame(self.root, bg=self.BG_PRIMARY)
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Header with accent color (Rule 2.1)
        header = tk.Frame(main_frame, bg=self.BG_SECONDARY)
        header.pack(fill=tk.X, padx=0, pady=0)
        
        # Single line header with title and subtitle together
        # Show browser name if preset
        if self.preset_browser:
            browser_name = self.preset_browser.capitalize()
            header_text = f"📱 P-Texting ({browser_name})  •  Google Voice Date-Filtered Texting"
        else:
            header_text = "📱 P-Texting  •  Google Voice Date-Filtered Texting"
        
        title_label = tk.Label(
            header,
            text=header_text,
            font=("Segoe UI", 10, "bold"),
            bg=self.BG_SECONDARY,
            fg=self.TEXT_PRIMARY
        )
        title_label.pack(pady=8)
        
        # Scrollable content container (Rule 3.3)
        canvas = tk.Canvas(main_frame, bg=self.BG_PRIMARY, highlightthickness=0)
        scrollbar = tk.Scrollbar(main_frame, orient="vertical", command=canvas.yview)
        scrollable_frame = tk.Frame(canvas, bg=self.BG_PRIMARY)
        
        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )
        
        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        
        # Card container (Rule 3.4: Card-based design)
        card = tk.Frame(
            scrollable_frame,
            bg=self.CARD_BG,
            relief="solid",
            borderwidth=1
        )
        card.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)  # Reduced from 15
        
        # Content area with proper padding
        content = tk.Frame(card, bg=self.CARD_BG)
        content.pack(fill=tk.BOTH, expand=True, padx=15, pady=15)  # Reduced from 20
        
        # Chrome Profile Path input (rows 1-3) - Only for Chrome
        current_row = 1
        if not self.preset_browser or self.preset_browser == "chrome":
            self.create_profile_path_input(content, row=current_row)
            current_row = 4  # Next available row after profile path (uses rows 1-3)
        
        # Image file input
        self.create_file_input(
            content,
            "📸 Image File (Optional):",
            "image",
            row=current_row,
            button_text="Browse..."
        )
        current_row += 2
        
        # Data file input
        self.create_file_input(
            content,
            "📊 Phone Data File (Required):",
            "data",
            row=current_row,
            button_text="Browse..."
        )
        current_row += 2
        
        # Message text input
        msg_label = tk.Label(
            content,
            text="💬 Message Text:",
            font=("Segoe UI", 11, "bold"),  # Rule 4.2: Heading size
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            anchor="w"
        )
        msg_label.grid(row=current_row, column=0, sticky="w", pady=(5, 1))
        current_row += 1
        
        # Text area with scrollbar
        text_frame = tk.Frame(content, bg=self.CARD_BG)
        text_frame.grid(row=current_row, column=0, columnspan=2, sticky="ew", pady=(0, 8))
        current_row += 1
        
        self.message_text = tk.Text(
            text_frame,
            height=2,  # Reduced from 6 to 2 lines
            font=("Segoe UI", 10),
            wrap=tk.WORD,
            relief=tk.SOLID,
            borderwidth=1,
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            insertbackground=self.CARD_TEXT,
            padx=8,
            pady=6
        )
        self.message_text.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        
        text_scrollbar = tk.Scrollbar(text_frame, command=self.message_text.yview)
        text_scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        self.message_text.config(yscrollcommand=text_scrollbar.set)
        
        # Salutation field
        salutation_label = tk.Label(
            content,
            text="👤 Salutation (Optional):",
            font=("Segoe UI", 11, "bold"),
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            anchor="w"
        )
        salutation_label.grid(row=current_row, column=0, sticky="w", pady=(8, 1))
        current_row += 1
        
        self.salutation_entry = tk.Entry(
            content,
            font=("Segoe UI", 10),
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            relief=tk.SOLID,
            borderwidth=1,
            insertbackground=self.CARD_TEXT
        )
        self.salutation_entry.grid(row=current_row, column=0, columnspan=2, sticky="ew", pady=(0, 15))
        self.salutation_entry.insert(0, "Dear {name},")  # Default value
        current_row += 1
        
        # Set browser based on preset or default to chrome (no UI selection)
        default_browser = self.preset_browser if self.preset_browser else "chrome"
        self.browser_var = tk.StringVar(value=default_browser)
        
        # Status label
        self.status_label = tk.Label(
            content,
            text="✓ Ready to send messages",
            font=("Segoe UI", 9),  # Rule 4.2: Small text
            bg=self.CARD_BG,
            fg=self.TEXT_SECONDARY,
            anchor="w"
        )
        self.status_label.grid(row=current_row, column=0, columnspan=2, sticky="w", pady=(3, 3))
        current_row += 1
        
        # Progress status frame
        progress_frame = tk.Frame(content, bg=self.CARD_BG)
        progress_frame.grid(row=current_row, column=0, columnspan=2, sticky="ew", pady=(0, 8))
        current_row += 1
        
        # Progress labels
        self.progress_label = tk.Label(
            progress_frame,
            text="⌛ Pending: 0  |  ✅ Sent: 0  |  ❌ Failed: 0",
            font=("Segoe UI", 9, "bold"),
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            anchor="w"
        )
        self.progress_label.pack(side=tk.LEFT)
        
        # Action buttons
        button_frame = tk.Frame(content, bg=self.CARD_BG)
        button_frame.grid(row=current_row, column=0, columnspan=2, pady=(10, 0))
        
        # Start Chrome Debug button (Chrome only)
        if self.preset_browser == "chrome" or not self.preset_browser:
            start_chrome_button = tk.Button(
                button_frame,
                text="🔧 Start Chrome Debug",
                font=("Segoe UI", 10),
                bg="#4CAF50",  # Green
                fg="#ffffff",
                activebackground="#45a049",
                activeforeground="#ffffff",
                relief="flat",
                padx=20,
                pady=12,
                cursor="hand2",
                command=self.start_chrome_debug
            )
            start_chrome_button.pack(side=tk.LEFT, padx=(0, 10))
        
        # Send button - Primary action (Rule 5.1)
        self.send_button = tk.Button(
            button_frame,
            text="🚀 Send Messages",
            font=("Segoe UI", 11, "bold"),  # Rule 4.2
            bg=self.ACCENT_BLUE,  # Professional blue accent
            fg="#ffffff",
            activebackground="#4a8fd9",  # Darker on click
            activeforeground="#ffffff",
            relief="flat",
            padx=25,  # Rule 1.2: 44px+ touch target
            pady=12,  # Rule 1.2: 44px+ touch target
            cursor="hand2",
            command=self.send_messages
        )
        self.send_button.pack(side=tk.LEFT, padx=(0, 10))
        
        # Save config button - Secondary action (Rule 5.1)
        save_button = tk.Button(
            button_frame,
            text="💾 Save Config",
            font=("Segoe UI", 10),  # Rule 4.2
            bg="#f0f0f0",  # Light gray secondary
            fg=self.CARD_TEXT,
            activebackground="#e0e0e0",
            activeforeground=self.CARD_TEXT,
            relief="flat",
            padx=20,  # Rule 1.2: 44px+ touch target
            pady=12,  # Rule 1.2: 44px+ touch target
            cursor="hand2",
            command=self.save_config
        )
        save_button.pack(side=tk.LEFT, padx=(0, 10))
        
        # Open Report button
        report_button = tk.Button(
            button_frame,
            text="📊 Open Report",
            font=("Segoe UI", 10),  # Rule 4.2
            bg="#f0f0f0",  # Light gray
            fg=self.CARD_TEXT,
            activebackground="#e0e0e0",
            activeforeground=self.CARD_TEXT,
            relief="flat",
            padx=20,  # Rule 1.2: 44px+ touch target
            pady=12,  # Rule 1.2: 44px+ touch target
            cursor="hand2",
            command=self.open_report
        )
        report_button.pack(side=tk.LEFT, padx=(0, 10))
        
        # Check Database Status button
        check_db_button = tk.Button(
            button_frame,
            text="📊 Check DB Status",
            font=("Segoe UI", 10),
            bg="#f0f0f0",
            fg=self.CARD_TEXT,
            activebackground="#e0e0e0",
            activeforeground=self.CARD_TEXT,
            relief="flat",
            padx=20,
            pady=12,
            cursor="hand2",
            command=self.check_database_status
        )
        check_db_button.pack(side=tk.LEFT)
        
        # Make grid columns expandable (Rule 3.2)
        content.grid_columnconfigure(0, weight=1)
    
    def create_profile_path_input(self, parent, row):
        """Create Chrome Profile Path input with helper text"""
        
        # Label
        label = tk.Label(
            parent,
            text="🌐 Chrome Profile Path (Required):",
            font=("Segoe UI", 11, "bold"),
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            anchor="w"
        )
        label.grid(row=row, column=0, sticky="w", pady=(0, 1))
        
        # Input frame with entry and button
        input_frame = tk.Frame(parent, bg=self.CARD_BG)
        input_frame.grid(row=row+1, column=0, columnspan=2, sticky="ew", pady=(0, 1))
        
        # Entry field
        self.profile_path_entry = tk.Entry(
            input_frame,
            font=("Segoe UI", 10),
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            relief=tk.SOLID,
            borderwidth=1,
            insertbackground=self.CARD_TEXT
        )
        self.profile_path_entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))
        
        # Browse button
        button = tk.Button(
            input_frame,
            text="Browse...",
            font=("Segoe UI", 9),
            bg="#f0f0f0",
            fg=self.CARD_TEXT,
            activebackground="#e0e0e0",
            activeforeground=self.CARD_TEXT,
            relief="flat",
            padx=15,
            pady=10,
            cursor="hand2",
            command=self.browse_profile_path
        )
        button.pack(side=tk.RIGHT)
        
        # Remove the Tip line entirely
    
    def browse_profile_path(self):
        """Open folder browser for Chrome profile path"""
        from tkinter import filedialog
        folder = filedialog.askdirectory(
            title="Select Chrome Profile Folder",
            initialdir=os.path.expandvars(r"%LOCALAPPDATA%\Google\Chrome\User Data")
        )
        
        if folder:
            self.profile_path_entry.delete(0, tk.END)
            self.profile_path_entry.insert(0, folder)
            self.update_status(f"✓ Selected profile: {os.path.basename(folder)}", "info")
    
    def copy_to_clipboard(self, text):
        """Copy text to clipboard"""
        self.root.clipboard_clear()
        self.root.clipboard_append(text)
        self.update_status(f"✓ Copied '{text}' to clipboard", "info")
    
    def create_file_input(self, parent, label_text, var_name, row, button_text):
        """Create a file input row following Rule 10.1 (mobile-first vertical layout)"""
        
        # Label (Rule 4.2: Heading size)
        label = tk.Label(
            parent,
            text=label_text,
            font=("Segoe UI", 11, "bold"),
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            anchor="w"
        )
        label.grid(row=row, column=0, sticky="w", pady=(5, 1))
        
        # Input frame with entry and button
        input_frame = tk.Frame(parent, bg=self.CARD_BG)
        input_frame.grid(row=row+1, column=0, columnspan=2, sticky="ew", pady=(0, 0))
        
        # Entry field (Rule 5.2)
        entry = tk.Entry(
            input_frame,
            font=("Segoe UI", 10),  # Rule 4.2: Body text
            bg=self.CARD_BG,
            fg=self.CARD_TEXT,
            relief=tk.SOLID,
            borderwidth=1,
            insertbackground=self.CARD_TEXT  # Cursor color
        )
        entry.pack(side=tk.LEFT, fill=tk.X, expand=True, padx=(0, 10))
        
        # Store entry widget
        setattr(self, f"{var_name}_entry", entry)
        
        # Browse button (Rule 5.3: File browser pattern)
        button = tk.Button(
            input_frame,
            text=button_text,
            font=("Segoe UI", 9),  # Rule 4.2: Small text
            bg="#f0f0f0",  # Secondary button color
            fg=self.CARD_TEXT,
            activebackground="#e0e0e0",
            activeforeground=self.CARD_TEXT,
            relief="flat",
            padx=15,  # Rule 1.2: Touch target padding
            pady=10,  # Rule 1.2: 44px+ touch target
            cursor="hand2",
            command=lambda: self.browse_file(var_name)
        )
        button.pack(side=tk.RIGHT)
    
    def browse_file(self, var_name):
        """Open file browser dialog"""
        if var_name == "image":
            filetypes = [
                ("Image files", "*.png *.jpg *.jpeg *.gif *.bmp"),
                ("All files", "*.*")
            ]
            title = "Select Image File"
        else:
            filetypes = [
                ("CSV files", "*.csv"),
                ("Excel files", "*.xlsx *.xls"),
                ("All files", "*.*")
            ]
            title = "Select Phone Data File"
        
        filename = filedialog.askopenfilename(
            title=title,
            filetypes=filetypes
        )
        
        if filename:
            entry = getattr(self, f"{var_name}_entry")
            entry.delete(0, tk.END)
            entry.insert(0, filename)
            self.update_status(f"✓ Selected: {Path(filename).name}", "info")
    
    def update_status(self, message, status_type="info"):
        """Update status label with color coding (Rule 6.1)"""
        colors = {
            "success": self.SUCCESS,    # Green
            "error": self.DANGER,       # Red
            "warning": self.WARNING,    # Orange
            "info": self.TEXT_SECONDARY # Gray
        }
        self.status_label.config(
            text=message,
            fg=colors.get(status_type, colors["info"])
        )
        self.root.update()
    
    def save_config(self):
        """Save current settings to browser-specific config file"""
        try:
            # Load existing config to preserve browser-specific settings
            if Path("config.json").exists():
                with open("config.json", "r") as f:
                    config = json.load(f)
            else:
                # Default config
                config = {
                    "browser": self.preset_browser or "chrome",
                    "browser_profile_path": "",
                    "browser_binary_path": "",
                    "phone_column": "Phone",
                    "name_column": "Name",
                    "date_column": "Date",
                    "batch_size": 7,
                    "delay_between_batches_seconds": 45,
                    "batch_delay_jitter_seconds": 10,
                    "daily_limit": 250,
                    "max_retries": 3,
                    "per_message_delay_seconds": 2,
                    "region_default_country_code": "US",
                    "account_label": "account1",
                    "database_path": "progress_shared.db",
                    "log_path": ".\\\\logs\\\\run.log",
                    "remote_debugging_port": 9222
                }
            
            # Update only the user-editable fields
            if hasattr(self, 'profile_path_entry'):
                config["browser_profile_path"] = self.profile_path_entry.get()
            
            config["input_path"] = self.data_entry.get()
            config["message_text"] = self.message_text.get("1.0", tk.END).strip()
            config["salutation"] = self.salutation_entry.get().strip()
            config["image_path"] = self.image_entry.get() if self.image_entry.get() else None
            
            # Save to config.json
            with open("config.json", "w") as f:
                json.dump(config, f, indent=2)
            
            # Also save to browser-specific config if browser is preset
            if self.preset_browser:
                browser_config_path = Path(f"configs/config_{self.preset_browser}.json")
                with open(browser_config_path, "w") as f:
                    json.dump(config, f, indent=2)
                    
            self.update_status("✅ Configuration saved successfully", "success")
            messagebox.showinfo("Success", "Configuration saved")
            
        except Exception as e:
            self.update_status(f"❌ Error: {str(e)}", "error")
            self.show_copyable_dialog("Error", f"Failed to save config:\n\n{str(e)}")
    
    def load_config(self):
        """Load existing config.json if it exists"""
        try:
            if Path("config.json").exists():
                with open("config.json", "r") as f:
                    config = json.load(f)
                
                # Only load profile path if the widget exists (Chrome only)
                if hasattr(self, 'profile_path_entry'):
                    self.profile_path_entry.insert(0, config.get("browser_profile_path", ""))
                
                self.image_entry.insert(0, config.get("image_path", "") or "")
                self.data_entry.insert(0, config.get("input_path", ""))
                self.message_text.insert("1.0", config.get("message_text", ""))
                
                # Load salutation (with default)
                salutation = config.get("salutation", "Dear {name},")
                self.salutation_entry.delete(0, tk.END)
                self.salutation_entry.insert(0, salutation)
                
                # Load browser selection
                browser = config.get("browser", "chrome")
                self.browser_var.set(browser)
                
                # Don't show config loaded message
        except Exception as e:
            self.update_status(f"⚠ Could not load config: {str(e)}", "warning")
    
    def validate_inputs(self):
        """Validate all inputs before sending"""
        errors = []
        
        # Check profile path (Chrome only)
        if hasattr(self, 'profile_path_entry'):
            profile_path = self.profile_path_entry.get()
            if not profile_path:
                errors.append("Chrome Profile Path is required")
            elif not Path(profile_path).exists():
                errors.append(f"Profile path not found: {profile_path}")
            elif not any(profile_path.endswith(p) for p in ["Default", "Profile 1", "Profile 2", "Profile 3", "Profile 4", "Profile 5"]):
                errors.append("Profile path should end with 'Default', 'Profile 1', etc.")
        
        # Check data file
        data_file = self.data_entry.get()
        if not data_file:
            errors.append("Phone data file is required")
        elif not Path(data_file).exists():
            errors.append(f"Data file not found: {data_file}")
        
        # Check message
        message = self.message_text.get("1.0", tk.END).strip()
        if not message:
            errors.append("Message text is required")
        
        # Check image if provided
        image_file = self.image_entry.get()
        if image_file:
            if not Path(image_file).exists():
                errors.append(f"Image file not found: {image_file}")
            else:
                # Check size (1.5MB limit)
                size_mb = Path(image_file).stat().st_size / (1024 * 1024)
                if size_mb > 1.5:
                    errors.append(f"Image too large ({size_mb:.2f}MB). Must be ≤ 1.5MB")
        
        return errors
    
    def test_validation(self):
        """Test and validate inputs without sending"""
        
        # Validate inputs
        errors = self.validate_inputs()
        if errors:
            self.show_copyable_dialog("Validation Failed", "\n".join(errors))
            self.update_status("❌ Validation failed", "error")
            return
        
        # Read and analyze the data file
        try:
            import pandas as pd
            from datetime import date
            
            data_file = self.data_entry.get()
            df = pd.read_csv(data_file)
            
            # Check for today's date
            today = date.today().isoformat()
            today_contacts = df[df['Date'] == today] if 'Date' in df.columns else pd.DataFrame()
            
            # Build report
            report = f"✅ Validation Successful!\n\n"
            report += f"Total contacts in file: {len(df)}\n"
            report += f"Contacts for today ({today}): {len(today_contacts)}\n\n"
            
            if len(today_contacts) > 0:
                report += f"Today's contacts:\n"
                for idx, row in today_contacts.iterrows():
                    report += f"  • {row.get('Name', 'Unknown')} - {row.get('Phone', 'N/A')}\n"
            else:
                report += f"⚠️ No contacts scheduled for today\n"
            
            # Image check
            image_file = self.image_entry.get()
            if image_file:
                size_mb = Path(image_file).stat().st_size / (1024 * 1024)
                report += f"\nImage: {Path(image_file).name} ({size_mb:.2f} MB)"
            else:
                report += f"\nImage: None (text only)"
            
            # Message preview
            message = self.message_text.get("1.0", tk.END).strip()
            report += f"\nMessage length: {len(message)} characters"
            
            messagebox.showinfo("Validation Report", report)
            self.update_status(f"✅ Validated: {len(today_contacts)} contacts for today", "success")
            
        except Exception as e:
            self.show_copyable_dialog("Validation Error", f"Error reading data file:\n\n{str(e)}")
            self.update_status(f"❌ Validation error: {str(e)}", "error")
    
    def send_messages(self):
        """Start sending messages"""
        
        # Validate inputs
        errors = self.validate_inputs()
        if errors:
            self.show_copyable_dialog("Validation Error", "\n".join(errors))
            return
        
        # Check if Chrome remote debugging is available (retry a few times)
        import urllib.request
        import urllib.error
        import time as _time
        devtools_ok = False
        last_err = None
        port = 9222
        try:
            # If config has a custom port, use it
            import json as _json
            if Path("config.json").exists():
                with open("config.json", "r") as _f:
                    _cfg = _json.load(_f)
                    port = _cfg.get("remote_debugging_port", 9222)
        except Exception:
            pass
        for _ in range(5):
            try:
                with urllib.request.urlopen(f"http://127.0.0.1:{port}/json/version", timeout=5) as response:
                    response.read()
                    devtools_ok = True
                    break
            except (urllib.error.URLError, urllib.error.HTTPError, TimeoutError) as e:
                last_err = e
                _time.sleep(1.5)
        if not devtools_ok:
            # Get browser name
            browser = self.preset_browser or 'chrome'
            browser_display = self.browser_names.get(browser, browser.capitalize())
            
            error_msg = f"Cannot connect to {browser_display} DevTools!\n\n"
            error_msg += f"Please start {browser_display} with remote debugging:\n"
            if browser == 'chrome':
                error_msg += f"chrome.exe --remote-debugging-port={port}\n\n"
            elif browser == 'edge':
                error_msg += f"msedge.exe --remote-debugging-port={port}\n\n"
            elif browser == 'firefox':
                error_msg += f"Firefox: Enable Marionette in about:config\n\n"
            else:
                error_msg += f"{browser}.exe --remote-debugging-port={port}\n\n"
            error_msg += "Then navigate to https://voice.google.com/messages\n\n"
            error_msg += f"Error: {str(last_err) if last_err else 'Unknown'}"
            self.show_copyable_dialog(f"{browser_display} Not Ready", error_msg)
            return
        
        # Save config first
        self.save_config()
        
        # Confirm with user
        response = messagebox.askyesno(
            "Confirm Send",
            "Start sending messages to today's contacts?\n\n"
            "The script will:\n"
            "• Filter contacts by today's date\n"
            "• Send messages in batches of 7\n"
            "• Respect daily limits\n"
            "• Save progress automatically\n\n"
            "Continue?"
        )
        
        if not response:
            return
        
        # Disable send button
        self.send_button.config(state=tk.DISABLED, bg=self.TEXT_SECONDARY)
        self.update_status("🚀 Starting send process...", "info")
        
        # Run in thread to avoid freezing UI
        thread = threading.Thread(target=self.run_send_script)
        thread.daemon = True
        thread.start()
    
    def update_progress_from_db(self):
        """Update progress display from database"""
        try:
            import sqlite3
            conn = sqlite3.connect('progress_shared.db')
            cursor = conn.cursor()
            
            # Count by status
            cursor.execute("SELECT status, COUNT(*) FROM messages GROUP BY status")
            counts = dict(cursor.fetchall())
            conn.close()
            
            pending = counts.get('pending', 0)
            sent = counts.get('sent', 0)
            failed = counts.get('failed', 0)
            
            # Update progress label
            progress_text = f"⌛ Pending: {pending}  |  ✅ Sent: {sent}  |  ❌ Failed: {failed}"
            self.progress_label.config(text=progress_text)
            
        except Exception as e:
            pass
    
    def run_send_script(self):
        """Run the send_texts.py script with live progress updates"""
        try:
            import subprocess
            import threading
            
            # Start progress monitoring in background
            def monitor_progress():
                import time
                while self.send_button['state'] == 'disabled':
                    self.root.after(0, self.update_progress_from_db)
                    time.sleep(2)  # Update every 2 seconds
            
            monitor_thread = threading.Thread(target=monitor_progress, daemon=True)
            monitor_thread.start()
            
            # Run the script
            result = subprocess.run(
                ["python", "send_texts_date_filter.py"],
                capture_output=True,
                text=True
            )
            
            # Final update
            self.root.after(0, self.update_progress_from_db)
            
            # Update UI on main thread
            self.root.after(0, self.send_complete, result.returncode == 0, result.stdout)
            
        except Exception as e:
            self.root.after(0, self.send_complete, False, str(e))
    
    def open_report(self):
        """Generate and open the message report"""
        try:
            import subprocess
            from generate_report import generate_report
            
            # Generate report
            output_file, sent, failed, pending, total = generate_report()
            
            # Show summary
            summary = f"Report Generated!\n\n"
            summary += f"✅ Sent:    {sent}\n"
            summary += f"❌ Failed:  {failed}\n"
            summary += f"⏳ Pending: {pending}\n"
            summary += f"📊 Total:   {total}\n\n"
            summary += f"Opening {output_file}..."
            
            self.show_copyable_dialog("Report", summary)
            
            # Open report file
            subprocess.run(["notepad.exe", output_file])
            
        except Exception as e:
            self.show_copyable_dialog("Error", f"Failed to generate report:\n\n{str(e)}")
    
    def send_complete(self, success, output):
        """Handle send completion (Rule 6.1: Status messages)"""
        self.send_button.config(state=tk.NORMAL, bg=self.ACCENT_BLUE)
        
        if success:
            # Generate report after successful send
            try:
                from generate_report import generate_report
                output_file, sent, failed, pending, total = generate_report()
                
                msg = f"Messages sent!\n\n"
                msg += f"✅ Sent:    {sent}\n"
                msg += f"❌ Failed:  {failed}\n"
                msg += f"⏳ Pending: {pending}\n\n"
                msg += f"Report saved: {output_file}\n"
                msg += f"Check logs/run.log for details."
                
                self.update_status("✅ Messages sent successfully!", "success")
                self.show_copyable_dialog("Success", msg)
            except:
                self.update_status("✅ Messages sent successfully!", "success")
                self.show_copyable_dialog("Success", "Messages sent!\n\nCheck logs/run.log for details.")
        else:
            self.update_status("❌ Send failed", "error")
            self.show_copyable_dialog("Error", f"Failed to send messages:\n\n{output[:500]}")
    
    def export_results(self):
        """Export message results to CSV file (same as report but in exports folder)"""
        try:
            from datetime import datetime
            from generate_report import generate_report
            
            # Create exports directory
            Path('exports').mkdir(exist_ok=True)
            
            # Generate timestamped filename
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            filename = f'results_{timestamp}.csv'
            filepath = Path('exports') / filename
            
            # Use the report generation function (CSV-file-based)
            output_file, sent, failed, pending, total = generate_report(output_file=filepath)
            
            if total == 0:
                self.show_copyable_dialog("No Data", "No contacts found in current CSV file.")
                return
            
            # Show summary
            msg = f"Results exported successfully!\n\n"
            msg += f"✅ Sent: {sent}\n"
            msg += f"❌ Failed: {failed}\n"
            msg += f"⌛ Pending: {pending}\n"
            msg += f"📊 Total: {total}\n\n"
            msg += f"File: {filepath}"
            
            self.update_status(f"✓ Exported {total} records", "success")
            self.show_copyable_dialog("Export Complete", msg)
            
            # Open folder
            import subprocess
            subprocess.run(['explorer', str(Path('exports').absolute())])
            
        except Exception as e:
            self.update_status(f"❌ Export failed: {str(e)}", "error")
            self.show_copyable_dialog("Export Error", f"Failed to export results:\n\n{str(e)}")
    
    def check_database_status(self):
        """Check and display database status for selected CSV file"""
        try:
            import pandas as pd
            import sqlite3
            import re
            from datetime import date
            
            # Get selected data file
            data_file = self.data_entry.get()
            if not data_file:
                self.show_copyable_dialog("No File Selected", "Please select a Phone Data File (CSV) first.")
                return
            
            if not Path(data_file).exists():
                self.show_copyable_dialog("Error", f"File not found: {data_file}")
                return
            
            # Read CSV file
            df = pd.read_csv(data_file)
            
            # Get today's date filter if Date column exists
            today = date.today().isoformat()
            using_date_filter = False
            date_filter_msg = ""
            
            if 'Date' in df.columns:
                df_today = df[df['Date'] == today]
                if len(df_today) == 0:
                    # If no records for today, use all records but show warning
                    df_today = df
                    date_filter_msg = f"⚠️ No records found for today ({today})\nAnalyzing all {len(df)} records instead\n\n"
                else:
                    using_date_filter = True
            else:
                df_today = df
            
            # Normalize phone numbers function
            def normalize_phone(phone):
                # Remove all non-digits
                digits = re.sub(r'\D', '', str(phone))
                # Add + prefix if not present and has country code
                if len(digits) == 11 and digits.startswith('1'):
                    return '+' + digits
                elif len(digits) == 10:
                    return '+1' + digits
                elif digits.startswith('+'):
                    return digits
                else:
                    return '+' + digits if digits else ''
            
            # Connect to database
            conn = sqlite3.connect('progress_shared.db')
            cursor = conn.cursor()
            
            # Get all phones from database for comparison
            cursor.execute('SELECT phone, status FROM messages')
            db_records = cursor.fetchall()
            db_phones = {phone: status for phone, status in db_records}
            
            # Check status for each phone in CSV
            sent = 0
            failed = 0
            pending = 0
            not_in_db = 0
            sample_mismatches = []
            
            for idx, row in df_today.iterrows():
                phone_raw = str(row['Phone']).strip()
                phone_normalized = normalize_phone(phone_raw)
                
                if phone_normalized in db_phones:
                    status = db_phones[phone_normalized]
                    if status == 'sent':
                        sent += 1
                    elif status == 'failed':
                        failed += 1
                    elif status == 'pending':
                        pending += 1
                else:
                    not_in_db += 1
                    if len(sample_mismatches) < 3:  # Keep first 3 mismatches
                        sample_mismatches.append(f"{phone_raw} -> {phone_normalized}")
            
            conn.close()
            
            # Build status message in a copyable text widget
            status_window = tk.Toplevel(self.root)
            status_window.title("CSV File Status")
            status_window.geometry("500x450")
            
            # Create text widget with scrollbar
            text_frame = tk.Frame(status_window)
            text_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
            
            scrollbar = tk.Scrollbar(text_frame)
            scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
            
            text_widget = tk.Text(text_frame, wrap=tk.WORD, padx=10, pady=10, yscrollcommand=scrollbar.set)
            text_widget.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
            scrollbar.config(command=text_widget.yview)
            
            # Add right-click context menu for copying
            context_menu = tk.Menu(text_widget, tearoff=0)
            context_menu.add_command(label="Copy", command=lambda: text_widget.event_generate("<<Copy>>"))
            context_menu.add_command(label="Select All", command=lambda: text_widget.tag_add(tk.SEL, "1.0", tk.END))
            
            def show_context_menu(event):
                context_menu.tk_popup(event.x_root, event.y_root)
            
            text_widget.bind("<Button-3>", show_context_menu)  # Right-click
            
            # Build message
            status_msg = f"CSV File Analysis\n"
            status_msg += f"{'='*50}\n\n"
            status_msg += f"File: {Path(data_file).name}\n\n"
            
            if date_filter_msg:
                status_msg += date_filter_msg
            elif using_date_filter:
                status_msg += f"Date Filter: {today}\n"
                status_msg += f"Total in file: {len(df)}\n"
                status_msg += f"Today's records: {len(df_today)}\n\n"
            else:
                status_msg += f"Total records: {len(df)}\n\n"
            
            status_msg += f"Database Status:\n"
            status_msg += f"✅ Sent: {sent}\n"
            status_msg += f"❌ Failed: {failed}\n"
            status_msg += f"⌛ Pending: {pending}\n"
            status_msg += f"❓ New (not in DB): {not_in_db}\n\n"
            status_msg += f"Total analyzed: {len(df_today)}\n"
            
            if sample_mismatches:
                status_msg += f"\nSample phones not found (first 3):\n"
                for mismatch in sample_mismatches:
                    status_msg += f"  {mismatch}\n"
            
            status_msg += f"\n{'='*50}\n"
            status_msg += f"Note: Phone numbers are normalized to +1XXXXXXXXXX format\n"
            status_msg += f"Right-click to copy or use Ctrl+A to select all, Ctrl+C to copy"
            
            # Insert text
            text_widget.insert("1.0", status_msg)
            text_widget.config(state=tk.NORMAL)  # Keep editable for copying
            
            # Bind keyboard shortcuts
            text_widget.bind("<Control-a>", lambda e: text_widget.tag_add(tk.SEL, "1.0", tk.END))
            text_widget.bind("<Control-A>", lambda e: text_widget.tag_add(tk.SEL, "1.0", tk.END))
            
            # Add close button
            close_btn = tk.Button(status_window, text="Close", command=status_window.destroy)
            close_btn.pack(pady=5)
            
            # Update status bar
            self.update_status(f"✓ CSV: {pending} pending, {sent} sent, {failed} failed, {not_in_db} new", "info")
            
        except Exception as e:
            self.show_copyable_dialog("Error", f"Failed to check file:\n\n{str(e)}")
            self.update_status("❌ File check failed", "error")
    
    def start_chrome_debug(self):
        """Start Chrome with remote debugging"""
        try:
            import subprocess
            
            # Check if batch file exists
            batch_file = Path("start_chrome_debug.bat")
            if not batch_file.exists():
                self.show_copyable_dialog("Error", "start_chrome_debug.bat not found!")
                return
            
            # Run the batch file in a new window
            subprocess.Popen(
                ["cmd", "/c", "start", str(batch_file.absolute())],
                creationflags=subprocess.CREATE_NEW_CONSOLE
            )
            
            self.update_status("✅ Chrome debug mode starting...", "success")
            self.show_copyable_dialog(
                "Chrome Debug Started",
                "Chrome is starting with remote debugging.\n\n"
                "Please wait for Chrome to open and:\n"
                "1. Login to Google Voice if needed\n"
                "2. Navigate to https://voice.google.com/messages\n\n"
                "Then click 'Send Messages' in the GUI."
            )
            
        except Exception as e:
            self.show_copyable_dialog("Error", f"Failed to start Chrome debug:\n\n{str(e)}")
            self.update_status("❌ Failed to start Chrome", "error")


def main():
    root = tk.Tk()
    app = PTextingGUI(root)
    root.mainloop()


if __name__ == "__main__":
    main()
