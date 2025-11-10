# DFWorX Backend Services Setup Guide

**Purpose**: Connect DFWorX to all required backend services and deployment platforms
**Created**: November 8, 2025
**Status**: In Progress

---

## Overview

This guide walks through setting up connections to all backend services required for the DFWorX Blog + Chat application.

### Services to Configure

1. ✅ **GitHub** - Version control and CI/CD
2. 🔄 **ConvexDB** - Real-time chat database
3. ⏳ **Supabase** - PostgreSQL database for blog posts
4. ⏳ **Coolify** - Self-hosted deployment platform
5. ✅ **shadcn MCP** - UI component management (already configured)

---

## 1. GitHub Setup ✅

**Status**: Complete

**Repository**: https://github.com/C25O/DFWorX
**Branch**: master
**CI/CD**: GitHub Actions enabled

**What's Working**:
- Repository initialized and pushed
- GitHub Actions workflow configured
- Workflow scope granted

---

## 2. ConvexDB Setup 🔄

**Purpose**: Real-time chat, messages, tags, attachments, reactions

### Step 1: Create Convex Account

1. Visit https://convex.dev
2. Sign up or log in (GitHub OAuth recommended)
3. Create new project: "DFWorX"

### Step 2: Initialize Convex in Project

```bash
# From workspace root
npx convex dev

# This will:
# - Deploy schema to Convex cloud
# - Generate deployment URL
# - Create .env.local with NEXT_PUBLIC_CONVEX_URL
# - Watch for schema changes
```

### Step 3: Deploy Schema

The schema is already defined in `convex/schema.ts`. Running `npx convex dev` will automatically deploy it.

**Schema includes**:
- threads (global + per-post chat)
- messages (with threading support)
- tags (5 categories)
- messageTags & threadTags (many-to-many)
- attachments (file storage)
- reactions (emoji reactions)

### Step 4: Get Deployment URL

After running `npx convex dev`, you'll get:
```
Deployment URL: https://your-project.convex.cloud
```

Copy this URL for environment variables.

### Step 5: Configure Environment Variables

Add to `apps/web/.env.local`:
```env
NEXT_PUBLIC_CONVEX_URL=https://your-project.convex.cloud
```

### Step 6: Production Deployment

For production (optional now, needed later):
```bash
npx convex deploy --prod
```

This creates a production deployment separate from dev.

---

## 3. Supabase Setup ⏳

**Purpose**: PostgreSQL database for blog posts, users, organizations

### Step 1: Create Supabase Project

1. Visit https://supabase.com
2. Sign up or log in
3. Create new project:
   - **Name**: DFWorX
   - **Database Password**: [Generate strong password - SAVE THIS!]
   - **Region**: Choose closest to you
   - **Plan**: Free tier (upgrade later if needed)

Wait 2-3 minutes for project creation.

### Step 2: Get Connection Credentials

In Supabase Dashboard:
1. Go to Settings > API
2. Copy:
   - **Project URL**: `https://[project-id].supabase.co`
   - **anon/public key**: `eyJ...` (long JWT token)
   - **service_role key**: `eyJ...` (for server-side, keep secret!)

### Step 3: Configure Environment Variables

Add to `apps/web/.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=https://[project-id].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...your-anon-key...
SUPABASE_SERVICE_ROLE_KEY=eyJ...your-service-role-key... # Server-side only, NEVER expose
```

### Step 4: Install Supabase CLI

```bash
# macOS
brew install supabase/tap/supabase

# Or via npm
npm install -g supabase
```

### Step 5: Link Local Project to Supabase

```bash
# From workspace root
supabase link --project-ref [your-project-id]

# You'll be prompted for database password
```

### Step 6: Run Migrations

```bash
# Apply migrations in order
supabase db push infrastructure/supabase/migrations/001_shared_schema.sql
supabase db push infrastructure/supabase/migrations/002_app_web_schema.sql
supabase db push infrastructure/supabase/migrations/003_rls_policies.sql
```

Or use the Supabase dashboard:
1. Go to SQL Editor
2. Copy contents of each migration file
3. Run them in order

### Step 7: Verify Schema

