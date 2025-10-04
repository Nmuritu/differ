#!/bin/bash

# Railway Deployment Script
# Deploy your app to Railway for global access

echo "🚂 Deploying to Railway for Global Access..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "📦 Installing Railway CLI..."
    
    # Install Railway CLI
    curl -fsSL https://railway.app/install.sh | sh
    
    # Add to PATH
    export PATH="$HOME/.railway/bin:$PATH"
    
    echo "✅ Railway CLI installed"
else
    echo "✅ Railway CLI already installed"
fi

# Login to Railway
echo "🔐 Logging into Railway..."
railway login

# Initialize Railway project (if not already done)
if [ ! -f "railway.json" ]; then
    echo "📝 Initializing Railway project..."
    railway init
fi

# Create railway.json configuration
cat > railway.json << 'EOF'
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm run serve",
    "healthcheckPath": "/",
    "healthcheckTimeout": 100,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
EOF

# Create Procfile for Railway
cat > Procfile << 'EOF'
web: npm run serve
EOF

# Create nixpacks.toml for better build configuration
cat > nixpacks.toml << 'EOF'
[phases.setup]
nixPkgs = ["nodejs", "npm"]

[phases.install]
cmds = ["npm ci"]

[phases.build]
cmds = ["npm run build"]

[start]
cmd = "npm run serve"
EOF

# Deploy to Railway
echo "🚀 Deploying to Railway..."
railway up

echo ""
echo "✅ Deployment initiated!"
echo "🌍 Your app will be available at: https://[your-app].railway.app"
echo "📊 Check deployment status: railway status"
echo "📋 View logs: railway logs"
echo "🔗 Open app: railway open"
