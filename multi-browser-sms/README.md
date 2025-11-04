# 🚀 Multi-Browser SMS System

A powerful automated texting system that uses multiple browsers simultaneously to send messages through Google Messages Web. Perfect for bulk messaging with superior speed and reliability.

## ✨ Features

- **Multi-Browser Parallel Processing**: Utilizes all available browsers (Chrome, Firefox, Brave, Opera, Vivaldi, Edge)
- **5-10x Faster**: Send messages simultaneously across multiple browser sessions
- **Smart Load Balancing**: Automatic message distribution across browsers
- **Fault Tolerance**: Continue operation even if some browsers fail
- **Rate Limiting**: Built-in delays and caps to prevent spam detection
- **Real-time Monitoring**: Live progress tracking for each browser
- **Secure Authentication**: QR code-based login (no password storage)
- **Resume Capability**: Restart from where you left off if interrupted

## 🎯 Performance Expectations

| Browsers | Messages/Minute | 1000 Messages |
|----------|----------------|---------------|
| 1 Browser | 10-15 | ~60-100 min |
| 5 Browsers | 50-75 | ~13-20 min |
| 10 Browsers | 100-150 | ~7-10 min |

## 📋 Requirements

- Windows 10/11
- Python 3.12+
- One or more browsers: Chrome, Firefox, Brave, Opera GX, Vivaldi, Edge
- Google Messages mobile app on your phone

## 🚀 Quick Setup

### 1. Install Python
Download and install Python 3.12 from:
https://www.python.org/ftp/python/3.12.6/python-3.12.6-amd64.exe

**IMPORTANT**: Check "Add Python to PATH" during installation

### 2. Run Setup Script
Open PowerShell in this folder and run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup.ps1
```

### 3. Configure Recipients
Edit `sample_recipients.csv` with your phone numbers and messages:
```csv
phone,message,browser_assigned,status,sent_time
+15551234567,"Hello! This is a test message.",chrome,pending,
+15559876543,"Your exclusive opportunity awaits!",firefox,pending,
```

### 4. Run the System
```powershell
.\smsenv\Scripts\Activate.ps1
python multi_browser_sms.py --file sample_recipients.csv
```

## 📱 How It Works

1. **Browser Launch**: System opens all available browsers
2. **QR Authentication**: Scan QR code in each browser with Google Messages app
3. **Message Distribution**: Messages automatically distributed across browsers
4. **Parallel Sending**: All browsers send messages simultaneously
5. **Real-time Monitoring**: Watch progress and statistics live
6. **Completion Report**: Detailed summary of results

## 🛡️ Safety Features

- **Staggered Timing**: Browsers start at different intervals
- **Rate Limiting**: Configurable delays between messages
- **Daily Caps**: Optional message limits per day
- **Error Recovery**: Automatic retry and failover
- **Session Management**: Persistent authentication across runs

## 📊 Visual Interface

```
[CHROME] ████████░░ 82% (41/50 sent) | 15 msg/min
[FIREFOX] ██████░░░░ 64% (32/50 sent) | 12 msg/min
[BRAVE] ██████████ 100% (50/50 sent) | 18 msg/min
[OPERA] ███████░░░ 76% (38/50 sent) | 14 msg/min
[VIVALDI] █████████░ 88% (44/50 sent) | 16 msg/min

Total Progress: ████████░░ 82% (205/250 sent)
Estimated Time Remaining: 3 minutes
```

## ⚙️ Configuration

Create a `.env` file for custom settings:
```env
# Timing settings
MIN_DELAY=3
MAX_DELAY=8
DAILY_MESSAGE_LIMIT=500

# Browser settings
MAX_CONCURRENT_BROWSERS=10
HEADLESS_MODE=false

# Retry settings
MAX_RETRIES=3
RETRY_DELAY=5
```

## 📁 File Structure

```
multi-browser-sms/
├── browser_config.py          # Browser detection and management
├── multi_browser_manager.py   # Thread pool and orchestration
├── multi_browser_sms.py      # Main application
├── requirements.txt          # Python dependencies
├── setup.ps1                # Automated setup script
├── sample_recipients.csv     # Example message file
├── .env                     # Configuration (optional)
├── logs/                    # Application logs
└── browser_profiles/        # Browser user data
    ├── chrome_profile/
    ├── firefox_profile/
    └── ...
```

## 🔧 Advanced Usage

### Custom Message Templates
Use placeholders in your messages:
```csv
phone,message,first_name,last_name
+15551234567,"Hello {{first_name}}! Your opportunity at 2829 Niagara Street...",John,Smith
```

### Browser-Specific Assignment
Manually assign messages to specific browsers:
```csv
phone,message,browser_assigned,priority
+15551234567,"Important message",chrome,high
+15559876543,"Regular message",firefox,normal
```

### Bulk Import
Generate recipients from your CRM or database:
```python
import pandas as pd

# Load from Excel/CSV
df = pd.read_excel('contacts.xlsx')
df['message'] = 'Your custom message template'
df.to_csv('recipients.csv', index=False)
```

## ⚠️ Important Notes

- **Google Policy Compliance**: Respect Google's terms of service
- **Rate Limiting**: Don't exceed reasonable message volumes
- **Phone Number Format**: Use international format (+1234567890)
- **Message Content**: Avoid spam-like content
- **Testing**: Always test with a small batch first

## 🐛 Troubleshooting

### Browser Not Detected
- Ensure browsers are installed in standard locations
- Check if browser executable exists in the detected path
- Try running as administrator

### Driver Issues
- Drivers are auto-downloaded on first run
- Clear `browser_profiles/` folder if authentication fails
- Update browsers to latest versions

### Authentication Problems
- Scan QR codes promptly (they expire)
- Ensure Google Messages app is updated
- Check phone has internet connection

### Performance Issues
- Reduce `MAX_CONCURRENT_BROWSERS` if system is slow
- Increase delays if messages are getting blocked
- Monitor system resources (CPU/RAM)

## 📈 Scaling Up

### Adding More Browsers
The system automatically detects new browsers. Simply install more browsers and restart the application:

1. Install additional browsers (Chrome variants, Firefox variants)
2. Run browser detection: `python browser_config.py`
3. System automatically includes new browsers in next run

### Multiple Phone Numbers
Use multiple Google accounts with different phone numbers for even higher throughput.

## 🔒 Security & Privacy

- No passwords stored locally
- QR code authentication only
- Logs can be encrypted
- Browser profiles isolated
- Message data handled securely

## 📞 Support

For issues related to this system:
1. Check logs in `logs/` folder
2. Review browser profiles for authentication issues
3. Test with single browser first
4. Ensure all requirements are met

---

**Disclaimer**: This tool is for legitimate business communication only. Users are responsible for complying with all applicable laws and terms of service. Always obtain proper consent before sending messages.