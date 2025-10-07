# Apache Hosting Guide

## Quick Start Options

### Option 1: Local Apache Server (No Root Required)
```bash
# Build and serve with Python/Node HTTP server
npm run serve
```
This will build your app and serve it on `http://localhost:8080`

### Option 2: Development with Apache
```bash
# Start development server with Apache-like serving
npm run dev:apache
```

### Option 3: Full Apache Setup (Requires Root)
```bash
# Run the full Apache setup script
sudo ./apache-setup.sh
```

## Detailed Setup Instructions

### Method 1: Python HTTP Server (Easiest)

```bash
# Build the app
npm run build

# Serve with Python
cd dist
python3 -m http.server 8080

# Access at: http://localhost:8080
# From other devices: http://[YOUR_IP]:8080
```

### Method 2: Node HTTP Server

```bash
# Install http-server globally
npm install -g http-server

# Build the app
npm run build

# Serve with Node
cd dist
http-server -p 8080 -a 0.0.0.0 --cors

# Access at: http://localhost:8080
# From other devices: http://[YOUR_IP]:8080
```

### Method 3: Full Apache Setup

```bash
# Run the setup script (requires root)
sudo ./apache-setup.sh

# Your app will be available at:
# - http://thika-booking.local
# - https://thika-booking.local (self-signed SSL)
```

## Finding Your Server IP

```bash
# Get your local IP address
hostname -I

# Or use this command
ip addr show | grep inet
```

## Accessing from Other Devices

1. **Find your server IP** using the commands above
2. **On the client device**, open a web browser
3. **Navigate to**: `http://[YOUR_IP]:8080`

### Example:
- Server IP: `192.168.1.100`
- Access URL: `http://192.168.1.100:8080`

## Updating Your App

### For Python/Node servers:
```bash
# Rebuild and restart
npm run build
# Then restart your server
```

### For Apache:
```bash
# Rebuild
npm run build

# Copy to Apache directory
sudo cp -r dist/* /var/www/thika-booking-haven/

# Reload Apache
sudo systemctl reload apache2
```

## Troubleshooting

### Port 8080 already in use
```bash
# Find what's using port 8080
lsof -i :8080

# Kill the process
sudo kill -9 [PID]

# Or use a different port
python3 -m http.server 8081
```

### Permission denied
```bash
# Make scripts executable
chmod +x apache-local.sh
chmod +x apache-setup.sh
```

### Apache not starting
```bash
# Check Apache status
sudo systemctl status apache2

# Check Apache logs
sudo tail -f /var/log/apache2/error.log

# Restart Apache
sudo systemctl restart apache2
```

### CORS issues
The scripts include CORS headers, but if you still have issues:
```bash
# For Python server
python3 -m http.server 8080 --bind 0.0.0.0

# For Node server
http-server -p 8080 -a 0.0.0.0 --cors
```

## Security Notes

- **Development only**: These setups are for development/testing
- **Production**: Use proper web servers like Nginx or Apache with SSL
- **Firewall**: Make sure port 8080 is open if accessing from other devices

## Quick Commands Summary

```bash
# Development
npm run dev                    # Local development
npm run dev:online            # Development + Apache-like serving
npm run dev:apache            # Development + Apache-like serving
npm run dev:global            # Development + Global access (Cloudflare)

# Production
npm run build                 # Build for production
npm run serve                 # Build + serve with Python/Node
sudo ./apache-setup.sh       # Full Apache setup (requires root)

# Utilities
npm run preview              # Preview built app
npm run analyze              # Analyze bundle size
```

## Network Access

Once running, your app will be accessible:
- **Locally**: `http://localhost:8080`
- **Network**: `http://[YOUR_IP]:8080`
- **Apache**: `http://thika-booking.local` (after full setup)

Choose the method that best fits your needs! 
