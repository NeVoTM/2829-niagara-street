# Multi-Account Rotation Strategy

## Overview
To avoid detection and bypass daily limits, the P-Texting system tracks **4 critical variables** for each message sent:

1. **Browser** (`sent_by_browser`) - Different browser fingerprints
2. **Email/Account** (`sent_by_email`) - Multiple Google Voice accounts
3. **Phone Number** (`sent_by_tel`) - Multiple phone numbers per account
4. **IP Address** (`sent_by_ip`) - VPN/proxy rotation for location diversity

## Why This Matters

### Detection Avoidance
Blast texting systems are detected by patterns:
- Same browser fingerprint sending many messages
- Same IP address sending many messages
- Same account sending rapidly
- Consistent timing patterns

### Mimicking Human Behavior (P2P)
By rotating these 4 variables, we create the appearance of:
- Different people (different browsers, IPs)
- Different locations (different IPs, VPNs)
- Different accounts (different emails, phone numbers)
- Natural distribution across time and space

## Database Schema Enhancement

### New Fields Added to `messages` Table

```sql
-- Existing fields
phone TEXT NOT NULL,
name TEXT,
status TEXT,
attempts INTEGER,
last_error TEXT,
last_attempt_at TIMESTAMP,
sent_at TIMESTAMP,
sent_by_account TEXT,        -- Legacy: account label (account1, account2, etc.)
last_attempted_by_account TEXT,
message_hash TEXT,

-- NEW FIELDS for rotation tracking
sent_by_email TEXT,           -- Email/account used (e.g., "user1@gmail.com")
sent_by_tel TEXT,             -- Phone number used (e.g., "+13055551234")
sent_by_browser TEXT,         -- Browser used (e.g., "chrome", "edge", "firefox")
sent_by_ip TEXT               -- IP address (e.g., "123.45.67.89")
```

## Rotation Strategies

### 1. Browser Rotation

**Available Browsers:**
- Chrome (primary, most tested)
- Edge (works well)
- Firefox (requires re-login each session)
- Opera (setup in progress)
- Brave (future)
- Vivaldi (future)

**Strategy:**
- Rotate browsers every 50-100 messages
- Use different browser profiles for each account
- Each browser has unique fingerprint (User-Agent, canvas, WebGL, etc.)

**Implementation:**
```python
# In config files
config_chrome.json:  {"browser": "chrome", "remote_debugging_port": 9222}
config_edge.json:    {"browser": "edge", "remote_debugging_port": 9223}
config_firefox.json: {"browser": "firefox", "remote_debugging_port": 9224}
config_opera.json:   {"browser": "opera", "remote_debugging_port": 9225}
```

### 2. Email/Account Rotation

**Setup:**
- Create multiple Google Voice accounts
- Each with unique email address
- Each can have 1 or more phone numbers

**Example Accounts:**
```
account1: user1@gmail.com → +13055551001, +13055551002
account2: user2@gmail.com → +13055551003
account3: user3@gmail.com → +13055551004, +13055551005
account4: user4@gmail.com → +13055551006
```

**Daily Limits:**
- Google Voice: ~300 texts per account per day
- By rotating 4 accounts: 1,200 texts/day capacity

**Strategy:**
- Track sends per account per day
- Switch accounts when approaching 250 sends (safety margin)
- Log into different account in browser before next batch

### 3. Phone Number Rotation

**Setup:**
- Each Google Voice account can have multiple phone numbers
- Some accounts might have 1 number, others 2-3

**Why This Matters:**
- Recipients see the "From" number
- Rotating numbers reduces spam flags
- Each number has its own reputation

**Strategy:**
- Rotate phone numbers within same account
- Track which number sent to which recipient
- Avoid sending from same number to same recipient twice

### 4. IP Address Rotation

**Methods:**

#### A. VPN Rotation
- Use VPN service with multiple locations
- Change VPN server every 100-200 messages
- Popular VPNs: NordVPN, ExpressVPN, Private Internet Access

**Locations to Rotate:**
```
- New York, NY
- Los Angeles, CA
- Chicago, IL
- Miami, FL
- Dallas, TX
- Seattle, WA
```

#### B. Residential Proxies
- More expensive but harder to detect
- IP addresses from real residential ISPs
- Services: Bright Data, Smartproxy, Oxylabs

#### C. Mobile Hotspot
- Use phone's mobile data as hotspot
- Different carrier = different IP
- Very legitimate-looking traffic

**Implementation:**
```python
from utilities.get_ip_address import get_public_ip

# Before sending batch
current_ip = get_public_ip()
print(f"Sending from IP: {current_ip}")

# After changing VPN
new_ip = get_public_ip()
if new_ip == current_ip:
    print("WARNING: VPN change failed, still same IP!")
```

## Rotation Schedule Example

### Daily Campaign: 1,000 Messages

**Morning (8am-12pm): 250 messages**
- Account: account1 (user1@gmail.com)
- Phone: +13055551001
- Browser: Chrome
- IP: New York VPN server
- Messages: 0-250

**Lunch (12pm-2pm): BREAK**
- Change VPN to Chicago
- Switch browser to Edge
- Log into account2

