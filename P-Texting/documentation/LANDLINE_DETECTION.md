# Landline Detection for Google Voice

## Common Google Voice Error Messages for Landlines

When you try to text a landline, Google Voice typically shows one of these messages:

1. **"Can't send SMS to landline"**
2. **"Can't send text messages to landline phone numbers"**
3. **"Unable to send to this number"**
4. **"This number cannot receive text messages"**
5. **"SMS not supported for this number"**
6. **"Cannot send message to landline number"**

## Implementation Strategy

### Status Types:
- **Current**: `pending`, `sending`, `sent`, `failed`, `limit_reached`
- **New**: `landline` - permanent failure, no retries

### Detection Pattern:
```python
# Check error text for landline keywords
landline_keywords = [
    'landline',
    'cannot receive text',
    'can\'t send sms',
    'sms not supported',
    'unable to send to this number'
]

if any(keyword in error_text.lower() for keyword in landline_keywords):
    return False, "LANDLINE_DETECTED"
```

### Database Handling:
- Messages marked as `landline` status will NOT be retried
- They will appear in reports as "Landline (permanent fail)"
- retry_count check will skip them

## Testing Recommendations

### How to Test:
1. **Find a known landline** - call a business and verify it's landline
2. **Add to test CSV** with 1-2 landline numbers
3. **Send messages** and watch for error
4. **Document exact error** Google Voice displays
5. **Verify no retries** happen for those numbers

### Expected Behavior After Implementation:
- First attempt to landline → Error detected
- Status set to `landline` (permanent)
- Never retries that number again
- Reports show clearly it's a landline
- Mobile numbers continue normally

## Benefits

✅ **Saves time** - no wasted retries on landlines  
✅ **Clear reporting** - know which are landlines vs. temporary failures  
✅ **Better efficiency** - focus retries on mobile numbers only  
✅ **Cost savings** - don't count landline attempts toward daily limit  

---

**Note**: We'll implement after you confirm the exact error message Google Voice shows!
