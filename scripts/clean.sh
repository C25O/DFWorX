#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Cleaning DFWorX workspace...${NC}"
echo ""

# Clean frontend
echo -e "${BLUE}📦 Cleaning frontend...${NC}"
find . -name "node_modules" -type d -prune -exec rm -rf '{}' +
find . -name ".next" -type d -prune -exec rm -rf '{}' +
find . -name "dist" -type d -prune -exec rm -rf '{}' +
find . -name ".turbo" -type d -prune -exec rm -rf '{}' +
echo -e "${GREEN}✓ Frontend cleaned${NC}"

# Clean Python
echo ""
echo -e "${BLUE}🐍 Cleaning Python services...${NC}"
find . -name "__pycache__" -type d -prune -exec rm -rf '{}' +
find . -name ".pytest_cache" -type d -prune -exec rm -rf '{}' +
find . -name ".ruff_cache" -type d -prune -exec rm -rf '{}' +
find . -name ".mypy_cache" -type d -prune -exec rm -rf '{}' +
find . -name "*.pyc" -type f -delete
find . -name ".venv" -type d -prune -exec rm -rf '{}' +
find . -name "htmlcov" -type d -prune -exec rm -rf '{}' +
echo -e "${GREEN}✓ Python cleaned${NC}"

# Clean Docker
echo ""
echo -e "${BLUE}🐳 Cleaning Docker resources...${NC}"
read -p "Do you want to clean Docker containers and volumes? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd infrastructure/docker
    docker-compose down -v
    cd - > /dev/null
    echo -e "${GREEN}✓ Docker cleaned${NC}"
else
    echo -e "${YELLOW}⊘ Docker cleanup skipped${NC}"
fi

echo ""
echo -e "${GREEN}✨ Cleanup complete!${NC}"
