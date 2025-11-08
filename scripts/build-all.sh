#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔨 Building all DFWorX projects...${NC}"
echo ""

# Build frontend apps
echo -e "${BLUE}📦 Building frontend applications...${NC}"
pnpm build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend build successful${NC}"
else
    echo -e "${RED}✗ Frontend build failed${NC}"
    exit 1
fi

# Run tests for Python services
echo ""
echo -e "${BLUE}🧪 Running Python service tests...${NC}"
for service in services/*/; do
    if [ -f "$service/pyproject.toml" ]; then
        service_name=$(basename "$service")
        echo -e "${BLUE}  Testing ${service_name}...${NC}"
        cd "$service"
        uv run pytest
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}  ✓ ${service_name} tests passed${NC}"
        else
            echo -e "${RED}  ✗ ${service_name} tests failed${NC}"
            exit 1
        fi
        cd - > /dev/null
    fi
done

echo ""
echo -e "${GREEN}✨ All builds and tests successful!${NC}"
