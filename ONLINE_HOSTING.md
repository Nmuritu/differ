# Online Hosting Guide

## Quick Start

### Option 1: Apache Local Server (Recommended)
```bash
npm run dev:online
```
This will build your app and make it accessible online using Apache-like HTTP server.

### Option 2: Local Development Only
```bash
npm run dev
```
This starts your app only on localhost:8080 for development.

### Option 3: Production Build + Serve
```bash
npm run serve
```
This builds and serves your app for production.

## Prerequisites

### Python3 (Recommended)
```bash
# Install Python3 if not available
sudo apt install python3
```

### Node.js (Alternative)
```bash
# Install Node.js if not available
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## How It Works

1. **`npm run dev:online`** builds your app and starts Apache-like HTTP server
2. Server automatically finds an available port (starting from 8080)
3. App is accessible locally and from other devices on your network
4. You get both local and network URLs

## Output Example

```
🌐 Starting Apache Local Server...
✅ Using port 8080
🏗️ Building React app...
✅ Using Python3 HTTP server

🚀 Starting server on port 8080...
🌍 Your app is accessible at:
   • http://localhost:8080
   • http://192.168.1.100:8080 (from other devices on your network)

📱 Share the network URL with others to access your app online!
```

## Troubleshooting

### Port already in use
- The script automatically finds the next available port
- Or kill the process: `lsof -ti:8080 | xargs kill -9`

### Build failed
- Check for TypeScript errors: `npm run lint`
- Ensure all dependencies are installed: `npm install`

### Python/Node not found
- Install Python3: `sudo apt install python3`
- Or install Node.js: `curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs`

## Network Access

### From Other Devices
1. Find your server IP: `hostname -I`
2. Access from other devices: `http://[YOUR_IP]:8080`
3. Make sure devices are on the same network

### Firewall
```bash
# Allow port 8080 (if using firewall)
sudo ufw allow 8080
```

## Production Deployment

For production, use:
- **Vercel**: `npm run build && vercel --prod`
- **Netlify**: `npm run build && netlify deploy --prod --dir=dist`
- **Railway**: `npm run build && railway up`
- **Apache**: `sudo ./apache-setup.sh`

See `APACHE_HOSTING.md` and `DEPLOYMENT_GUIDE.md` for detailed instructions.
