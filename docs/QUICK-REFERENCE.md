# DFWorX Quick Reference Guide

## Directory Structure

```
DFWorX/
├── apps/               → Next.js applications
├── services/           → FastAPI backend services
├── packages/           → Shared code (UI, types, utils)
├── infrastructure/     → Docker, Coolify, Supabase
├── scripts/            → Utility scripts
└── docs/               → Documentation
```

## Essential Commands

### Setup & Development

```bash
./scripts/setup.sh      # Initial setup
./scripts/dev.sh        # Start dev environment
./scripts/build-all.sh  # Build all projects
./scripts/test-all.sh   # Run all tests
./scripts/deploy.sh     # Deploy to production
```

### Frontend (PNPM)

```bash
pnpm dev                # Start all apps
pnpm build              # Build all apps
pnpm test               # Run tests
pnpm lint               # Lint code
pnpm format             # Format code
```

### Backend (UV)

```bash
cd services/auth-service
uv run uvicorn src.main:app --reload  # Start service
uv run pytest                          # Run tests
uv run ruff check .                    # Lint
uv run mypy src/                       # Type check
```

## Data Management Quick Reference

### Where to Store Data

| Data Type | Location | Example |
|-----------|----------|---------|
| User accounts | `public.users` | All user info |
| Organizations | `public.organizations` | Tenants |
| Web profiles | `app_web.profiles` | Web user bios |
| Web posts | `app_web.posts` | Blog posts |
| Admin settings | `app_admin.settings` | Admin config |
| Live chat | ConvexDB | Real-time messages |
| Session data | Redis | Active sessions |

### Database Access Pattern

```python
# Shared data
from packages.python_common import get_db_client
db = get_db_client()
users = db.table('users').select('*').execute()

# App-specific data
profiles = db.table('profiles').select('*').execute()

# With RLS (automatic organization isolation)
posts = db.table('posts').select('*').eq('status', 'published').execute()
```

### Frontend Data Fetching

```typescript
// Shared data via API
const { data: user } = useQuery({
  queryKey: ['user', userId],
  queryFn: () => fetch(`/api/users/${userId}`).then(r => r.json())
})

// Real-time data via Convex
const messages = useQuery(api.messages.list, { channelId })
```

## Environment Variables

### Required for All Apps

```bash
# apps/web/.env.local
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_SUPABASE_URL=your-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-key

# services/auth-service/.env
DATABASE_URL=postgresql://...
SUPABASE_URL=your-url
SUPABASE_KEY=your-service-role-key
JWT_SECRET_KEY=your-secret-key
```

## Common Tasks

### Add a New App

```bash
cd apps
pnpm create next-app@latest my-app --typescript --tailwind
# Add to pnpm-workspace.yaml (auto-included via apps/*)
pnpm install
```

### Add a New Service

```bash
mkdir -p services/my-service/src
cd services/my-service
uv init
uv add fastapi uvicorn pydantic pydantic-settings
```

### Create a Migration

```bash
cd infrastructure/supabase
# Create migration file
supabase migration new add_feature_table
# Edit the SQL file
# Apply locally
supabase db push
```

### Add Shared UI Component

```bash
cd packages/ui
npx shadcn-ui@latest add button
# Export in src/index.ts
```

## File Locations

| What | Where |
|------|-------|
| Docs | `docs/` |
| Migrations | `infrastructure/supabase/migrations/` |
| Docker configs | `infrastructure/docker/` |
| Shared types | `packages/types/src/` |
| Shared UI | `packages/ui/src/` |
| Scripts | `scripts/` |

## Troubleshooting

### Port in Use

```bash
lsof -i :3000    # Find process
kill -9 <PID>    # Kill it
```

### Database Issues

```bash
# Reset local database
docker-compose -f infrastructure/docker/docker-compose.yml down -v
docker-compose -f infrastructure/docker/docker-compose.yml up -d
```

### PNPM Issues

```bash
pnpm store prune
rm -rf node_modules
pnpm install
```

### UV Issues

```bash
rm -rf .venv
uv venv
uv sync
```

## Documentation Links

- [Workspace Guide](workspace.md)
- [Data Management](data-management.md)
- [Architecture](architecture.md)
- [Data Diagrams](data-architecture-diagram.md)
- [Main Tools](main-tools.md)

## Best Practices Checklist

- [ ] Files under 500 lines
- [ ] Functions under 50 lines
- [ ] All functions have type hints
- [ ] All endpoints have tests
- [ ] RLS policies on all tables
- [ ] Migrations have comments
- [ ] Environment variables in .env.example
- [ ] README in each app/service

## Git Workflow

```bash
git checkout -b feature/my-feature
# Make changes
git add .
git commit -m "feat: add my feature"
git push origin feature/my-feature
# Create PR on GitHub
```

## Deployment

### Coolify

```bash
git push origin main  # Auto-deploys via Coolify
```

### Docker

```bash
./scripts/deploy.sh
# Or manually:
cd infrastructure/docker
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

---

For detailed information, see the full documentation in `docs/`.
