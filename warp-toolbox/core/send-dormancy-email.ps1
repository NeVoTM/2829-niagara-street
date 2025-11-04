# REAL EMAIL SENDING SCRIPT - Configure with your credentials
$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$gmailUser = "your-gmail@gmail.com"  # Your Gmail address
$gmailAppPassword = "your-16-char-app-password"  # Gmail App Password

$securePassword = ConvertTo-SecureString $gmailAppPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($gmailUser, $securePassword)

Send-MailMessage -To "elichalfinny@gmail.com" -From $gmailUser -Subject "TEST: WARP AI Dormancy System" -Body "This is a test of the WARP AI dormancy notification system. If you receive this, the system is working correctly." -SmtpServer $smtpServer -Port $smtpPort -UseSsl -Credential $credential
