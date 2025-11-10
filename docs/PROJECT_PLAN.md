# DFWorX Project Plan

**Project Name**: DFWorX - Developer Focused Workspace
**First Application**: Blog + Real-time Chat for Knowledge Management
**Started**: November 8, 2025
**Status**: Phase 1 Complete ✅

---

## Project Overview

DFWorX is a central monorepo workspace designed to house all future applications with shared infrastructure, types, and utilities. The first application is a markdown-based blog with integrated real-time chat for documenting and organizing knowledge about all monorepo applications.

### Core Technologies

**Frontend**:
- Next.js 14 (App Router)
- React 18
- TypeScript 5.x
- Tailwind CSS
- shadcn/ui components

**Backend**:
- FastAPI (Python)
- Supabase (PostgreSQL)
- ConvexDB (Real-time chat)

**Monorepo**:
- PNPM Workspaces
- Turborepo
- UV (Python package manager)

**Deployment**:
- Docker
- Coolify (self-hosted)

---

## Implementation Phases

### ✅ Phase 1: Foundation Setup (COMPLETED)

**Objective**: Establish core infrastructure, types, and utilities

**Deliverables**:
1. ✅ ConvexDB setup and schema for chat system
2. ✅ TypeScript types for database, blog, and chat
3. ✅ shadcn/ui component library
4. ✅ Shared utilities (Supabase clients, Convex provider, markdown processor, API client)
5. ✅ Environment configuration
6. ✅ Documentation

**Key Features Implemented**:
- Multi-tenant chat system with threading
- Tag categorization (app, topic, decision, status, priority)
- File attachment support in schema
- Emoji reactions
- Complete type safety across frontend and backend
- Markdown processing utilities
- Type-safe API client

---

### 🔄 Phase 2: Authentication (IN PROGRESS)

**Objective**: Implement email-based authentication with Supabase

**Deliverables**:
1. ⏳ Auth backend configuration
2. ⏳ Auth context and React hooks
3. ⏳ Login/Signup UI components
4. ⏳ Protected routes middleware
5. ⏳ Session management
6. ⏳ User profile setup

**Timeline**: 1-2 days

---

### 📋 Phase 3: Blog Backend (PLANNED)

**Objective**: Create blog API with CRUD operations

**Deliverables**:
1. Blog API routes (GET, POST, PUT, DELETE)
2. Post search endpoint
3. Slug generation and validation
4. Server-side markdown processing
5. Post metadata handling
6. Database query optimization

**Timeline**: 2-3 days

---

### 📋 Phase 4: Blog Frontend (PLANNED)

**Objective**: Build user-facing blog interface

**Deliverables**:
1. Blog post listing with pagination
2. Blog post detail view with markdown rendering
3. Markdown editor for creation/editing
4. Search functionality
5. Draft/published status management
6. Syntax highlighting for code blocks

**Timeline**: 3-4 days

---

### 📋 Phase 5: Chat Backend (PLANNED)

**Objective**: Implement Convex mutations and queries

**Deliverables**:
1. Message CRUD operations
2. Thread management
3. Tag operations
4. File upload integration
5. Real-time subscriptions
6. Search functionality

**Timeline**: 2-3 days

---

### 📋 Phase 6: Chat Frontend (PLANNED)

**Objective**: Build real-time chat interface

**Deliverables**:
1. Global chat sidebar/panel
2. Per-post chat threads
3. Message threading UI
4. Tag selector and filtering
5. File upload component
6. Emoji reactions
7. Real-time updates

**Timeline**: 4-5 days

---

### 📋 Phase 7: Advanced Features (PLANNED)

**Objective**: Integration and advanced functionality

**Deliverables**:
1. Chat-to-blog export
2. Unified search (blog + chat)
3. "Discuss in Chat" button on posts
4. "Create Post from Thread" in chat
5. Activity feed
6. Thread linking

**Timeline**: 3-4 days

---

### 📋 Phase 8: Polish & Testing (PLANNED)

**Objective**: Production readiness

**Deliverables**:
1. Layout and navigation
2. Loading states and skeletons
3. Error boundaries
4. Toast notifications
5. Unit and E2E tests
6. Performance optimization
7. Final documentation

**Timeline**: 3-4 days

---

## Technical Architecture

### Data Management Strategy

**Hybrid Schema Approach**:
- **Supabase** (`public.*` schema): Shared data across all apps
  - Organizations (multi-tenancy)
  - Users (authentication)
  - Notifications (cross-app)
  - Audit logs (system-wide)

