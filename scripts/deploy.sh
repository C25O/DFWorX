#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying DFWorX...${NC}"
echo ""

# Check if on main branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "main" ]; then
    echo -e "${YELLOW}⚠️  Warning: You are not on the main branch (current: $current_branch)${NC}"
    read -p "Do you want to continue? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deployment cancelled"
        exit 1
    fi
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}❌ You have uncommitted changes. Please commit or stash them first.${NC}"
    exit 1
fi

# Run tests
echo -e "${BLUE}🧪 Running tests...${NC}"
./scripts/test-all.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Tests failed. Deployment cancelled.${NC}"
    exit 1
fi

# Run linting
echo ""
echo -e "${BLUE}🔍 Running linting...${NC}"
./scripts/lint.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Linting failed. Deployment cancelled.${NC}"
    exit 1
fi

# Build all projects
echo ""
echo -e "${BLUE}🔨 Building projects...${NC}"
./scripts/build-all.sh

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed. Deployment cancelled.${NC}"
    exit 1
fi

# Deploy based on environment
echo ""
read -p "Deploy to (1) Coolify or (2) Docker Compose? " -n 1 -r
echo
if [[ $REPLY == "1" ]]; then
    echo -e "${BLUE}📤 Pushing to GitHub (Coolify auto-deploy)...${NC}"
    git push origin main
    echo -e "${GREEN}✓ Pushed to GitHub. Coolify will auto-deploy.${NC}"
elif [[ $REPLY == "2" ]]; then
    echo -e "${BLUE}🐳 Deploying with Docker Compose...${NC}"
    cd infrastructure/docker
    docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
    cd - > /dev/null
    echo -e "${GREEN}✓ Deployed with Docker Compose${NC}"
else
    echo "Invalid option. Deployment cancelled."
    exit 1
fi

echo ""
echo -e "${GREEN}✨ Deployment complete!${NC}"
