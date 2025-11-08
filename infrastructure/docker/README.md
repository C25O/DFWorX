# Docker Infrastructure

Docker configuration for running DFWorX services locally or in production.

## Quick Start

1. Copy environment file:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

2. Start development environment:
   ```bash
   docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
   ```

3. Access services:
   - Web: http://localhost:3000
   - API: http://localhost:8000
   - API Docs: http://localhost:8000/docs
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

## Available Commands

### Development
```bash
# Start all services in development mode
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Start specific service
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up web

# Rebuild and start
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

### Production
```bash
# Start in production mode
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Scale services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --scale api=3

# Stop production services
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
```

### Database Management
```bash
# Access PostgreSQL shell
docker exec -it dfworx-postgres psql -U dfworx -d dfworx

# Backup database
docker exec dfworx-postgres pg_dump -U dfworx dfworx > backup.sql

# Restore database
docker exec -i dfworx-postgres psql -U dfworx dfworx < backup.sql
```

### Maintenance
```bash
# Remove all containers and volumes
docker-compose down -v

# Prune unused images
docker system prune -a

# View resource usage
docker stats
```

## Services

### web (Next.js)
- Port: 3000
- Hot reload enabled in dev mode
- Production build in prod mode

### api (FastAPI)
- Port: 8000
- Auto-reload enabled in dev mode
- Multiple workers in prod mode

### postgres (PostgreSQL)
- Port: 5432
- Persistent data volume
- Health checks enabled

### redis (Redis)
- Port: 6379
- For caching and sessions
- Persistent data volume

## Environment Variables

See [.env.example](.env.example) for all available configuration options.

## Networking

All services run on the `dfworx-network` bridge network, allowing them to communicate using service names as hostnames.

## Volumes

- `postgres_data` - PostgreSQL data persistence
- `redis_data` - Redis data persistence

## Health Checks

Both PostgreSQL and Redis have health checks configured to ensure services are ready before dependent services start.
