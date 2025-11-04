// Background script for Warp AI Dropdown Hotkeys
// This handles global Chrome hotkeys and launches PowerShell dropdowns

const DROPDOWN_COMMANDS = {
  'debug-dropdown': {
    name: 'Debug Issues',
    powershell: 'powershell -WindowStyle Hidden -Command "& \\"C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickDebug-Dropdown.ps1\\""'
  },
  'commands-browser': {
    name: 'Commands Browser', 
    powershell: 'powershell -WindowStyle Hidden -Command "& \\"C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickCommands-Dropdown.ps1\\""'
  },
  'files-browser': {
    name: 'Files Browser',
    powershell: 'powershell -WindowStyle Hidden -Command "& \\"C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickFiles-Dropdown.ps1\\""'
  },
  'reference-selector': {
    name: 'Reference Selector',
    powershell: 'powershell -WindowStyle Hidden -Command "& \\"C:\\\\Users\\\\17274\\\\ME\\\\2829-Niagara-Street\\\\QuickReference-Selector.ps1\\""'
  }
};

// Listen for keyboard commands
chrome.commands.onCommand.addListener((command) => {
  console.log(`🔥 HOTKEY TRIGGERED: ${command}`);
  
  if (DROPDOWN_COMMANDS[command]) {
    const dropdownInfo = DROPDOWN_COMMANDS[command];
    console.log(`Opening ${dropdownInfo.name}...`);
    
    // Create a notification
    chrome.notifications.create({
      type: 'basic',
      iconUrl: 'icon48.png',
      title: 'Warp AI Dropdown',
      message: `Opening ${dropdownInfo.name}...`
    });
    
    // Launch PowerShell command via native messaging or web request
    launchPowerShellDropdown(dropdownInfo.powershell, dropdownInfo.name);
  }
});

// Function to launch PowerShell dropdown
function launchPowerShellDropdown(command, name) {
  console.log(`🚀 Attempting to launch ${name}...`);
  
  // Try HTTP server first
  fetch('http://localhost:8080/execute', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      command: command,
      name: name
    })
  })
  .then(response => {
    if (response.ok) {
      console.log(`✅ ${name} launched via HTTP server`);
      // Show success notification
      chrome.notifications.create({
        type: 'basic',
        iconUrl: 'icon.png',
        title: '🎯 Warp Dropdown Launched',
        message: `${name} is now open`
      });
    } else {
      console.log(`⚠️ HTTP server failed, creating batch launcher`);
      createBatchLauncher(command, name);
    }
  })
  .catch(error => {
    console.log(`❌ No HTTP server, creating batch launcher for ${name}`);
    createBatchLauncher(command, name);
  });
}

// Create batch file launcher as fallback
function createBatchLauncher(command, name) {
  // Extract script path from command
  const scriptMatch = command.match(/"([^"]+\.ps1)"/);
  if (scriptMatch) {
    const scriptPath = scriptMatch[1];
    
    const batchContent = `@echo off
echo 🚀 Launching ${name}...
cd /d "C:\\Users\\17274\\ME\\2829-Niagara-Street"
powershell.exe -ExecutionPolicy Bypass -WindowStyle Normal -File "${scriptPath}"
pause
exit`;
    
    // Create download
    const blob = new Blob([batchContent], {type: 'application/octet-stream'});
    const url = URL.createObjectURL(blob);
    
    chrome.downloads.download({
      url: url,
      filename: `Warp-${name.replace(/\s+/g, '-')}-launcher.bat`,
      saveAs: false
    }, (downloadId) => {
      if (downloadId) {
        console.log(`✅ Batch launcher created for ${name}`);
        chrome.notifications.create({
          type: 'basic',
          iconUrl: 'icon.png',
          title: '📥 Launcher Downloaded',
          message: `Run the ${name} batch file to launch dropdown`
        });
      }
    });
    
    // Clean up after download
    setTimeout(() => URL.revokeObjectURL(url), 3000);
  }
}

// Fallback: Show dropdown in browser
function showBrowserDropdown(name) {
  // Create or focus a tab with the dropdown content
  const dropdownUrl = `chrome-extension://${chrome.runtime.id}/dropdown.html?type=${encodeURIComponent(name)}`;
  
  chrome.tabs.create({
    url: dropdownUrl,
    active: true
  });
}

// Installation handler
chrome.runtime.onInstalled.addListener(() => {
  console.log('🚀 Warp AI Dropdown Hotkeys extension installed!');
  console.log('Global hotkeys registered:');
  console.log('- Ctrl+Alt+D: Debug Issues');
  console.log('- Ctrl+Alt+C: Commands Browser');
  console.log('- Ctrl+Alt+F: Files Browser');
  console.log('- Ctrl+Alt+R: Reference Selector');
});