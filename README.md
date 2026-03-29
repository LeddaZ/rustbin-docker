# rustbin-docker
Docker image for https://github.com/PeroSar/rustbin

## Running

### `docker run`

```sh
docker run -d \
  --name rustbin \
  -p 3000:3000 \
  -v rustbin-data:/app/data \
  -e DATABASE_URL=sqlite:///app/data/rustbin.db \
  -e HOST=0.0.0.0 \
  -e PORT=3000 \
  leddaz/rustbin:latest
```

### Docker Compose

```yaml
services:
  rustbin:
    image: leddaz/rustbin:latest
    container_name: rustbin
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - rustbin-data:/app/data
    environment:
      DATABASE_URL: sqlite:///app/data/rustbin.db
      HOST: 0.0.0.0
      PORT: 3000
      MAX_PASTE_SIZE: 2MB
      RENDER_CACHE_CAPACITY: 128
      CLEANUP_INTERVAL: 3600
      DB_MIN_CONNECTIONS: 1
      DB_MAX_CONNECTIONS: 5
      RUST_LOG: rustbin=info

volumes:
  rustbin-data:
```

## Configuration

All configuration is done through environment variables.

| Variable | Default | Description |
| --- | --- | --- |
| `DATABASE_URL` | `sqlite://rustbin.db` | SQLite connection string |
| `HOST` | `0.0.0.0` | Bind address |
| `PORT` | `3000` | Bind port |
| `MAX_PASTE_SIZE` | `2MB` | Maximum upload size (supports `KB`, `MB`, `GB`) |
| `RENDER_CACHE_CAPACITY` | `128` | Number of rendered HTML entries to cache |
| `CLEANUP_INTERVAL` | `3600` | Seconds between expired-paste cleanup runs |
| `DB_MIN_CONNECTIONS` | `1` | SQLite connection pool minimum |
| `DB_MAX_CONNECTIONS` | `5` | SQLite connection pool maximum |
| `RUST_LOG` | `rustbin=info` | Log level filter |
