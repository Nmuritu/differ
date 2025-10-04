#!/bin/bash

# Cloudflare Tunnel Setup for Global Internet Access
# This script creates a public tunnel accessible from anywhere in the world

echo "🌍 Setting up Cloudflare Tunnel for GLOBAL Internet Access..."
echo "🌐 This will make your app accessible from ANYWHERE in the world!"

# Check if cloudflared is installed
if ! command -v cloudflared &> /dev/null; then
    echo "📦 Installing cloudflared for global access..."
    
    # Detect architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64) ARCH="amd64" ;;
        aarch64) ARCH="arm64" ;;
        armv7l) ARCH="arm" ;;
        *) echo "❌ Unsupported architecture: $ARCH"; exit 1 ;;
    esac
    
    echo "🔧 Detected architecture: $ARCH"
    
    # Download cloudflared
    echo "⬇️ Downloading cloudflared..."
    wget -O cloudflared.deb "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}.deb"
    
    # Install cloudflared
    echo "📦 Installing cloudflared..."
    sudo dpkg -i cloudflared.deb
    rm cloudflared.deb
    
    echo "✅ cloudflared installed successfully"
else
    echo "✅ cloudflared already installed"
fi

# Check cloudflared version
echo "🔍 Cloudflared version: $(cloudflared version)"

# Build the app
echo "🏗️ Building React app for global deployment..."
if ! npm run build; then
    echo "❌ Build failed. Please check for errors."
    exit 1
fi

# Check if dist directory exists
if [ ! -d "dist" ]; then
    echo "❌ dist directory not found. Build may have failed."
    exit 1
fi

echo "✅ App built successfully"

# Find available port
PORT=8080
while lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; do
    echo "⚠️  Port $PORT is in use, trying $((PORT + 1))..."
    PORT=$((PORT + 1))
done

echo "✅ Using port $PORT"

# Start local server in background
echo "🚀 Starting local server on port $PORT..."
cd dist
python3 -m http.server $PORT --bind 127.0.0.1 &
LOCAL_PID=$!

# Wait for local server to start
echo "⏳ Waiting for local server to start..."
sleep 5

# Test local server
if ! curl -s http://localhost:$PORT > /dev/null; then
    echo "❌ Local server failed to start on port $PORT"
    kill $LOCAL_PID 2>/dev/null
    exit 1
fi

echo "✅ Local server running on http://localhost:$PORT"

# Start Cloudflare tunnel
echo ""
echo "🌐 Starting Cloudflare tunnel for GLOBAL access..."
echo "🌍 This will create a public URL accessible from anywhere in the world!"
echo ""
echo "📋 Instructions:"
echo "1. If this is your first time, you'll need to login to Cloudflare"
echo "2. Choose a subdomain for your app (e.g., myapp.trycloudflare.com)"
echo "3. Your app will be accessible globally at: https://[subdomain].trycloudflare.com"
echo ""
echo "🌐 GLOBAL ACCESS FEATURES:"
echo "   • Accessible from any country"
echo "   • Works on mobile and desktop"
echo "   • HTTPS encryption enabled"
echo "   • Fast loading worldwide"
echo "   • No firewall issues"
echo ""
echo "🔗 Share the URL with anyone, anywhere in the world!"
echo "Press Ctrl+C to stop both the local server and tunnel"
echo ""

# Start tunnel with better configuration
cloudflared tunnel --url http://localhost:$PORT --no-autoupdate

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Stopping services..."
    echo "🔄 Cleaning up local server..."
    kill $LOCAL_PID 2>/dev/null
    echo "✅ Cleanup complete"
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

# Wait for user to stop
wait
