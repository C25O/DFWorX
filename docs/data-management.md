# DFWorX Data Management Strategy

> Comprehensive guide to managing shared and app-specific data across the DFWorX workspace

## Table of Contents

- [Overview](#overview)
- [Database Architecture](#database-architecture)
- [Supabase Strategy](#supabase-strategy)
- [ConvexDB Integration](#convexdb-integration)
- [Data Access Patterns](#data-access-patterns)
- [Multi-Tenancy & Isolation](#multi-tenancy--isolation)
- [Schema Management](#schema-management)
- [Security & Authorization](#security--authorization)
- [Best Practices](#best-practices)

---

## Overview

DFWorX uses a hybrid data architecture that supports both shared and app-specific data:

### Data Categories

1. **Shared Data** - Used across multiple apps (users, auth, organizations)
2. **App-Specific Data** - Isolated to individual apps (app features, settings)
3. **Real-time Data** - Live updates via ConvexDB (optional)
4. **Cached Data** - Redis for performance

### Technology Stack

- **Primary Database**: Supabase (PostgreSQL)
- **Real-time Backend**: ConvexDB (optional)
- **Caching Layer**: Redis
- **API Layer**: FastAPI services

---

## Database Architecture

### Strategy: Hybrid Schema Approach

```
Supabase (PostgreSQL)
├── public schema          # Shared data across all apps
│   ├── users              # User accounts
│   ├── organizations      # Organizations/tenants
│   ├── auth_tokens        # Authentication tokens
│   └── audit_logs         # System-wide audit logs
│
├── app_web                # Web app-specific schema
│   ├── profiles           # Web user profiles
│   ├── preferences        # Web user preferences
│   └── web_features       # Web-specific features
│
├── app_admin              # Admin dashboard schema
│   ├── admin_settings     # Admin configurations
│   ├── admin_reports      # Admin reports
│   └── admin_analytics    # Analytics data
│
└── shared_services        # Shared services schema
    ├── notifications      # Cross-app notifications
    ├── file_storage       # File metadata
    └── integrations       # Third-party integrations
```

### Benefits of This Approach

✅ **Clear Separation** - Each app owns its data
✅ **Shared Core** - Common entities in public schema
✅ **Easy Permissions** - Schema-level access control
✅ **Scalability** - Can split schemas to separate databases later
✅ **Maintainability** - Clear boundaries between apps

---

## Supabase Strategy

### 1. Schema Organization

#### Shared Schema (public)

```sql
-- infrastructure/supabase/migrations/001_shared_schema.sql

-- Enable extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Organizations table (multi-tenancy)
CREATE TABLE public.organizations (
    organization_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Users table (shared across all apps)
CREATE TABLE public.users (
    user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID REFERENCES public.organizations(organization_id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(500),
    role VARCHAR(50) DEFAULT 'user',
    metadata JSONB DEFAULT '{}',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_organization ON public.users(organization_id);
CREATE INDEX idx_users_email ON public.users(email);

-- Shared notifications
CREATE TABLE public.notifications (
    notification_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT,
    data JSONB DEFAULT '{}',
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notifications_user ON public.notifications(user_id, is_read);
```

#### App-Specific Schema

```sql
-- infrastructure/supabase/migrations/002_app_web_schema.sql

-- Create schema for web app
CREATE SCHEMA IF NOT EXISTS app_web;

-- Web-specific user profiles
CREATE TABLE app_web.profiles (
    profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
    bio TEXT,
    website VARCHAR(255),
    social_links JSONB DEFAULT '{}',
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX idx_profiles_user ON app_web.profiles(user_id);

-- Web app-specific features
CREATE TABLE app_web.posts (
    post_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES public.users(user_id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    status VARCHAR(50) DEFAULT 'draft',
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_posts_user ON app_web.posts(user_id);
CREATE INDEX idx_posts_status ON app_web.posts(status);
```

### 2. Row Level Security (RLS)

```sql
-- Enable RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_web.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_web.posts ENABLE ROW LEVEL SECURITY;

-- Users can only see users in their organization
CREATE POLICY "Users can view organization users"
    ON public.users FOR SELECT
    USING (
        organization_id IN (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid()
        )
    );

-- Users can only update their own profile
CREATE POLICY "Users can update own profile"
    ON app_web.profiles FOR UPDATE
    USING (user_id = auth.uid());

-- Users can view all posts but only edit their own
CREATE POLICY "Users can view all posts"
    ON app_web.posts FOR SELECT
    USING (status = 'published' OR user_id = auth.uid());

CREATE POLICY "Users can manage own posts"
    ON app_web.posts FOR ALL
    USING (user_id = auth.uid());
```

### 3. Database Functions

```sql
-- infrastructure/supabase/migrations/003_functions.sql

-- Function to automatically update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to all tables
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON app_web.profiles
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Function to create user profile automatically
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO app_web.profiles (user_id)
    VALUES (NEW.user_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_user_created
    AFTER INSERT ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();
```

---

## ConvexDB Integration

### When to Use ConvexDB

✅ **Real-time features** - Live chat, collaborative editing
✅ **Offline-first** - Progressive Web Apps with sync
✅ **Simple CRUD** - Rapid prototyping without backend
✅ **Reactive UI** - Auto-updating lists and dashboards

❌ **Complex queries** - Use Supabase/PostgreSQL
❌ **Large datasets** - PostgreSQL handles this better
❌ **Reporting** - SQL-based analytics in Supabase

### Hybrid Architecture Pattern

```typescript
// apps/web/lib/data-strategy.ts

/**
 * Data access strategy selector
 * - Real-time data → ConvexDB
 * - Persistent data → Supabase via FastAPI
 */

// Real-time chat messages (ConvexDB)
import { useQuery as useConvexQuery } from 'convex/react'
import { api } from '../convex/_generated/api'

export function useChatMessages(channelId: string) {
  return useConvexQuery(api.messages.list, { channelId })
}

// User profile (Supabase via API)
import { useQuery } from '@tanstack/react-query'

export function useUserProfile(userId: string) {
  return useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetch(`/api/users/${userId}`).then(r => r.json())
  })
}
```

### ConvexDB Schema Example

```typescript
// apps/web/convex/schema.ts
import { defineSchema, defineTable } from 'convex/server'
import { v } from 'convex/values'

export default defineSchema({
  // Real-time chat messages
  messages: defineTable({
    channelId: v.string(),
    userId: v.string(),
    text: v.string(),
    createdAt: v.number(),
  }).index('by_channel', ['channelId', 'createdAt']),

  // Online presence
  presence: defineTable({
    userId: v.string(),
    status: v.union(v.literal('online'), v.literal('away'), v.literal('offline')),
    lastSeen: v.number(),
  }).index('by_user', ['userId']),

  // Collaborative document state (ephemeral)
  documentSessions: defineTable({
    documentId: v.string(),
    userId: v.string(),
    cursor: v.object({ line: v.number(), column: v.number() }),
    selection: v.optional(v.any()),
  }).index('by_document', ['documentId']),
})
```

---

## Data Access Patterns

### 1. Shared Data Access (via FastAPI)

```python
# services/auth-service/src/users/repository.py
from typing import List, Optional
from uuid import UUID
from supabase import Client

class UserRepository:
    """Repository for shared user data."""

    def __init__(self, db: Client):
        self.db = db

    def get_by_id(self, user_id: UUID) -> Optional[dict]:
        """Get user from shared public.users table."""
        result = self.db.table('users').select('*').eq('user_id', str(user_id)).single().execute()
        return result.data

    def get_by_organization(self, org_id: UUID) -> List[dict]:
        """Get all users in an organization."""
        result = self.db.table('users').select('*').eq('organization_id', str(org_id)).execute()
        return result.data

    def create(self, user_data: dict) -> dict:
        """Create a new user in shared table."""
        result = self.db.table('users').insert(user_data).execute()
        return result.data[0]
```

### 2. App-Specific Data Access

```python
# services/web-service/src/profiles/repository.py
from typing import Optional
from uuid import UUID
from supabase import Client

class ProfileRepository:
    """Repository for web app-specific profiles."""

    def __init__(self, db: Client):
        self.db = db
        self.schema = 'app_web'

    def get_by_user(self, user_id: UUID) -> Optional[dict]:
        """Get profile from app_web.profiles table."""
        result = (
            self.db.table('profiles')
            .select('*')
            .eq('user_id', str(user_id))
            .execute()
        )
        return result.data[0] if result.data else None

    def update(self, user_id: UUID, data: dict) -> dict:
        """Update user profile in app-specific schema."""
        result = (
            self.db.table('profiles')
            .update(data)
            .eq('user_id', str(user_id))
            .execute()
        )
        return result.data[0]
```

### 3. Cross-Schema Queries

```python
# services/web-service/src/posts/service.py
from typing import List
from uuid import UUID
from supabase import Client

class PostService:
    """Service for posts with user data."""

    def __init__(self, db: Client):
        self.db = db

    def get_posts_with_users(self, limit: int = 10) -> List[dict]:
        """Get posts with user information (cross-schema join)."""
        # Using Supabase's query builder
        result = (
            self.db.rpc(
                'get_posts_with_users',
                {'post_limit': limit}
            ).execute()
        )
        return result.data

# In migration: Create the RPC function
"""
CREATE OR REPLACE FUNCTION get_posts_with_users(post_limit INT)
RETURNS TABLE (
    post_id UUID,
    title VARCHAR,
    content TEXT,
    user_id UUID,
    user_name VARCHAR,
    user_email VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.post_id,
        p.title,
        p.content,
        u.user_id,
        u.name,
        u.email
    FROM app_web.posts p
    INNER JOIN public.users u ON p.user_id = u.user_id
    WHERE p.status = 'published'
    ORDER BY p.created_at DESC
    LIMIT post_limit;
END;
$$ LANGUAGE plpgsql;
"""
```

### 4. Frontend Data Access

```typescript
// apps/web/lib/api/users.ts
import { User } from '@dfworx/types'

const API_URL = process.env.NEXT_PUBLIC_API_URL

export async function getUser(userId: string): Promise<User> {
  const res = await fetch(`${API_URL}/api/users/${userId}`, {
    headers: {
      'Authorization': `Bearer ${getToken()}`,
    },
  })
  if (!res.ok) throw new Error('Failed to fetch user')
  return res.json()
}

export async function getUserProfile(userId: string) {
  const res = await fetch(`${API_URL}/api/web/profiles/${userId}`, {
    headers: {
      'Authorization': `Bearer ${getToken()}`,
    },
  })
  if (!res.ok) throw new Error('Failed to fetch profile')
  return res.json()
}

// React Query hooks
import { useQuery } from '@tanstack/react-query'

export function useUser(userId: string) {
  return useQuery({
    queryKey: ['user', userId],
    queryFn: () => getUser(userId),
  })
}

export function useUserProfile(userId: string) {
  return useQuery({
    queryKey: ['profile', userId],
    queryFn: () => getUserProfile(userId),
  })
}
```

---

## Multi-Tenancy & Isolation

### Organization-Based Multi-Tenancy

```sql
-- Every table with tenant data includes organization_id
CREATE TABLE app_web.projects (
    project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID REFERENCES public.organizations(organization_id),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- RLS ensures data isolation
CREATE POLICY "Users can only see their org's projects"
    ON app_web.projects FOR SELECT
    USING (
        organization_id IN (
            SELECT organization_id FROM public.users
            WHERE user_id = auth.uid()
        )
    );
```

### Service-Level Isolation

```python
# packages/python-common/src/middleware/tenant.py
from fastapi import Request, HTTPException
from typing import Optional
from uuid import UUID

async def get_current_organization(request: Request) -> UUID:
    """
    Extract organization from JWT token.
    Ensures all queries are scoped to user's organization.
    """
    user = request.state.user
    if not user or not user.get('organization_id'):
        raise HTTPException(status_code=403, detail="No organization context")
    return UUID(user['organization_id'])

# Usage in routes
@router.get("/projects")
async def list_projects(
    org_id: UUID = Depends(get_current_organization),
    db: Client = Depends(get_db)
):
    """List projects scoped to user's organization."""
    result = db.table('projects').select('*').eq('organization_id', str(org_id)).execute()
    return result.data
```

---

## Schema Management

### Migration Strategy

```bash
infrastructure/supabase/migrations/
├── 001_shared_schema.sql          # Shared tables (public schema)
├── 002_app_web_schema.sql         # Web app schema
├── 003_app_admin_schema.sql       # Admin app schema
├── 004_shared_services_schema.sql # Shared services
├── 005_rls_policies.sql           # Row Level Security
├── 006_functions.sql              # Database functions
└── 007_indexes.sql                # Performance indexes
```

### Migration Workflow

```bash
# Create new migration
supabase migration new add_feature_table

# Apply migrations locally
supabase db push

# Generate TypeScript types
supabase gen types typescript --local > packages/types/src/database.ts

# Deploy to production
supabase db push --db-url $PRODUCTION_DATABASE_URL
```

### Shared Types Generation

```typescript
// packages/types/src/database.ts (auto-generated)
export type User = {
  user_id: string
  organization_id: string
  email: string
  name: string
  role: string
  created_at: string
  updated_at: string
}

export type WebProfile = {
  profile_id: string
  user_id: string
  bio: string | null
  website: string | null
  social_links: Record<string, string>
  created_at: string
}

// Export for use in all apps
export type { User, WebProfile }
```

---

## Security & Authorization

### 1. API-Level Authorization

```python
# packages/python-common/src/auth/permissions.py
from enum import Enum
from typing import List
from uuid import UUID

class Permission(str, Enum):
    READ_USERS = "read:users"
    WRITE_USERS = "write:users"
    READ_POSTS = "read:posts"
    WRITE_POSTS = "write:posts"
    ADMIN = "admin:all"

class Role(str, Enum):
    USER = "user"
    MODERATOR = "moderator"
    ADMIN = "admin"

ROLE_PERMISSIONS = {
    Role.USER: [Permission.READ_USERS, Permission.READ_POSTS, Permission.WRITE_POSTS],
    Role.MODERATOR: [Permission.READ_USERS, Permission.READ_POSTS, Permission.WRITE_POSTS],
    Role.ADMIN: [Permission.ADMIN],
}

def has_permission(user_role: str, required_permission: Permission) -> bool:
    """Check if user role has required permission."""
    if user_role == Role.ADMIN:
        return True  # Admins have all permissions
    role_perms = ROLE_PERMISSIONS.get(Role(user_role), [])
    return required_permission in role_perms
```

### 2. Schema-Level Permissions

```sql
-- Grant permissions to authenticated users
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA app_web TO authenticated;

-- Limit what authenticated users can do
GRANT SELECT, INSERT, UPDATE ON public.users TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON app_web.profiles TO authenticated;
GRANT SELECT ON app_web.posts TO authenticated;

-- Service role has full access
GRANT ALL ON ALL TABLES IN SCHEMA public TO service_role;
GRANT ALL ON ALL TABLES IN SCHEMA app_web TO service_role;
```

---

## Best Practices

### 1. Data Organization

✅ **DO**: Keep shared data in public schema
✅ **DO**: Use app-specific schemas for isolated features
✅ **DO**: Use JSONB for flexible metadata
✅ **DO**: Add indexes on foreign keys and query columns
✅ **DO**: Use UUIDs for primary keys

❌ **DON'T**: Mix app-specific logic in shared tables
❌ **DON'T**: Store large files in database (use Supabase Storage)
❌ **DON'T**: Skip RLS policies
❌ **DON'T**: Use SELECT * in production queries

### 2. Performance

```sql
-- Add indexes strategically
CREATE INDEX idx_posts_user_status ON app_web.posts(user_id, status);
CREATE INDEX idx_notifications_user_unread ON public.notifications(user_id, is_read) WHERE is_read = FALSE;

-- Use partial indexes for common queries
CREATE INDEX idx_active_users ON public.users(email) WHERE is_active = TRUE;

-- Use covering indexes for frequent queries
CREATE INDEX idx_posts_list ON app_web.posts(user_id, created_at DESC) INCLUDE (title, status);
```

### 3. Data Validation

```python
# Use Pydantic for validation at API level
from pydantic import BaseModel, Field, EmailStr
from uuid import UUID

class UserCreate(BaseModel):
    """Shared user creation model."""
    organization_id: UUID
    email: EmailStr
    name: str = Field(..., min_length=1, max_length=255)
    role: str = Field(default="user", pattern="^(user|moderator|admin)$")

class WebProfileUpdate(BaseModel):
    """App-specific profile update."""
    bio: str | None = Field(None, max_length=1000)
    website: str | None = Field(None, max_length=255)
    social_links: dict[str, str] = {}
```

### 4. Caching Strategy

```python
# packages/python-common/src/cache/redis.py
from typing import Optional
import json
import redis

class CacheManager:
    def __init__(self, redis_client: redis.Redis):
        self.redis = redis_client

    def get_user(self, user_id: str) -> Optional[dict]:
        """Get cached user data."""
        cached = self.redis.get(f"user:{user_id}")
        return json.loads(cached) if cached else None

    def set_user(self, user_id: str, user_data: dict, ttl: int = 3600):
        """Cache user data for 1 hour."""
        self.redis.setex(f"user:{user_id}", ttl, json.dumps(user_data))

    def invalidate_user(self, user_id: str):
        """Remove user from cache."""
        self.redis.delete(f"user:{user_id}")
```

---

## Decision Matrix

| Requirement | Use Supabase | Use ConvexDB | Use Both |
|-------------|--------------|--------------|----------|
| User authentication | ✅ | ❌ | - |
| Complex SQL queries | ✅ | ❌ | - |
| Real-time chat | ❌ | ✅ | - |
| User profiles | ✅ | ❌ | - |
| Collaborative editing | ❌ | ✅ | - |
| Analytics/Reporting | ✅ | ❌ | - |
| Offline-first app | ❌ | ✅ | - |
| Multi-tenancy | ✅ | ⚠️ | - |
| Large datasets (>100k rows) | ✅ | ❌ | - |
| Live presence | ❌ | ✅ | - |

---

## Summary

### Data Strategy Overview

1. **Shared Data** → Supabase `public` schema
2. **App-Specific Data** → Supabase app-specific schemas
3. **Real-time Features** → ConvexDB (optional)
4. **API Layer** → FastAPI services
5. **Caching** → Redis for hot data
6. **Multi-Tenancy** → Organization-based isolation

### File Locations

- **Migrations**: `infrastructure/supabase/migrations/`
- **Shared Types**: `packages/types/src/database.ts`
- **Repositories**: `services/[service]/src/[feature]/repository.py`
- **API Clients**: `apps/[app]/lib/api/`

For implementation examples, see:
- [Supabase Migrations](../infrastructure/supabase/migrations/)
- [Auth Service](../services/auth-service/)
- [Shared Types Package](../packages/types/)

---

**Last Updated**: 2025-11-07
