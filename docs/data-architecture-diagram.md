# DFWorX Data Architecture Diagram

## Complete Data Flow Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          FRONTEND LAYER                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐             │
│   │   Web App    │    │    Admin     │    │   Mobile     │             │
│   │  (Next.js)   │    │  Dashboard   │    │     App      │             │
│   └───────┬──────┘    └───────┬──────┘    └───────┬──────┘             │
│           │                   │                    │                     │
│           │  React Query      │  React Query       │  React Query       │
│           │  + Convex         │  + API Calls       │  + Convex          │
│           │                   │                    │                     │
└───────────┼───────────────────┼────────────────────┼─────────────────────┘
            │                   │                    │
            │                   │                    │
            └───────────────────┼────────────────────┘
                                │
    ┌───────────────────────────┼───────────────────────────┐
    │                           │                           │
    │         Real-time         │       Traditional         │
    │         (Convex)          │       (FastAPI)           │
    │                           │                           │
┌───▼────────────┐      ┌───────▼──────────┐      ┌────────▼──────┐
│                │      │                  │      │                │
│  ConvexDB      │      │  FastAPI Services│      │     Redis      │
│                │      │                  │      │   (Cache)      │
│  - Chat        │      │  - Auth Service  │      │                │
│  - Presence    │      │  - Web Service   │      │  - Sessions    │
│  - Collab      │      │  - Admin Service │      │  - Hot Data    │
│                │      │                  │      │                │
└────────────────┘      └──────────┬───────┘      └────────────────┘
                                   │
                                   │
                    ┌──────────────▼──────────────┐
                    │                             │
                    │        Supabase             │
                    │      (PostgreSQL)           │
                    │                             │
                    └──────────────┬──────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        │                          │                          │
┌───────▼────────┐     ┌──────────▼────────┐     ┌──────────▼────────┐
│  public schema │     │ app_web schema    │     │ app_admin schema  │
│  (SHARED)      │     │ (WEB APP)         │     │ (ADMIN APP)       │
├────────────────┤     ├───────────────────┤     ├───────────────────┤
│ organizations  │     │ profiles          │     │ admin_settings    │
│ users          │     │ posts             │     │ reports           │
│ notifications  │     │ comments          │     │ analytics         │
│ audit_logs     │     │ categories        │     │ system_logs       │
└────────────────┘     └───────────────────┘     └───────────────────┘
```

## Data Flow Patterns

### 1. Shared Data Access

```
Web App → FastAPI Auth Service → Supabase public.users → User Data
  ↓
Cache in Redis (1 hour TTL)
  ↓
Return to Web App
```

### 2. App-Specific Data Access

```
Web App → FastAPI Web Service → Supabase app_web.posts → Post Data
  ↓
Apply RLS (organization isolation)
  ↓
Join with public.users (shared data)
  ↓
Return enriched data
```

### 3. Real-time Data Flow

```
Web App → ConvexDB → Live Chat Messages
  ↓
Subscribe to changes
  ↓
Auto-update UI on new messages
```

## Database Schema Relationships

```
public.organizations
    ↓ (one-to-many)
public.users
    ↓ (one-to-one)
app_web.profiles
    ↓ (one-to-many)
app_web.posts
    ↓ (one-to-many)
app_web.comments
```

## Multi-Tenancy Isolation

```
Organization A                Organization B
    ↓                            ↓
  Users A1, A2, A3           Users B1, B2, B3
    ↓                            ↓
Posts by A's users         Posts by B's users
    ↓                            ↓
   [ISOLATED]                 [ISOLATED]
```

**RLS ensures users in Org A cannot see data from Org B**

## Data Access Decision Tree

```
Need to access data?
    │
    ├─ Is it shared across apps? (users, orgs)
    │   └─ YES → Use public schema
    │
    ├─ Is it app-specific? (profiles, posts)
    │   └─ YES → Use app_* schema
    │
    ├─ Is it real-time? (chat, presence)
    │   └─ YES → Use ConvexDB
    │
    ├─ Is it frequently accessed? (hot data)
    │   └─ YES → Cache in Redis
    │
    └─ Complex analytics query?
        └─ YES → Use Supabase with proper indexes
```

## Security Layers

```
┌─────────────────────────────────────────┐
│  Layer 1: JWT Authentication            │
│  - FastAPI verifies token               │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│  Layer 2: Organization Context          │
│  - Extract org_id from token            │
│  - Apply to all queries                 │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│  Layer 3: Row Level Security (RLS)      │
│  - Database enforces isolation          │
│  - Users can't bypass via SQL           │
└────────────┬────────────────────────────┘
             │
┌────────────▼────────────────────────────┐
│  Layer 4: Schema-Level Permissions      │
│  - Authenticated role has limited access│
│  - Service role for backend only        │
└─────────────────────────────────────────┘
```

## Example: Fetching Posts with User Data

### Step-by-Step Flow

```
1. User requests posts
   ↓
2. Frontend: GET /api/web/posts
   ↓
3. FastAPI Web Service
   ↓
4. Extract org_id from JWT
   ↓
5. Query Supabase:
   SELECT p.*, u.name, u.avatar_url
   FROM app_web.posts p
   JOIN public.users u ON p.user_id = u.user_id
   WHERE p.organization_id = {org_id}
   AND (p.status = 'published' OR p.user_id = {current_user_id})
   ↓
6. RLS enforces organization isolation
   ↓
7. Return data to frontend
   ↓
8. Cache in Redis for 5 minutes
```

## Migration Strategy

```
infrastructure/supabase/migrations/
│
├── 001_shared_schema.sql         ← Shared tables (public)
├── 002_app_web_schema.sql        ← Web app tables
├── 003_rls_policies.sql          ← Security policies
├── 004_app_admin_schema.sql      ← Admin tables (future)
├── 005_indexes.sql               ← Performance indexes
└── 006_functions.sql             ← Helper functions
```

## When to Use Each Database

| Use Case | Supabase | ConvexDB | Redis |
|----------|----------|----------|-------|
| User accounts | ✅ | ❌ | Cache only |
| User profiles | ✅ | ❌ | Cache only |
| Posts/Articles | ✅ | ❌ | Cache only |
| Live chat | ❌ | ✅ | ❌ |
| Real-time presence | ❌ | ✅ | ✅ |
| Analytics | ✅ | ❌ | ❌ |
| Session data | ❌ | ❌ | ✅ |
| File metadata | ✅ | ❌ | ❌ |
| Audit logs | ✅ | ❌ | ❌ |
| Notifications | ✅ | ✅ | Cache only |

## Schema Naming Convention

```
public.*              → Shared across ALL apps
app_{name}.*          → Specific to one app
shared_services.*     → Shared services (optional)
```

**Examples:**
- `public.users` - Used by all apps
- `app_web.posts` - Only web app
- `app_admin.reports` - Only admin app
- `shared_services.notifications` - Cross-app feature

## Benefits Summary

✅ **Clear Boundaries** - Each app owns its schema
✅ **Shared Core** - Common entities in public
✅ **Type Safety** - Generate types from schema
✅ **Easy Testing** - Can seed schemas independently
✅ **Scalability** - Can split to separate DBs later
✅ **Security** - Schema + RLS + API auth = defense in depth

---

For implementation details, see:
- [Data Management Strategy](data-management.md)
- [Supabase Migrations](../infrastructure/supabase/migrations/)
- [Architecture Guide](architecture.md)
