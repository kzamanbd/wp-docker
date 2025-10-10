#!/bin/bash
# Script to generate cloudflared config and credentials from environment variables

# Load environment variables
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "Error: .env file not found"
  echo "Please create a .env file based on .env.example"
  exit 1
fi

# Create cloudflared directory if it doesn't exist
mkdir -p cloudflared

# Generate the config.yml file
cat > cloudflared/config.yml << EOL
# Auto-generated from .env file - DO NOT EDIT DIRECTLY
tunnel: ${CLOUDFLARE_TUNNEL_NAME}
credentials-file: /etc/cloudflared/${CLOUDFLARE_TUNNEL_ID}.json

ingress:
  - hostname: ${WP_HOSTNAME}
    service: http://wordpress-app:80
    originRequest:
      noTLSVerify: true
  - service: http_status:404
EOL

# Generate the tunnel credentials JSON file
cat > cloudflared/${CLOUDFLARE_TUNNEL_ID}.json << EOL
{
    "AccountTag": "${CLOUDFLARE_ACCOUNT_TAG}",
    "TunnelSecret": "${CLOUDFLARE_TUNNEL_SECRET}",
    "TunnelID": "${CLOUDFLARE_TUNNEL_ID}",
    "Endpoint": ""
}
EOL

echo "Cloudflared configuration generated successfully"
echo "Config file: cloudflared/config.yml"
echo "Credentials file: cloudflared/${CLOUDFLARE_TUNNEL_ID}.json"
echo "Domain: ${WP_HOSTNAME}"
echo "Please ensure your DNS settings in Cloudflare point to the tunnel."