#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Starting DFWorX development environment...${NC}"
echo ""

# Check if .env files exist
if [ ! -f "apps/web/.env.local" ] || [ ! -f "services/auth-service/.env" ]; then
    echo -e "${RED}❌ Environment files not found!${NC}"
    echo "Please run ./scripts/setup.sh first"
    exit 1
fi

# Function to cleanup background processes on exit
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 Stopping all services...${NC}"
    pkill -P $$ || true
    exit 0
}

trap cleanup SIGINT SIGTERM EXIT

# Start PostgreSQL and Redis with Docker
echo -e "${BLUE}🐘 Starting PostgreSQL and Redis...${NC}"
cd infrastructure/docker
docker-compose up -d postgres redis
cd - > /dev/null

# Wait for PostgreSQL to be ready
echo -e "${BLUE}⏳ Waiting for PostgreSQL to be ready...${NC}"
until docker exec dfworx-postgres pg_isready -U dfworx > /dev/null 2>&1; do
    sleep 1
done
echo -e "${GREEN}✓ PostgreSQL is ready${NC}"

# Start Next.js web app
echo -e "${BLUE}🌐 Starting Next.js web app on http://localhost:3000${NC}"
cd apps/web
pnpm dev > /dev/null 2>&1 &
WEB_PID=$!
cd - > /dev/null

# Start FastAPI auth service
echo -e "${BLUE}🔐 Starting FastAPI auth service on http://localhost:8000${NC}"
cd services/auth-service
uv run uvicorn src.main:app --reload --port 8000 > /dev/null 2>&1 &
API_PID=$!
cd - > /dev/null

echo ""
echo -e "${GREEN}✨ All services started!${NC}"
echo ""
echo "Services:"
echo -e "  ${BLUE}Web:${NC}      http://localhost:3000"
echo -e "  ${BLUE}API:${NC}      http://localhost:8000"
echo -e "  ${BLUE}API Docs:${NC} http://localhost:8000/docs"
echo -e "  ${BLUE}Postgres:${NC} localhost:5432"
echo -e "  ${BLUE}Redis:${NC}    localhost:6379"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop all services${NC}"
echo ""

# Wait for all background processes
wait
