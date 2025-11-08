#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Running all tests...${NC}"
echo ""

# Test frontend
echo -e "${BLUE}📦 Testing frontend applications...${NC}"
pnpm test

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend tests passed${NC}"
else
    echo -e "${RED}✗ Frontend tests failed${NC}"
    exit 1
fi

# Test Python services
echo ""
echo -e "${BLUE}🐍 Testing Python services...${NC}"
for service in services/*/; do
    if [ -f "$service/pyproject.toml" ]; then
        service_name=$(basename "$service")
        echo -e "${BLUE}  Testing ${service_name}...${NC}"
        cd "$service"
        uv run pytest --cov=src --cov-report=term-missing
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
echo -e "${GREEN}✨ All tests passed!${NC}"