In Supabase Dashboard:
1. Go to Table Editor
2. You should see:
   - **public schema**: organizations, users, notifications, audit_logs
   - **app_web schema**: profiles, posts, comments

### Step 8: Generate TypeScript Types (Optional)

```bash
supabase gen types typescript --local > packages/types/src/database-generated.ts
```

This auto-generates types from your schema (we already have manual types, but this ensures they match).

---

## 4. Coolify Setup ⏳

**Purpose**: Self-hosted deployment platform for staging/production

### Prerequisites

- A server (VPS) with Docker installed
- Domain name (optional but recommended)
- SSH access to server

### Step 1: Install Coolify on Server

On your server:
```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

Access Coolify at: `http://your-server-ip:8000`

### Step 2: Configure Coolify

1. Create account (first user is admin)
2. Add server (localhost is auto-configured)
3. Add destination (Docker Engine)

### Step 3: Create Applications in Coolify

**For Web App (Next.js)**:
1. New Resource > Application
2. Type: Docker Compose
3. Repository: https://github.com/C25O/DFWorX
4. Branch: master
5. Docker Compose file: `infrastructure/docker/docker-compose.yml`
6. Build Pack: Nixpacks (or Dockerfile)
7. Environment Variables:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=...
   NEXT_PUBLIC_SUPABASE_ANON_KEY=...
   NEXT_PUBLIC_CONVEX_URL=...
   NEXT_PUBLIC_API_URL=https://api.yourdomain.com
   ```

**For Auth Service (FastAPI)**:
1. New Resource > Application
2. Type: Docker
3. Dockerfile: `services/auth-service/Dockerfile`
4. Environment Variables:
   ```env
   DATABASE_URL=...
   SUPABASE_URL=...
   SUPABASE_KEY=...
   JWT_SECRET_KEY=...
   ```

### Step 4: Domain Configuration (Optional)

1. Add domain in Coolify
2. Enable automatic SSL (Let's Encrypt)
3. Configure DNS:
   ```
   A     dfworx.com          -> your-server-ip
   A     www.dfworx.com      -> your-server-ip
   A     api.dfworx.com      -> your-server-ip
   ```

### Step 5: Deploy

Click "Deploy" in Coolify dashboard. It will:
1. Clone repository
2. Build Docker images
3. Start containers
4. Configure reverse proxy

---

## 5. Environment Variables Summary

### Development (.env.local)

**apps/web/.env.local**:
```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://[project-id].supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
SUPABASE_SERVICE_ROLE_KEY=eyJ... # Server-side only

# ConvexDB
NEXT_PUBLIC_CONVEX_URL=https://your-project.convex.cloud

# API (if running locally)
NEXT_PUBLIC_API_URL=http://localhost:8000
```

**services/auth-service/.env**:
```env
# Database
DATABASE_URL=postgresql://postgres:[password]@db.supabase.co:5432/postgres

# Supabase
SUPABASE_URL=https://[project-id].supabase.co
SUPABASE_KEY=eyJ... # service_role key

# JWT
JWT_SECRET_KEY=[generate-random-256-bit-key]
JWT_ALGORITHM=HS256
JWT_EXPIRATION_MINUTES=60

# CORS
CORS_ORIGINS=http://localhost:3000,https://dfworx.com
```

### Production (.env.production)

Same as development but with production URLs and keys.

---

## 6. MCP Configuration

### Current MCPs

**.mcp.json** (workspace root):
```json
{
  "mcpServers": {
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"]
    }
  }
}
```

### Potential MCPs to Add

1. **Supabase MCP** (if available):
   - Database management
   - Schema queries
   - Real-time subscriptions

2. **ConvexDB MCP** (if available):
   - Schema management
   - Query testing
   - Deployment management

**Note**: Check if these MCPs exist. If not, we'll use CLI tools.

---

## 7. Verification Checklist

### ConvexDB ✓
- [ ] Project created on convex.dev
- [ ] `npx convex dev` running successfully
- [ ] Schema deployed (threads, messages, tags, etc.)
- [ ] NEXT_PUBLIC_CONVEX_URL in .env.local
- [ ] Can query Convex from browser console

### Supabase ✓
- [ ] Project created on supabase.com
- [ ] Credentials copied (URL, anon key, service role key)
- [ ] Environment variables configured
- [ ] Migrations applied (001, 002, 003)
- [ ] Tables visible in Table Editor
- [ ] Can connect from local app

### Coolify ✓
- [ ] Coolify installed on server
- [ ] GitHub repository connected
- [ ] Applications created (web, api)
- [ ] Environment variables configured
- [ ] Successful deployment
- [ ] Domain configured (if applicable)
- [ ] SSL enabled (if applicable)

### Environment Variables ✓
- [ ] apps/web/.env.local created
- [ ] services/auth-service/.env created
- [ ] All required variables present
- [ ] No secrets committed to git
- [ ] .env.example files updated

---

## 8. Testing Connections

### Test ConvexDB

```bash
# Start Convex dev
npx convex dev