**Afternoon (2pm-6pm): 250 messages**
- Account: account2 (user2@gmail.com)
- Phone: +13055551003
- Browser: Edge
- IP: Chicago VPN server
- Messages: 251-500

**Evening (6pm-9pm): 250 messages**
- Account: account3 (user3@gmail.com)
- Phone: +13055551004
- Browser: Firefox
- IP: Los Angeles VPN server
- Messages: 501-750

**Night (9pm-11pm): 250 messages**
- Account: account4 (user4@gmail.com)
- Phone: +13055551006
- Browser: Chrome (different profile)
- IP: Miami VPN server
- Messages: 751-1000

## Future: Automated Rotation

### Smart Rotation Logic
```python
class RotationManager:
    def get_next_config(self):
        """
        Returns next config based on:
        1. Daily send count per account
        2. Last browser used
        3. Time since last IP change
        4. Success rate of recent sends
        """
        
        # Check daily limits
        if account1_today < 250:
            account = "account1"
        elif account2_today < 250:
            account = "account2"
        # ... etc
        
        # Rotate browser every 100 messages
        if messages_sent % 100 == 0:
            browser = next_browser()
        
        # Change IP every 200 messages or 2 hours
        if messages_sent % 200 == 0 or hours_since_ip_change > 2:
            suggest_vpn_change()
        
        return {
            "account": account,
            "phone": get_phone_for_account(account),
            "browser": browser,
            "ip": get_current_ip()
        }
```

## Platform Expansion

### Beyond Google Voice

When Google Voice limits are reached, expand to:

#### 1. Skype
- Different API/web interface
- Different rate limits
- Different phone numbers

#### 2. Twilio
- API-based (more reliable)
- Pay per message
- Better for high volume

#### 3. TextNow
- Free texting service
- Multiple accounts possible

#### 4. Burner Apps
- Burner phone numbers
- Temporary numbers
- Good for short campaigns

#### 5. Open Source Solutions
- FreePBX
- Asterisk
- Self-hosted VoIP

### Multi-Platform Rotation
```
Day 1: Google Voice account1 → 300 messages
Day 2: Google Voice account2 → 300 messages
Day 3: Skype account1 → 200 messages
Day 4: TextNow account1 → 250 messages
Day 5: Back to Google Voice account1 (refreshed limit)
```

## Monitoring & Analytics

### Track Rotation Effectiveness

**Queries to Run:**

```sql
-- Sends by browser
SELECT sent_by_browser, COUNT(*) as count
FROM messages
WHERE status = 'sent'
GROUP BY sent_by_browser;

-- Sends by account
SELECT sent_by_email, COUNT(*) as count
FROM messages
WHERE status = 'sent' AND DATE(sent_at) = DATE('now')
GROUP BY sent_by_email;

-- Sends by IP
SELECT sent_by_ip, COUNT(*) as count
FROM messages
WHERE status = 'sent'
GROUP BY sent_by_ip
ORDER BY count DESC;

-- Success rate by browser
SELECT 
    sent_by_browser,
    COUNT(*) as total,
    SUM(CASE WHEN status='sent' THEN 1 ELSE 0 END) as sent,
    ROUND(100.0 * SUM(CASE WHEN status='sent' THEN 1 ELSE 0 END) / COUNT(*), 2) as success_rate
FROM messages
GROUP BY sent_by_browser;
```

### Red Flags
- Same IP used for >500 sends in one day
- Same account used for >300 sends in one day
- Same browser used for all sends
- All sends from same location/IP

## Best Practices

### DO:
✅ Rotate all 4 variables regularly
✅ Keep daily sends under 250 per account (safety margin)
✅ Use natural timing (breaks between batches)
✅ Monitor success rates by account/IP/browser
✅ Keep backups of database
✅ Track which combinations work best

### DON'T:
❌ Send 1,000 messages from same IP
❌ Use one browser for everything
❌ Hit 300 send limit (stop at 250)
❌ Send at exact same time every day
❌ Ignore failed sends patterns
❌ Use same phone number for repeat sends to same recipient

## Migration Instructions

### Step 1: Backup Database
```bash
cp progress_shared.db progress_shared_backup_$(date +%Y%m%d).db
```

### Step 2: Run Migration Script
```bash
python utilities/add_tracking_fields.py
```

### Step 3: Update Config Files
Add to each config:
```json
{
  "voice_email": "user1@gmail.com",
  "voice_phone": "+13055551001",
  "browser": "chrome"
}
```

### Step 4: Update Sending Scripts
Modify `send_texts_date_filter.py` to:
1. Get current IP before sending
2. Read voice_email and voice_phone from config
3. Save all 4 fields when updating message status

### Step 5: Test with Small Batch
Send 5-10 test messages and verify all fields are populated in database.

## Summary

By tracking and rotating these 4 variables:
1. **Browser** - Different fingerprints
2. **Email/Account** - Bypass daily limits
3. **Phone Number** - Reduce spam flags
4. **IP Address** - Appear in different locations

You create a distributed, natural-looking send pattern that mimics real person-to-person texting rather than automated blast texting.

**Result:** Higher success rates, fewer blocks, better deliverability.
