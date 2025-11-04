// Popup script for Warp AI Dropdowns
// Direct PowerShell execution without server dependency

const DROPDOWN_SCRIPTS = {
    'debug': 'C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickDebug-Dropdown.ps1',
    'commands': 'C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickCommands-Dropdown.ps1', 
    'files': 'C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickFiles-Dropdown.ps1',
    'references': 'C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickReference-Selector.ps1'
};

const DROPDOWN_NAMES = {
    'debug': 'Debug Issues',
    'commands': 'Commands Browser',
    'files': 'Files Browser', 
    'references': 'Reference Selector'
};

function updateStatus(message, isSuccess = true) {
    const status = document.getElementById('status');
    status.textContent = message;
    status.style.background = isSuccess ? 
        'rgba(76, 175, 80, 0.3)' : 
        'rgba(244, 67, 54, 0.3)';
    
    // Reset after 3 seconds
    setTimeout(() => {
        status.textContent = 'Click buttons above or use hotkeys';
        status.style.background = 'rgba(255,255,255,0.1)';
    }, 3000);
}

function launchDropdown(type) {
    const scriptPath = DROPDOWN_SCRIPTS[type];
    const name = DROPDOWN_NAMES[type];
    
    if (!scriptPath) {
        updateStatus('Unknown dropdown type', false);
        return;
    }
    
    updateStatus(`Creating ${name} launcher...`);
    
    // Create proper batch file content
    const cleanPath = scriptPath.replace(/\\\\/g, '\\');
    const batchContent = `@echo off
cd /d "C:\\Users\\17274\\ME\\2829-Niagara-Street"
powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File "${cleanPath}"
pause
exit`;
    
    // Create and download the batch file
    const batchBlob = new Blob([batchContent], {type: 'application/octet-stream'});
    const batchUrl = URL.createObjectURL(batchBlob);
    
    const batchLink = document.createElement('a');
    batchLink.href = batchUrl;
    batchLink.download = `Warp-${type}-dropdown.bat`;
    batchLink.style.display = 'none';
    
    document.body.appendChild(batchLink);
    batchLink.click();
    document.body.removeChild(batchLink);
    
    // Clean up
    setTimeout(() => {
        URL.revokeObjectURL(batchUrl);
    }, 2000);
    
    updateStatus(`✅ ${name} launcher created!`);
    
    // Show instructions
    setTimeout(() => {
        updateStatus('🎯 Run the downloaded .bat file!');
    }, 2000);
    
    setTimeout(() => {
        updateStatus('💡 Or use hotkeys: Alt+Shift+1-4');
    }, 4000);
}

// Handle keyboard shortcuts from background script
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === 'launchDropdown') {
        launchDropdown(request.type);
        sendResponse({success: true});
    }
});

// Initialize popup
document.addEventListener('DOMContentLoaded', () => {
    console.log('🚀 Warp AI Dropdown Popup loaded');
});