# In another terminal, start Next.js
cd apps/web
pnpm dev

# Visit http://localhost:3000
# Open browser console
# Check for Convex connection logs
```

### Test Supabase

```bash
# From workspace root
cd apps/web

# Create test script: test-supabase.ts
cat > test-supabase.ts << 'EOF'
import { createClient } from './lib/supabase/client';

const supabase = createClient();

async function test() {
  const { data, error } = await supabase
    .from('organizations')
    .select('*')
    .limit(1);

  console.log('Supabase test:', { data, error });
}

test();
EOF

# Run test
npx tsx test-supabase.ts
```

### Test Auth Service

```bash
cd services/auth-service

# Run development server
uv run uvicorn src.main:app --reload

# In another terminal, test endpoint
curl http://localhost:8000/api/auth/health
```

---

## 9. Troubleshooting

### Convex Issues

**Error: "Failed to connect to Convex"**
- Check NEXT_PUBLIC_CONVEX_URL is correct
- Ensure `npx convex dev` is running
- Check browser console for CORS errors

**Schema not deploying**
- Run `npx convex dev --once` to force push
- Check schema.ts for syntax errors
- Verify you're logged in: `npx convex dev --show-token`

### Supabase Issues

**Error: "Invalid API key"**
- Double-check NEXT_PUBLIC_SUPABASE_ANON_KEY
- Ensure no extra spaces in .env.local
- Regenerate key if necessary (Supabase Dashboard > Settings > API)

**Migrations failing**
- Check SQL syntax
- Ensure migrations run in order (001, 002, 003)
- Check database logs in Supabase Dashboard

**RLS blocking queries**
- Temporarily disable RLS for testing
- Ensure you're using service_role key for server-side
- Check policy definitions in 003_rls_policies.sql

### Coolify Issues

**Build failing**
- Check Dockerfile syntax
- Ensure all dependencies in package.json/pyproject.toml
- Review build logs in Coolify dashboard

**Environment variables not working**
- Ensure no quotes around values in Coolify
- Check variable names match exactly
- Restart application after changes

---

## 10. Next Steps After Setup

Once all services are connected:

1. **Run full setup script**:
   ```bash
   ./scripts/setup.sh
   ```

2. **Start development**:
   ```bash
   ./scripts/dev.sh
   ```

3. **Verify everything works**:
   - Visit http://localhost:3000
   - Check Convex connection (browser console)
   - Test Supabase queries
   - Verify auth service running

4. **Proceed to Phase 2**: Authentication implementation

---

## 11. Security Notes

### Secrets Management

**NEVER commit to Git**:
- `.env.local`
- `.env`
- `.env.production`
- Service role keys
- JWT secrets
- Database passwords

**Safe to commit**:
- `.env.example` (with placeholder values)
- Public API keys (NEXT_PUBLIC_*)
- Configuration files

### Key Rotation

Rotate these keys regularly:
- JWT secret (at least annually)
- Supabase service_role key (if compromised)
- Database passwords (at least bi-annually)

---

## Support Resources

- **ConvexDB**: https://docs.convex.dev
- **Supabase**: https://supabase.com/docs
- **Coolify**: https://coolify.io/docs
- **DFWorX Issues**: https://github.com/C25O/DFWorX/issues

---

**Last Updated**: November 8, 2025
**Next Update**: After Phase 2 completion
