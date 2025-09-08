#!/bin/bash

# Update package list and install NGINX
apt-get update
apt-get install -y nginx

# Create a simple HTML page
cat > /var/www/html/index.html << EOF
<html>
<head>
    <title>Azure VMSS Demo</title>
</head>
<body>
    <h1>Hello from Azure VMSS!</h1>
    <p>Hostname: $(hostname)</p>
</body>
</html>
EOF

# Ensure NGINX starts on boot and start it now
systemctl enable nginx
systemctl start nginx
