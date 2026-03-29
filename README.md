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

volumes:
  rustbin-data:
```

## Configuration

Refer to the [original repo](https://github.com/PeroSar/rustbin#configuration).
