# REAL SMS SENDING SCRIPT - Configure with Twilio credentials
$accountSid = "your-twilio-account-sid"
$authToken = "your-twilio-auth-token"  
$twilioNumber = "+1234567890"  # Your Twilio phone number

$headers = @{
    'Authorization' = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$accountSid" + ':' + "$authToken"))
}

$body = @{
    'From' = $twilioNumber
    'To' = "305-905-5068"
    'Body' = "TEST: WARP AI dormancy system working. Time: 06:33"
}

Invoke-RestMethod -Uri "https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json" -Method POST -Headers $headers -Body $body
