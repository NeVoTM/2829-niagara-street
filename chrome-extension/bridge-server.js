// Simple HTTP server to bridge Chrome extension hotkeys to PowerShell scripts
// Run with: node bridge-server.js

const http = require('http');
const { exec } = require('child_process');
const url = require('url');

const PORT = 8080;

// CORS headers for Chrome extension
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type'
};

const server = http.createServer((req, res) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    res.writeHead(200, corsHeaders);
    res.end();
    return;
  }

  const parsedUrl = url.parse(req.url, true);
  
  if (req.method === 'POST' && parsedUrl.pathname === '/execute') {
    let body = '';
    
    req.on('data', chunk => {
      body += chunk.toString();
    });
    
    req.on('end', () => {
      try {
        const data = JSON.parse(body);
        const { command, name } = data;
        
        console.log(`🚀 Executing: ${name}`);
        console.log(`Command: ${command}`);
        
        // Execute the PowerShell command
        exec(command, (error, stdout, stderr) => {
          if (error) {
            console.error(`❌ Error executing ${name}:`, error);
            res.writeHead(500, { ...corsHeaders, 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ 
              success: false, 
              error: error.message 
            }));
          } else {
            console.log(`✅ ${name} launched successfully`);
            res.writeHead(200, { ...corsHeaders, 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ 
              success: true, 
              message: `${name} launched` 
            }));
          }
        });
        
      } catch (parseError) {
        console.error('❌ JSON parse error:', parseError);
        res.writeHead(400, { ...corsHeaders, 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ 
          success: false, 
          error: 'Invalid JSON' 
        }));
      }
    });
    
  } else if (req.method === 'GET' && parsedUrl.pathname === '/status') {
    // Health check endpoint
    res.writeHead(200, { ...corsHeaders, 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ 
      status: 'running', 
      port: PORT,
      message: 'Warp AI Dropdown Bridge Server' 
    }));
    
  } else {
    res.writeHead(404, { ...corsHeaders, 'Content-Type': 'text/plain' });
    res.end('Not Found');
  }
});

server.listen(PORT, () => {
  console.log(`🌉 Bridge Server running on http://localhost:${PORT}`);
  console.log('Ready to handle Chrome extension hotkey requests');
  console.log('Available endpoints:');
  console.log('- POST /execute - Execute PowerShell commands');
  console.log('- GET /status - Health check');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🛑 Shutting down bridge server...');
  server.close(() => {
    console.log('✅ Server closed');
    process.exit(0);
  });
});