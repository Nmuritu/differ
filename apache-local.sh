#!/bin/bash

# Apache Local Server (No Root Required)
# This script builds and serves your React app using Apache-like HTTP server

echo "🌐 Starting Apache Local Server..."

# Function to get local IP
get_local_ip() {
    if command -v hostname &> /dev/null; then
        hostname -I | awk '{print $1}'
    elif command -v ip &> /dev/null; then
        ip route get 1 | awk '{print $7; exit}'
    else
        echo "localhost"
    fi
}

# Function to check if port is in use
check_port() {
    local port=$1
    if command -v lsof &> /dev/null; then
        lsof -i :$port > /dev/null 2>&1
    elif command -v netstat &> /dev/null; then
        netstat -tuln | grep -q ":$port "
    else
        return 1
    fi
}

# Find available port
PORT=8080
while check_port $PORT; do
    echo "⚠️  Port $PORT is in use, trying $((PORT + 1))..."
    PORT=$((PORT + 1))
done

echo "✅ Using port $PORT"

# Build the app
echo "🏗️ Building React app..."
if ! npm run build; then
    echo "❌ Build failed. Please check for errors."
    exit 1
fi

# Check if dist directory exists
if [ ! -d "dist" ]; then
    echo "❌ dist directory not found. Build may have failed."
    exit 1
fi

# Copy .htaccess file for Apache SPA routing
if [ -f "dist/.htaccess" ]; then
    echo "✅ .htaccess file found for SPA routing"
else
    echo "⚠️  .htaccess file not found - SPA routing may not work properly"
fi

# Get local IP
LOCAL_IP=$(get_local_ip)

# Choose server method
if command -v python3 &> /dev/null; then
    echo "✅ Using Python3 HTTP server"
    echo ""
    echo "🚀 Starting server on port $PORT..."
    echo "🌍 Your app is accessible at:"
    echo "   • http://localhost:$PORT"
    echo "   • http://$LOCAL_IP:$PORT (from other devices on your network)"
    echo ""
    echo "📱 Share the network URL with others to access your app online!"
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    cd dist
    
    # Copy the SPA server script to the dist directory
    cp ../spa-server.py .
    chmod +x spa-server.py
    
    # Use the improved SPA server script
    PORT=$PORT python3 spa-server.py
    
elif command -v node &> /dev/null; then
    echo "✅ Using Node.js HTTP server"
    
    # Install http-server if not available
    if ! command -v http-server &> /dev/null; then
        echo "📦 Installing http-server..."
        if ! npm install -g http-server; then
            echo "❌ Failed to install http-server. Please install manually: npm install -g http-server"
            exit 1
        fi
    fi
    
    echo ""
    echo "🚀 Starting server on port $PORT..."
    echo "🌍 Your app is accessible at:"
    echo "   • http://localhost:$PORT"
    echo "   • http://$LOCAL_IP:$PORT (from other devices on your network)"
    echo ""
    echo "📱 Share the network URL with others to access your app online!"
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    cd dist
    
    # Create a simple SPA routing handler for Node.js server
    cat > spa-server.js << 'EOF'
const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const PORT = process.env.PORT || 8080;

const mimeTypes = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon'
};

const server = http.createServer((req, res) => {
  const parsedUrl = url.parse(req.url);
  let pathname = parsedUrl.pathname;
  
  // Add CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  
  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }
  
  // Check if it's a static file that exists
  const filePath = path.join(__dirname, pathname);
  if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
    const ext = path.extname(filePath).toLowerCase();
    const contentType = mimeTypes[ext] || 'application/octet-stream';
    
    res.writeHead(200, { 'Content-Type': contentType });
    fs.createReadStream(filePath).pipe(res);
  } else if (pathname.startsWith('/static/') || pathname.startsWith('/assets/') || path.extname(pathname)) {
    // It's a static file that doesn't exist, return 404
    res.writeHead(404, { 'Content-Type': 'text/html' });
    res.end('<h1>404 - File not found</h1>');
  } else {
    // For SPA routing, serve index.html for all non-file requests
    const indexPath = path.join(__dirname, 'index.html');
    res.writeHead(200, { 'Content-Type': 'text/html' });
    fs.createReadStream(indexPath).pipe(res);
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(\`Server running at http://0.0.0.0:\${PORT}/\`);
});
EOF
    
    node spa-server.js
    
else
    echo "❌ Neither Python3 nor Node.js found"
    echo "Please install one of them to use this script:"
    echo "  • Python3: sudo apt install python3"
    echo "  • Node.js: curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs"
    exit 1
fi
