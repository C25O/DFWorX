# DFWorX Architecture

## System Overview

DFWorX follows a modern monorepo architecture with clear separation between frontend applications, backend services, and shared packages.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Layer                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Web App    │  │    Admin     │  │   Mobile     │      │
│  │  (Next.js)   │  │  Dashboard   │  │     App      │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────┬────────────────┬────────────────┬──────────────┘
             │                │                │
             └────────────────┼────────────────┘
                              │
                    ┌─────────▼──────────┐
                    │    API Gateway     │
                    │   (Load Balancer)  │
                    └─────────┬──────────┘
                              │
             ┌────────────────┼────────────────┐
             │                │                │
    ┌────────▼────────┐  ┌───▼────────┐  ┌───▼────────┐
    │  Auth Service   │  │   API      │  │   Other    │
    │   (FastAPI)     │  │  Service   │  │  Services  │
    └────────┬────────┘  └───┬────────┘  └───┬────────┘
             │               │               │
             └───────────────┼───────────────┘
                             │
                    ┌────────▼─────────┐
                    │    Supabase      │
                    │   (PostgreSQL)   │
                    └──────────────────┘
```

## Core Components

### 1. Frontend Layer

#### Next.js Applications (`apps/`)
- **Server-Side Rendering (SSR)**: For SEO and performance
- **Static Site Generation (SSG)**: For marketing pages
- **Client Components**: For interactive features
- **API Routes**: For serverless functions

**Key Features**:
- React 18 with concurrent features
- App Router for nested layouts
- Server components by default
- Tailwind CSS for styling
- Shadcn UI for components

### 2. Backend Layer

#### FastAPI Services (`services/`)
- **RESTful APIs**: Standard HTTP endpoints
- **WebSocket Support**: For real-time features
- **OpenAPI Documentation**: Auto-generated API docs
- **Pydantic Validation**: Type-safe data validation

**Key Features**:
- Async/await for concurrent operations
- Dependency injection
- JWT authentication
- CORS configuration
- Health check endpoints

### 3. Data Layer

#### Supabase (PostgreSQL)
- **Relational Database**: Structured data storage
- **Row Level Security (RLS)**: Fine-grained access control
- **Real-time Subscriptions**: Live data updates
- **Authentication**: Built-in auth system

**Key Features**:
- ACID transactions
- Triggers and functions
- Automatic migrations
- Point-in-time recovery

#### ConvexDB (Optional)
- **Real-time Backend**: Reactive data synchronization
- **Serverless Functions**: Backend logic in TypeScript
- **Automatic Caching**: Optimized queries
- **Offline Support**: Local-first architecture

### 4. Shared Layer

#### Packages (`packages/`)
- **UI Package**: Reusable React components
- **Types Package**: Shared TypeScript types
- **Config Package**: Common configurations
- **Python Common**: Shared Python utilities

## Design Patterns

### 1. Vertical Slice Architecture

Each feature is organized as a self-contained slice:

```
feature/
├── router.py          # API endpoints
├── service.py         # Business logic
├── models.py          # Data models
├── validators.py      # Input validation
└── tests/             # Feature tests
```

**Benefits**:
- High cohesion
- Low coupling
- Easy to understand
- Simple to test

### 2. Repository Pattern

Abstract data access logic:

```python
class BaseRepository:
    def get(self, id: UUID) -> Model
    def list(self, filters: dict) -> List[Model]
    def create(self, data: dict) -> Model
    def update(self, id: UUID, data: dict) -> Model
    def delete(self, id: UUID) -> None
```

### 3. Service Layer Pattern

Business logic separated from controllers:

```python
# router.py - HTTP layer
@router.post("/users")
async def create_user(data: UserCreate):
    return await user_service.create_user(data)

# service.py - Business logic
async def create_user(data: UserCreate):
    # Validation
    # Business rules
    # Data persistence
    return user
```

### 4. Dependency Injection

Use FastAPI's DI system:

```python
def get_db():
    db = Database()
    try:
        yield db
    finally:
        db.close()

@router.get("/users")
async def get_users(db: Database = Depends(get_db)):
    return db.query(User).all()
```

## Data Flow

### Request Flow

1. **Client Request** → Next.js frontend
2. **API Call** → FastAPI backend
3. **Validation** → Pydantic models
4. **Business Logic** → Service layer
5. **Data Access** → Repository layer
6. **Database** → Supabase
7. **Response** → JSON serialization
8. **Client Update** → React state management

### Authentication Flow

1. User submits credentials
2. FastAPI validates credentials
3. Supabase Auth verifies user
4. JWT token generated
5. Token stored in httpOnly cookie
6. Subsequent requests include token
7. Backend verifies token on each request

## Scalability Strategy

### Horizontal Scaling

- **Frontend**: Deploy multiple Next.js instances behind load balancer
- **Backend**: Run multiple FastAPI workers
- **Database**: Use read replicas for read-heavy workloads

### Caching Strategy

- **Client-side**: React Query for API responses
- **Server-side**: Redis for session data and hot data
- **CDN**: Static assets cached at edge

### Performance Optimization

- **Code Splitting**: Lazy load components
- **Image Optimization**: Next.js Image component
- **Database Indexing**: Strategic indexes on queries
- **Connection Pooling**: Reuse database connections

## Security Architecture

### Defense in Depth

1. **Network Layer**: HTTPS only, CORS configuration
2. **Application Layer**: Input validation, SQL injection prevention
3. **Authentication**: JWT tokens, secure password hashing
4. **Authorization**: Role-based access control (RBAC)
5. **Data Layer**: Row-level security, encryption at rest

### Security Best Practices

- Never store secrets in code
- Use environment variables
- Implement rate limiting
- Log security events
- Regular security audits
- Keep dependencies updated

## Monitoring & Observability

### Logging

- **Structured Logging**: JSON format for easy parsing
- **Log Levels**: DEBUG, INFO, WARNING, ERROR, CRITICAL
- **Correlation IDs**: Track requests across services

### Metrics

- **Application Metrics**: Response times, error rates
- **Business Metrics**: User signups, conversions
- **Infrastructure Metrics**: CPU, memory, disk usage

### Tracing

- **Distributed Tracing**: Track requests across services
- **Performance Profiling**: Identify bottlenecks
- **Error Tracking**: Capture and alert on errors

## Deployment Architecture

### Development

```
Developer Machine
├── Next.js (localhost:3000)
├── FastAPI (localhost:8000)
└── PostgreSQL (Docker)
```

### Production (Coolify)

```
Coolify Server
├── Nginx (Reverse Proxy)
│   ├── app.domain.com → Next.js Container
│   └── api.domain.com → FastAPI Container
├── PostgreSQL (Managed Supabase)
└── Redis (Container)
```

## Future Enhancements

1. **Microservices**: Split into specialized services
2. **Event-Driven**: Add message queue (RabbitMQ/Redis)
3. **GraphQL**: Alternative to REST APIs
4. **Kubernetes**: Container orchestration
5. **Service Mesh**: Advanced networking (Istio)

## Conclusion

This architecture provides:
- **Scalability**: Horizontal scaling capability
- **Maintainability**: Clear separation of concerns
- **Developer Experience**: Fast feedback loops
- **Type Safety**: End-to-end type checking
- **Performance**: Optimized for speed

For implementation details, see individual service documentation.
