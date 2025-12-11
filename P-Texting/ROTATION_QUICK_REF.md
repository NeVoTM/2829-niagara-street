# Rotation Tracking - Quick Reference

## 4 Critical Variables to Track

| Variable | Field Name | Example Value | Why It Matters |
|----------|-----------|---------------|----------------|
| 🌐 **Browser** | `sent_by_browser` | `chrome`, `edge`, `firefox`, `opera` | Different fingerprints = Different people |
| 📧 **Email** | `sent_by_email` | `user1@gmail.com` | Multiple accounts = Bypass daily limits |
| 📱 **Phone** | `sent_by_tel` | `+13055551234` | Rotating numbers = Reduce spam flags |
| 🗺️ **IP Address** | `sent_by_ip` | `123.45.67.89` | Different IPs = Different locations |

## Quick Commands

### 1. Backup Database
```bash
copy progress_shared.db progress_shared_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%.db
```

### 2. Run Migration (Add New Fields)
```bash
python utilities\add_tracking_fields.py
```

### 3. Check Current IP
```bash
python utilities\get_ip_address.py
```

### 4. Check Database Status
```bash
python check_database_status.py
```

## Config File Template

Add these fields to your config files:

```json
{
  "browser": "chrome",
  "voice_email": "user1@gmail.com",
  "voice_phone": "+13055551001",
  "remote_debugging_port": 9222
}
```

## Browser-Specific Configs

| Browser | Port | Config File | Status |
|---------|------|-------------|--------|
| Chrome | 9222 | `config_chrome.json` | ✅ Working |
| Edge | 9223 | `config_edge.json` | ✅ Working |
| Firefox | 9224 | `config_firefox.json` | ⚠️ Re-login required |
| Opera | 9225 | `config_opera.json` | 🚧 In progress |

## Daily Rotation Example

### Morning Session (8am-12pm)
```
Account:  account1 (user1@gmail.com)
Phone:    +13055551001
Browser:  Chrome
VPN:      New York
Messages: 250
```

### Afternoon Session (2pm-6pm)
```
Account:  account2 (user2@gmail.com)
Phone:    +13055551003
Browser:  Edge
VPN:      Chicago
Messages: 250
```

### Evening Session (6pm-10pm)
```
Account:  account3 (user3@gmail.com)
Phone:    +13055551005
Browser:  Firefox
VPN:      Los Angeles
Messages: 250
```

## Safety Limits

| Limit Type | Value | Notes |
|------------|-------|-------|
| Per Account/Day | 250 | Stay under 300 hard limit |
| Per IP/Day | 500 | Change VPN if hitting this |
| Per Browser/Session | 100 | Rotate every 100 messages |
| Batch Size | 7 | Messages per batch |
| Delay Between Batches | 45-55 sec | With 10 sec jitter |

## Monitoring Queries

### Check sends by browser today
```sql
SELECT sent_by_browser, COUNT(*) 
FROM messages 
WHERE status='sent' AND DATE(sent_at)=DATE('now')
GROUP BY sent_by_browser;
```

### Check sends by account today
```sql
SELECT sent_by_email, COUNT(*) 
FROM messages 
WHERE status='sent' AND DATE(sent_at)=DATE('now')
GROUP BY sent_by_email;
```

### Check sends by IP today
```sql
SELECT sent_by_ip, COUNT(*) 
FROM messages 
WHERE status='sent' AND DATE(sent_at)=DATE('now')
GROUP BY sent_by_ip;
```

### Success rate by rotation combo
```sql
SELECT 
    sent_by_browser,
    sent_by_email,
    COUNT(*) as total,
    SUM(CASE WHEN status='sent' THEN 1 ELSE 0 END) as sent,
    ROUND(100.0 * SUM(CASE WHEN status='sent' THEN 1 ELSE 0 END) / COUNT(*), 1) as success_pct
FROM messages
WHERE sent_at IS NOT NULL
GROUP BY sent_by_browser, sent_by_email
ORDER BY success_pct DESC;
```

## Red Flags 🚩

Stop and change settings if you see:
- ⚠️ More than 250 sends from one account today
- ⚠️ More than 500 sends from one IP today
- ⚠️ More than 100 consecutive sends from same browser
- ⚠️ Success rate drops below 90%
- ⚠️ Multiple "limit_reached" errors

## Change Checklist

### When Changing VPN
1. ✅ Change VPN server in VPN app
2. ✅ Wait 10 seconds for connection
3. ✅ Verify new IP: `python utilities\get_ip_address.py`
4. ✅ Proceed with next batch

### When Changing Browser
1. ✅ Close current browser instance
2. ✅ Start new browser debug: `browser_launchers\start_XXX_debug.bat`
3. ✅ Log into Google Voice (if needed)
4. ✅ Update config to new browser
5. ✅ Run P-Texting GUI for that browser

### When Changing Account
1. ✅ Check today's send count for new account
2. ✅ Confirm under 250 sends today
3. ✅ Log out of current Google Voice account
4. ✅ Log into new Google Voice account
5. ✅ Update config with new email/phone
6. ✅ Proceed with next batch

## Files Created (Today)

1. ✅ `test_data_enhanced.csv` - Test data with all tracking fields
2. ✅ `utilities\add_tracking_fields.py` - Database migration script
3. ✅ `utilities\get_ip_address.py` - IP detection utility
4. ✅ `MULTI_ACCOUNT_ROTATION_STRATEGY.md` - Complete strategy guide
5. ✅ `DATABASE_ENHANCEMENT_SUMMARY.md` - Implementation summary
6. ✅ `ROTATION_QUICK_REF.md` - This quick reference

## Next Actions

### Today
- [ ] Backup database
- [ ] Run migration script
- [ ] Test IP detection

### This Week
- [ ] Update config files with voice fields
- [ ] Update sending scripts to populate new fields
- [ ] Test with 5 messages
- [ ] Verify fields in database

### Next 2 Weeks
- [ ] Set up 2-4 Google Voice accounts
- [ ] Set up VPN with multiple locations
- [ ] Create rotation schedule
- [ ] Start tracking success rates

---

**Keep this file handy during sending sessions!**
