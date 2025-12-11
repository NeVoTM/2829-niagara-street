# Google Voice Sending Limits

## 📊 Current Understanding

### Batch Size Setting (Currently: 7)
The `batch_size: 7` setting in config is **NOT related to Google Voice limits**. It's for:
- **Pacing**: After every 7 messages, the system pauses for 45 seconds
- **Anti-spam**: Makes sending look more human-like
- **Safety**: Prevents overwhelming Google Voice servers

### Google Voice Actual Limits

#### Daily Limit: 250 messages per account
- **Confirmed**: 250 messages per day per Google Voice account
- **Resets**: At midnight Pacific Time
- **Workaround**: Use multiple accounts (Chrome account1 + Firefox account2 = 500/day)

#### Per-Message Sending
**Important Discovery**: You mentioned texting one at a time may not have limits!

**What we know:**
- Group messages (sending same message to multiple people at once) have strict limits
- Individual messages (one recipient at a time) may have different/higher limits
- Current system sends ONE message at a time (not groups) ✅

**What this means:**
- The system is already optimized for individual sending
- Each message goes to ONE person
- This may allow higher throughput than group messaging

### Monitoring for Limits

**Signs Google Voice has hit limit:**
1. Error message appears on screen: "limit" or "Limit" or "daily limit"
2. Messages fail to send
3. Google Voice shows error dialog

**Current detection in code:**
```python
# send_texts.py line 916-917
if 'limit' in error_text.lower():
    return False, "LIMIT_REACHED"
```

The system automatically stops when it detects the limit!

---

## 🔍 Testing Plan

### To Find the Real Limit:

1. **Monitor Database**:
   ```sql
   SELECT COUNT(*) FROM messages 
   WHERE status='sent' 
   AND DATE(sent_at) = '2025-11-23'
   AND account_label='account1';
   ```

2. **Watch for Errors**:
   - Check logs/run_chrome.log for "LIMIT_REACHED"
   - Watch console output during sending
   - Check reports after each session

3. **Track Sent Count**:
   - Open Report after every 50 messages
   - Note at what count Google Voice stops accepting
   - Document the exact error message

### Expected Outcomes:

**Scenario A: 250 limit still applies**
- System stops at 250 messages
- Error: "Daily limit reached"
- Use Firefox/second account for more

**Scenario B: Higher limit for individual sends**
- System sends beyond 250
- No errors until higher threshold
- Document new limit for future reference

---

## 🎯 Current System Behavior

### Batch Settings:
- **batch_size**: 7 (messages per batch)
- **delay_between_batches_seconds**: 45
- **per_message_delay_seconds**: 2

### Timing Example (7 messages):
```
Message 1: Send (2 sec delay)
Message 2: Send (2 sec delay)
Message 3: Send (2 sec delay)
Message 4: Send (2 sec delay)
Message 5: Send (2 sec delay)
Message 6: Send (2 sec delay)
Message 7: Send
[45 second batch delay]
Message 8: Send...
```

### Speed Calculation:
- 7 messages = ~14 seconds sending + 45 seconds delay = ~59 seconds
- Rate: ~7 messages per minute
- 100 messages: ~14 minutes
- 250 messages: ~35 minutes ⚡

---

## 💡 Recommendations

### For Your 361-Contact List:

**Option 1: Use Chrome Only (if limit > 250)**
- Let it run until it hits the actual limit
- Monitor where it stops
- Document the real limit

**Option 2: Use Both Browsers (if limit = 250)**
- Chrome: First 250 contacts
- Firefox: Next 111 contacts (or up to 250)
- Total: 361 sent in one day ✅

### Monitoring Strategy:

1. **Start sending** with Chrome
2. **Check reports** every 50 messages:
   - Click "Open Report" in GUI
   - Check sent count
3. **Watch console** for errors
4. **Note the limit** when/if it stops
5. **Document** findings for future

### Adjusting Batch Size:

**Current (Conservative)**:
- batch_size: 7
- Speed: ~7/minute

**Faster (if stable)**:
- batch_size: 15
- delay_between_batches_seconds: 30
- Speed: ~15/minute
- 250 messages: ~16 minutes

**Safest (most human-like)**:
- batch_size: 5
- delay_between_batches_seconds: 60
- Speed: ~5/minute
- More delays = safer

---

## 📝 Tracking Template

### Daily Send Log:
```
Date: 2025-11-23
Account: account1 (Chrome)
Starting time: 2:00 PM
Total to send: 361

Checkpoints:
- 50 sent: OK ✓
- 100 sent: OK ✓
- 150 sent: OK ✓
- 200 sent: OK ✓
- 250 sent: [Status?]
- 300 sent: [Status?]
- 361 sent: [Status?]

Final count: [?]
Errors: [?]
Limit reached: Yes/No at [?] messages
```

---

## 🚀 Key Insights

1. **Individual sending** (current system) may bypass group limits ✅
2. **250/day** is documented limit, but worth testing higher
3. **Monitoring** built-in: system detects "LIMIT_REACHED"
4. **Workaround ready**: Use Firefox for second 250 if needed
5. **Stop button** now available to pause anytime!

**Next step**: Run your 361-contact campaign and see where it stops! 📊