- **Supabase** (`app_web.*` schema): Web app-specific data
  - Profiles (extended user data)
  - Posts (blog content)
  - Comments (post discussions)

- **ConvexDB**: Real-time chat data
  - Threads (global + per-post)
  - Messages (with threading)
  - Tags (categorization)
  - Attachments (file storage)
  - Reactions (emoji)

### Security Layers

1. **JWT Authentication**: Supabase Auth tokens
2. **Organization Context**: Multi-tenancy isolation
3. **Row Level Security (RLS)**: Database-level policies
4. **Schema Permissions**: Granular access control

### Key Design Decisions

1. **ConvexDB for Chat**: Chosen for superior real-time performance and developer experience
2. **Markdown-based Blog**: Developer-friendly, version-controllable content
3. **Email-only Auth (MVP)**: Simplified authentication flow for initial release
4. **Tagging System**: 5 categories for comprehensive organization
5. **Dual Chat Modes**: Global workspace chat + per-post threads
6. **PNPM + Turborepo**: Optimal for 15-20 projects scale with Python integration

---

## File Structure

```
DFWorX/
├── apps/
│   └── web/                    # Next.js blog application
│       ├── app/                # Next.js App Router
│       ├── components/         # React components
│       ├── lib/                # Utilities and clients
│       │   ├── supabase/       # Supabase clients
│       │   ├── convex/         # Convex provider
│       │   ├── markdown/       # Markdown processor
│       │   └── api/            # API client
│       └── package.json
│
├── services/
│   └── auth-service/           # FastAPI authentication service
│       ├── src/
│       │   ├── auth/           # Auth routes and logic
│       │   ├── database/       # DB connection
│       │   └── config.py       # Settings
│       └── pyproject.toml
│
├── packages/
│   ├── ui/                     # Shared UI components (shadcn/ui)
│   ├── types/                  # TypeScript types
│   │   ├── database.ts         # Supabase types
│   │   ├── blog.ts             # Blog types
│   │   └── chat.ts             # Chat types
│   ├── config/                 # Shared configs
│   └── python-common/          # Shared Python utilities
│
├── convex/
│   ├── schema.ts               # ConvexDB schema
│   └── tsconfig.json
│
├── infrastructure/
│   ├── docker/                 # Docker configs
│   ├── supabase/               # Database migrations
│   │   └── migrations/
│   │       ├── 001_shared_schema.sql
│   │       ├── 002_app_web_schema.sql
│   │       └── 003_rls_policies.sql
│   └── coolify/                # Deployment configs
│
├── docs/                       # Documentation
│   ├── workspace.md            # Workspace guide
│   ├── data-management.md      # Data architecture
│   ├── architecture.md         # System architecture
│   ├── blog-app-guide.md       # Blog user guide
│   └── chat-usage.md           # Chat features guide
│
├── scripts/                    # Utility scripts
├── .github/workflows/          # CI/CD
└── package.json                # Root package
```

---

## Success Metrics

### Phase 1 (Foundation)
- ✅ All types generated and exported
- ✅ UI component library functional
- ✅ Database schema defined
- ✅ Utilities created and tested

### MVP Launch Goals
- [ ] User authentication working
- [ ] Blog CRUD operations complete
- [ ] Real-time chat functional
- [ ] Search implemented
- [ ] Basic documentation complete

### Long-term Goals
- [ ] Multiple apps in monorepo
- [ ] Shared component library mature
- [ ] CI/CD pipeline optimized
- [ ] Comprehensive knowledge base in blog/chat

---

## Resources

### Documentation
- [Workspace Guide](docs/workspace.md)
- [Data Management](docs/data-management.md)
- [Architecture](docs/architecture.md)
- [Quick Reference](docs/QUICK-REFERENCE.md)
- [Tech Stack](docs/main-tools.md)

### External Links
- [Next.js Documentation](https://nextjs.org/docs)
- [ConvexDB Documentation](https://docs.convex.dev)
- [Supabase Documentation](https://supabase.com/docs)
- [shadcn/ui Components](https://ui.shadcn.com)
- [Turborepo Documentation](https://turbo.build/repo/docs)

---

## Notes

- This is a living document that will be updated as the project evolves
- Each phase builds upon the previous phase's foundation
- Focus remains on KISS principle and YAGNI
- All decisions documented in chat for future reference
- Code follows CLAUDE.md guidelines (PEP8, max 100 char lines, type hints, etc.)

---

**Last Updated**: November 8, 2025
**Current Phase**: Phase 1 Complete, Phase 2 Starting
**Next Milestone**: Authentication Implementation
