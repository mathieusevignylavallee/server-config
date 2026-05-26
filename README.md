# Server Config

Docker Compose stacks for a self-hosted media server.

## Stacks

### `arr_stack` — Media automation

| Service | Purpose | Port |
|---|---|---|
| Jellyfin | Media streaming (GPU-accelerated) | 8096 |
| Sonarr | TV series management | 8989 |
| Radarr | Movie management | 7878 |
| Bazarr | Subtitle management | 6767 |
| Prowlarr | Indexer management (via VPN) | 9696 |
| qBittorrent | Torrent client (via VPN) | 8081 |
| Gluetun | WireGuard VPN gateway | — |
| FlareSolverr | Cloudflare bypass (via VPN) | 8191 |
| Tdarr | Media transcoding (GPU-accelerated) | 8265 |
| ArrStalledHandler | Auto-remove stalled downloads | — |

> qBittorrent, Prowlarr, and FlareSolverr route all traffic through Gluetun.

### `network` — Infrastructure

| Service | Purpose | Port |
|---|---|---|
| Nginx | Reverse proxy | 80, 443 |
| Homepage | Dashboard | 3000 |
| Glances | System monitoring | 61208 |
| Cloudflare DDNS | Dynamic DNS updater | — |
| Filebrowser | Web file manager | 8383 |

## Setup

```bash
# 1. Copy and fill in your env file
cp config/.env.example config/.env

# 2. Create the shared Docker network
docker network create network-docker-server

# 3. Start everything
./update.sh
```

## Recommended: Portainer

[Portainer](https://www.portainer.io/) is highly recommended for managing your containers. It gives you a clean web UI to monitor container status, view real-time logs, restart/stop services, inspect resource usage, and manage volumes and networks — all without touching the command line.

```bash
docker volume create portainer_data
docker run -d \
  -p 9000:9000 \
  --name portainer \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest
```

Access it at `http://<your-server-ip>:9000`.

## Scripts

```bash
./update.sh    # Pull latest images and redeploy all stacks
./restart.sh   # Restart all stacks without pulling new images
```

## Configuration

- `config/.env` — all environment variables (VPN keys, API keys, ports, etc.)
- `config/gluetun-auth-config.toml` — Gluetun HTTP control server auth
- `network/homepage/` — Homepage dashboard config (services, widgets, settings)
- `network/nginx/default.conf` — Nginx reverse proxy config
