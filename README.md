# Dockerized WordPress with Cloudflare Tunnel

A small Docker Compose setup for running WordPress and related services, with Cloudflare Tunnel (`cloudflared`) integration.

## Contents

- `docker-compose.yml` - Compose file to build and run services.
- `cloudflared/` - Cloudflare Tunnel configuration. Keep your `cert.pem` and `config.yml` here.
- `.env` - Environment variables file for storing credentials and configuration.
- `.env.example` - Template for creating your own `.env` file.
- `setup-cloudflared.sh` - Script to generate cloudflared configuration from environment variables.

## Quick start

 Build and start services:

```bash
docker-compose up -d --build
```

Check logs:

```bash
docker-compose logs -f
```

Stop and remove containers:

```bash
docker-compose down
```

## Using Environment Variables

This project uses a `.env` file to store sensitive credentials. To get started:

1. Copy the example environment file:

```bash
cp .env.example .env
```

1. Edit the `.env` file with your actual values:

```bash
# Cloudflare Tunnel Credentials
CLOUDFLARE_TUNNEL_NAME=your-tunnel-name
CLOUDFLARE_TUNNEL_ID=your-tunnel-id-here
CLOUDFLARE_ACCOUNT_TAG=your-account-tag-here
CLOUDFLARE_TUNNEL_SECRET=your-tunnel-secret-here

# WordPress Hostnames
WP_HOSTNAME=your-wordpress-domain.com
```

1. Run the setup script to generate cloudflared configuration:

```bash
./setup-cloudflared.sh
```

## cloudflared notes

- After running the setup script, your `cloudflared/` directory will contain generated configuration files based on your `.env` values.
- The script will create:
  - `config.yml` - Tunnel configuration based on your environment variables
  - `<TUNNEL-ID>.json` - Credentials file with your account and tunnel information
- Do not commit these generated files or the `.env` file to public repositories.

- To run the tunnel locally for development:

```bash
cloudflared tunnel --config cloudflared/config.yml run
```

## Troubleshooting

- If WordPress can't connect to the database, ensure the database container is healthy and the credentials in `wp-config.php` match the database service environment variables.
- If Cloudflare Tunnel fails to start, check `cloudflared/cert.pem` and `cloudflared/*.json` credentials and verify the `config.yml` paths.

## Security

- Keep `cloudflared/cert.pem` and any credential JSON files secure.
- Add the following to your `.gitignore` file to keep sensitive files out of version control:

  ```bash
  .env
  cloudflared/cert.pem
  cloudflared/*.json
  ```

## License

Add your license or project-specific notes here.
