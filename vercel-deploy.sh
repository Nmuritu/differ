#!/bin/bash

# Vercel Deployment Script
# Deploy your app to Vercel for global access

echo "▲ Deploying to Vercel for Global Access..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo " Installing Vercel CLI..."
    npm install -g vercel
    echo " Vercel CLI installed"
else
    echo " Vercel CLI already installed"
fi

# Create vercel.json configuration
cat > vercel.json << 'EOF'
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "dist"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ],
  "buildCommand": "npm run build",
  "outputDirectory": "dist"
}
EOF

# Login to Vercel (if not already logged in)
echo " Checking Vercel authentication..."
if ! vercel whoami &> /dev/null; then
    echo "Please login to Vercel..."
    vercel login
fi

# Deploy to Vercel
echo " Deploying to Vercel..."
vercel --prod

echo ""
echo " Deployment complete!"
echo " Your app is now live on Vercel!"
echo " Check deployment: vercel ls"
echo " Open app: vercel open"
