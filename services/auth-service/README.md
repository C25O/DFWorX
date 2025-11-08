# Auth Service

FastAPI-based authentication and authorization service for DFWorX.

## Features

- User registration and authentication
- JWT token-based authentication
- Password hashing with bcrypt
- Supabase integration
- Type-safe API with Pydantic

## Getting Started

### Prerequisites

- Python 3.12+
- UV package manager

### Installation

1. Create virtual environment and install dependencies:
   ```bash
   uv venv
   uv sync
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

### Development

1. Run the development server:
   ```bash
   uv run uvicorn src.main:app --reload --port 8000
   ```

2. Access the API documentation:
   - Swagger UI: http://localhost:8000/docs
   - ReDoc: http://localhost:8000/redoc

### Testing

Run tests with pytest:
```bash
uv run pytest
```

Run tests with coverage:
```bash
uv run pytest --cov=src --cov-report=html
```

### Code Quality

Format code with Ruff:
```bash
uv run ruff format .
```

Lint code:
```bash
uv run ruff check .
```

Type check with mypy:
```bash
uv run mypy src/
```

## Project Structure

```
auth-service/
├── src/
│   ├── auth/              # Authentication module
│   │   ├── router.py      # API endpoints
│   │   ├── service.py     # Business logic
│   │   ├── models.py      # Data models
│   │   └── tests/         # Unit tests
│   ├── database/          # Database connection
│   ├── config.py          # Configuration
│   └── main.py            # FastAPI app
├── pyproject.toml         # Project dependencies
├── Dockerfile             # Docker configuration
└── README.md
```

## API Endpoints

### Authentication

- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user

### Health

- `GET /health` - Health check endpoint
- `GET /` - Service information

## Environment Variables

See [.env.example](.env.example) for all available configuration options.

## Docker

Build and run with Docker:

```bash
docker build -t dfworx-auth-service .
docker run -p 8000:8000 --env-file .env dfworx-auth-service
```
