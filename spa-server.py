#!/usr/bin/env python3
"""
Simple SPA Server for React Applications
Handles client-side routing by serving index.html for all non-file requests
"""

import http.server
import socketserver
import os
import urllib.parse
import mimetypes

class SPAHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Parse the URL
        parsed_path = urllib.parse.urlparse(self.path)
        path = parsed_path.path
        
        # Check if it's a static file that exists
        file_path = '.' + path
        
        # List of static file extensions
        static_extensions = ['.js', '.css', '.png', '.jpg', '.jpeg', '.gif', '.svg', '.ico', '.woff', '.woff2', '.ttf', '.eot']
        
        # Check if it's a static file
        is_static_file = (
            path.startswith('/static/') or 
            path.startswith('/assets/') or 
            any(path.endswith(ext) for ext in static_extensions) or
            ('.' in path.split('/')[-1] and not path.endswith('/'))
        )
        
        if is_static_file and os.path.isfile(file_path):
            # Serve the static file
            super().do_GET()
        else:
            # For SPA routing, serve index.html
            self.path = '/index.html'
            super().do_GET()
    
    def end_headers(self):
        # Add CORS headers
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        super().end_headers()

if __name__ == "__main__":
    PORT = int(os.environ.get('PORT', 8080))
    
    # Only change to dist directory if not already there
    if not os.path.exists('index.html') and os.path.exists('dist/index.html'):
        os.chdir('dist')
    
    with socketserver.TCPServer(("", PORT), SPAHandler) as httpd:
        print(f"🚀 SPA Server running at http://localhost:{PORT}/")
        print(f"🌍 Also accessible at http://0.0.0.0:{PORT}/ (from other devices)")
        print("📱 Share the network URL with others to access your app online!")
        print("Press Ctrl+C to stop the server")
        httpd.serve_forever()
