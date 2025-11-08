# DFWorX

> Modern full-stack monorepo for building scalable web applications

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

DFWorX is a production-ready monorepo workspace that combines the best of modern web technologies:

- **Frontend**: Next.js 14, React 18, Tailwind CSS, Shadcn UI
- **Backend**: FastAPI, Python 3.12+, Pydantic v2
- **Database**: Supabase (PostgreSQL), ConvexDB
- **DevOps**: Docker, Coolify, PNPM, UV

## Quick Start

### Prerequisites

- Node.js 18+
- Python 3.12+
- PNPM 8+
- UV
- Docker

### Installation

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd DFWorX
   ```

2. Run setup script:
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. Configure environment variables:
   ```bash
   # Edit the following files:
   apps/web/.env.local
   services/auth-service/.env
   infrastructure/docker/.env
   ```

4. Start development environment:
   ```bash
   ./scripts/dev.sh
   ```

5. Access the applications:
   - Web: http://localhost:3000
   - API: http://localhost:8000
   - API Docs: http://localhost:8000/docs

## Project Structure

```
DFWorX/
├── apps/                     # Next.js applications
│   └── web/                  # Main web app
├── services/                 # FastAPI backend services
│   └── auth-service/         # Authentication service
├── packages/                 # Shared code
│   ├── ui/                   # React components
│   ├── config/               # Shared configs
│   ├── types/                # TypeScript types
│   └── python-common/        # Python utilities
├── infrastructure/           # Infrastructure as code
│   ├── docker/               # Docker configs
│   ├── coolify/              # Coolify configs
│   └── supabase/             # Database migrations
├── scripts/                  # Utility scripts
└── docs/                     # Documentation
```

## Available Scripts

### Development

```bash
./scripts/dev.sh          # Start development environment
./scripts/build-all.sh    # Build all projects
./scripts/test-all.sh     # Run all tests
./scripts/lint.sh         # Run linting
./scripts/clean.sh        # Clean build artifacts
./scripts/deploy.sh       # Deploy to production
```

### PNPM Commands

```bash
pnpm dev                  # Start all apps in dev mode
pnpm build                # Build all projects
pnpm test                 # Run all tests
pnpm lint                 # Lint all code
pnpm format               # Format code
```

## Documentation

- [Quick Reference](docs/QUICK-REFERENCE.md) - Commands and quick tips
- [Workspace Guide](docs/workspace.md) - Complete workspace documentation
- [Data Management](docs/data-management.md) - Shared vs app-specific data strategy
- [Data Architecture](docs/data-architecture-diagram.md) - Visual data flow diagrams
- [System Architecture](docs/architecture.md) - Architecture and design patterns
- [Tech Stack](docs/main-tools.md) - Tools and technologies
- [Docker Setup](infrastructure/docker/README.md) - Docker configuration
- [Coolify Deployment](infrastructure/coolify/README.md) - Deployment guide

## Tech Stack

### Frontend
- **Next.js 14** - React framework with App Router
- **React 18** - UI library
- **Tailwind CSS** - Utility-first CSS
- **Shadcn UI** - Component library
- **TypeScript** - Type safety

### Backend
- **FastAPI** - Modern Python API framework
- **Python 3.12+** - Programming language
- **UV** - Fast package manager
- **Pydantic v2** - Data validation

### Database
- **Supabase** - PostgreSQL with auth
- **ConvexDB** - Real-time backend (optional)

### DevOps
- **Docker** - Containerization
- **Coolify** - Self-hosted deployment
- **PNPM** - Fast package manager
- **GitHub Actions** - CI/CD

## Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-feature
   ```

2. **Make changes and test**:
   ```bash
   pnpm dev                    # Test locally
   pnpm test                   # Run tests
   pnpm lint                   # Check linting
   ```

3. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add my feature"
   ```

4. **Push and create PR**:
   ```bash
   git push origin feature/my-feature
   ```

## Adding New Applications

### Add a Next.js App

```bash
cd apps
pnpm create next-app@latest my-app --typescript --tailwind --app
```

### Add a FastAPI Service

```bash
mkdir -p services/my-service/src
cd services/my-service
uv init
uv add fastapi uvicorn pydantic
```

## Environment Variables

See example files:
- [apps/web/.env.example](apps/web/.env.example)
- [services/auth-service/.env.example](services/auth-service/.env.example)
- [infrastructure/docker/.env.example](infrastructure/docker/.env.example)

## Deployment

### Using Coolify

1. Push to GitHub:
   ```bash
   git push origin main
   ```

2. Coolify auto-deploys from main branch

### Using Docker

```bash
./scripts/deploy.sh
```

Or manually:

```bash
cd infrastructure/docker
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## Testing

### Run All Tests

```bash
./scripts/test-all.sh
```

### Frontend Tests

```bash
pnpm test
```

### Backend Tests

```bash
cd services/auth-service
uv run pytest --cov=src
```

## Code Quality

### Linting

```bash
./scripts/lint.sh
```

### Formatting

```bash
pnpm format
```

### Type Checking

```bash
pnpm typecheck
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Best Practices

- Follow [CLAUDE.md](~/.claude/CLAUDE.md) guidelines for Python code
- Use conventional commits (feat, fix, docs, etc.)
- Write tests for all new features
- Keep functions under 50 lines
- Document with docstrings
- Use type hints everywhere

## Troubleshooting

### Port Already in Use

```bash
# Find process using port
lsof -i :3000
# Kill process
kill -9 <PID>
```

### Docker Issues

```bash
# Reset Docker environment
docker-compose down -v
docker system prune -a
```

### PNPM Issues

```bash
# Clear cache and reinstall
pnpm store prune
rm -rf node_modules
pnpm install
```

### UV Issues

```bash
# Remove and recreate venv
rm -rf .venv
uv venv
uv sync
```

## License

MIT

## Support

For issues and questions:
- Open an issue on GitHub
- Check documentation in [docs/](docs/)
- Review [workspace.md](docs/workspace.md)

---

**Built with ❤️ using modern web technologies**
