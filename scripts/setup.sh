#!/bin/bash

set -e

echo "🚀 Setting up DFWorX workspace..."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if PNPM is installed
if ! command -v pnpm &> /dev/null; then
    echo -e "${YELLOW}📦 Installing PNPM...${NC}"
    npm install -g pnpm
else
    echo -e "${GREEN}✓${NC} PNPM is already installed"
fi

# Check if UV is installed
if ! command -v uv &> /dev/null; then
    echo -e "${YELLOW}🐍 Installing UV...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
else
    echo -e "${GREEN}✓${NC} UV is already installed"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker is not installed. Please install Docker from https://docker.com${NC}"
else
    echo -e "${GREEN}✓${NC} Docker is installed"
fi

echo ""
echo -e "${BLUE}📦 Installing frontend dependencies...${NC}"
pnpm install

echo ""
echo -e "${BLUE}🐍 Setting up Python services...${NC}"
for service in services/*/; do
    if [ -f "$service/pyproject.toml" ]; then
        service_name=$(basename "$service")
        echo -e "${BLUE}  Setting up ${service_name}...${NC}"
        cd "$service"
        uv venv
        uv sync
        cd - > /dev/null
        echo -e "${GREEN}  ✓ ${service_name} setup complete${NC}"
    fi
done

echo ""
echo -e "${BLUE}📝 Setting up environment files...${NC}"

# Copy environment files if they don't exist
if [ ! -f "apps/web/.env.local" ]; then
    cp apps/web/.env.example apps/web/.env.local
    echo -e "${GREEN}  ✓ Created apps/web/.env.local${NC}"
else
    echo -e "${YELLOW}  ⚠ apps/web/.env.local already exists${NC}"
fi

if [ ! -f "services/auth-service/.env" ]; then
    cp services/auth-service/.env.example services/auth-service/.env
    echo -e "${GREEN}  ✓ Created services/auth-service/.env${NC}"
else
    echo -e "${YELLOW}  ⚠ services/auth-service/.env already exists${NC}"
fi

if [ ! -f "infrastructure/docker/.env" ]; then
    cp infrastructure/docker/.env.example infrastructure/docker/.env
    echo -e "${GREEN}  ✓ Created infrastructure/docker/.env${NC}"
else
    echo -e "${YELLOW}  ⚠ infrastructure/docker/.env already exists${NC}"
fi

echo ""
echo -e "${GREEN}✨ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit .env files with your configuration"
echo "  2. Run ${BLUE}./scripts/dev.sh${NC} to start development environment"
echo "  3. Or run ${BLUE}docker-compose -f infrastructure/docker/docker-compose.yml up${NC}"
echo ""
