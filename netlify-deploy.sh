#!/bin/bash

# Netlify Deployment Script
# Deploy your app to Netlify for global access

echo "🌐 Deploying to Netlify for Global Access..."

# Check if Netlify CLI is installed
if ! command -v netlify &> /dev/null; then
    echo "📦 Installing Netlify CLI..."
    npm install -g netlify-cli
    echo "✅ Netlify CLI installed"
else
    echo "✅ Netlify CLI already installed"
fi

# Create netlify.toml configuration
cat > netlify.toml << 'EOF'
[build]
  command = "npm run build"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[build.environment]
  NODE_VERSION = "18"
EOF

# Create _redirects file for SPA routing
cat > public/_redirects << 'EOF'
/*    /index.html   200
EOF

# Login to Netlify (if not already logged in)
echo "🔐 Checking Netlify authentication..."
if ! netlify status &> /dev/null; then
    echo "Please login to Netlify..."
    netlify login
fi

# Build the app
echo "🏗️ Building app..."
npm run build

# Deploy to Netlify
echo "🚀 Deploying to Netlify..."
netlify deploy --prod --dir=dist

echo ""
echo "✅ Deployment complete!"
echo "🌍 Your app is now live on Netlify!"
echo "📊 Check deployment: netlify status"
echo "🔗 Open app: netlify open"
