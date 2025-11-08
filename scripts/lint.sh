#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Linting all code...${NC}"
echo ""

# Lint frontend
echo -e "${BLUE}📦 Linting frontend code...${NC}"
pnpm lint

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend lint passed${NC}"
else
    echo -e "${RED}✗ Frontend lint failed${NC}"
    exit 1
fi

# Format check
echo ""
echo -e "${BLUE}💅 Checking code formatting...${NC}"
pnpm format:check

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Code formatting is correct${NC}"
else
    echo -e "${RED}✗ Code formatting issues found. Run 'pnpm format' to fix${NC}"
    exit 1
fi

# Lint Python services
echo ""
echo -e "${BLUE}🐍 Linting Python services...${NC}"
for service in services/*/; do
    if [ -f "$service/pyproject.toml" ]; then
        service_name=$(basename "$service")
        echo -e "${BLUE}  Linting ${service_name}...${NC}"
        cd "$service"

        # Run ruff
        uv run ruff check .
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}  ✓ ${service_name} ruff check passed${NC}"
        else
            echo -e "${RED}  ✗ ${service_name} ruff check failed${NC}"
            exit 1
        fi

        # Run mypy
        uv run mypy src/
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}  ✓ ${service_name} type check passed${NC}"
        else
            echo -e "${RED}  ✗ ${service_name} type check failed${NC}"
            exit 1
        fi

        cd - > /dev/null
    fi
done

echo ""
echo -e "${GREEN}✨ All linting passed!${NC}"
