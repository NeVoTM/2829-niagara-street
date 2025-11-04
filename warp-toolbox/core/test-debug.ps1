# test-debug.ps1 - Quick Test for Debug Toolbox
# Rule: Simple is always better | Start small and grow

Write-Host "🧪 TESTING DEBUG TOOLBOX" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Blue
Write-Host ""

# Test 1: Basic system check
Write-Host "✅ Test 1: System Check" -ForegroundColor Green
.\DebugToolbox.ps1 check
Write-Host ""

# Test 2: Error pattern matching
Write-Host "✅ Test 2: Error Pattern Matching" -ForegroundColor Green
.\DebugToolbox.ps1 error "Cannot find path"
Write-Host ""

# Test 3: Port check
Write-Host "✅ Test 3: Port Check" -ForegroundColor Green
.\DebugToolbox.ps1 port 80
Write-Host ""

# Test 4: File check (this script itself)
Write-Host "✅ Test 4: File Check" -ForegroundColor Green
.\DebugToolbox.ps1 file "test-debug.ps1"
Write-Host ""

# Test 5: Menu display
Write-Host "✅ Test 5: Menu Display" -ForegroundColor Green
Write-Host "Menu should show below..." -ForegroundColor Yellow
.\DebugToolbox.ps1
Write-Host ""

Write-Host "🎉 All tests completed!" -ForegroundColor Green
Write-Host "💡 If no errors above, toolbox is working!" -ForegroundColor Cyan