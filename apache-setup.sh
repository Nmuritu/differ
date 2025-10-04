#!/bin/bash

# Apache Setup Script for Thika Booking Haven
# This script sets up Apache to serve your React app online

echo "🌐 Setting up Apache for Thika Booking Haven..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root (use sudo)"
    exit 1
fi

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install Apache
echo "🔧 Installing Apache..."
apt install apache2 -y

# Enable Apache modules
echo "⚙️ Enabling required Apache modules..."
a2enmod rewrite
a2enmod headers
a2enmod ssl

# Create virtual host configuration
echo "📝 Creating virtual host configuration..."
cat > /etc/apache2/sites-available/thika-booking.conf << 'EOF'
<VirtualHost *:80>
    ServerName thika-booking.local
    DocumentRoot /var/www/thika-booking-haven
    
    # Enable rewrite engine
    RewriteEngine On
    
    # Handle React Router (SPA)
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.html [L]
    
    # Security headers
    Header always set X-Content-Type-Options nosniff
    Header always set X-Frame-Options DENY
    Header always set X-XSS-Protection "1; mode=block"
    
    # CORS headers for API calls
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
    
    # Handle preflight requests
    RewriteCond %{REQUEST_METHOD} OPTIONS
    RewriteRule ^(.*)$ $1 [R=200,L]
</VirtualHost>

<VirtualHost *:443>
    ServerName thika-booking.local
    DocumentRoot /var/www/thika-booking-haven
    
    # SSL Configuration (self-signed for development)
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
    
    # Enable rewrite engine
    RewriteEngine On
    
    # Handle React Router (SPA)
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.html [L]
    
    # Security headers
    Header always set X-Content-Type-Options nosniff
    Header always set X-Frame-Options DENY
    Header always set X-XSS-Protection "1; mode=block"
    
    # CORS headers for API calls
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
    
    # Handle preflight requests
    RewriteCond %{REQUEST_METHOD} OPTIONS
    RewriteRule ^(.*)$ $1 [R=200,L]
</VirtualHost>
EOF

# Create deployment directory
echo "📁 Creating deployment directory..."
mkdir -p /var/www/thika-booking-haven

# Build the React app
echo "🏗️ Building React app..."
cd /home/ghost/Programming/gange/thika-booking-haven-main
npm run build

# Copy built files to Apache directory
echo "📋 Copying built files to Apache directory..."
cp -r dist/* /var/www/thika-booking-haven/

# Set proper permissions
echo "🔐 Setting proper permissions..."
chown -R www-data:www-data /var/www/thika-booking-haven
chmod -R 755 /var/www/thika-booking-haven

# Enable the site
echo "🌐 Enabling the site..."
a2ensite thika-booking.conf
a2dissite 000-default.conf

# Restart Apache
echo "🔄 Restarting Apache..."
systemctl restart apache2
systemctl enable apache2

# Configure firewall
echo "🔥 Configuring firewall..."
ufw allow 80
ufw allow 443
ufw allow 22

echo ""
echo "✅ Apache setup complete!"
echo ""
echo "🌍 Your app is now accessible at:"
echo "   • http://thika-booking.local"
echo "   • https://thika-booking.local (self-signed certificate)"
echo ""
echo "📝 To access from other devices:"
echo "   1. Find your server IP: ip addr show | grep inet"
echo "   2. Add this line to /etc/hosts on client devices:"
echo "      [SERVER_IP] thika-booking.local"
echo "   3. Or access directly via IP: http://[SERVER_IP]"
echo ""
echo "🔄 To update the app:"
echo "   1. Run: npm run build"
echo "   2. Run: sudo cp -r dist/* /var/www/thika-booking-haven/"
echo "   3. Run: sudo systemctl reload apache2"
echo ""
echo "📊 Apache status: systemctl status apache2"
echo "📋 Apache logs: tail -f /var/log/apache2/error.log"
