#!/bin/bash

# Portfolio Deployment Script
# This script helps deploy the portfolio to various platforms

echo "🚀 Portfolio Deployment Script"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -f "index.html" ]; then
    print_error "Please run this script from the portfolio root directory"
    exit 1
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    print_error "This is not a git repository. Please initialize git first."
    exit 1
fi

# Function to deploy to GitHub Pages
deploy_github_pages() {
    print_status "Deploying to GitHub Pages..."

    # Check if gh-pages is installed
    if ! command -v gh-pages &> /dev/null; then
        print_status "Installing gh-pages..."
        npm install -g gh-pages
    fi

    # Deploy
    gh-pages -d .
    print_status "Deployment to GitHub Pages completed!"
    print_status "Your site should be available at: https://pragathigowdayr2206-cell.github.io/portfolio"
}

# Function to check deployment status
check_deployment() {
    print_status "Checking deployment status..."

    # Check if GitHub Actions workflow exists
    if [ -f ".github/workflows/deploy.yml" ]; then
        print_status "GitHub Actions workflow found. Check your repository's Actions tab for deployment status."
    else
        print_warning "No GitHub Actions workflow found."
    fi

    # Check if netlify.toml exists
    if [ -f "netlify.toml" ]; then
        print_status "Netlify configuration found. You can deploy to Netlify by connecting your repository."
    fi

    # Check if vercel.json exists
    if [ -f "vercel.json" ]; then
        print_status "Vercel configuration found. You can deploy to Vercel by connecting your repository."
    fi
}

# Function to setup GitHub Pages manually
setup_github_pages() {
    print_status "Setting up GitHub Pages..."

    # Check current branch
    current_branch=$(git branch --show-current)
    if [ "$current_branch" != "main" ]; then
        print_warning "You are not on the main branch. Current branch: $current_branch"
        read -p "Do you want to switch to main branch? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git checkout main
        fi
    fi

    # Push to GitHub
    print_status "Pushing to GitHub..."
    git add .
    git commit -m "Deploy portfolio"
    git push origin main

    print_status "Code pushed to GitHub. GitHub Actions will handle the deployment."
}

# Main menu
echo "Choose deployment option:"
echo "1. Deploy to GitHub Pages (using gh-pages)"
echo "2. Setup GitHub Pages (push to GitHub)"
echo "3. Check deployment status"
echo "4. Exit"

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        deploy_github_pages
        ;;
    2)
        setup_github_pages
        ;;
    3)
        check_deployment
        ;;
    4)
        print_status "Goodbye!"
        exit 0
        ;;
    *)
        print_error "Invalid choice. Please run the script again."
        exit 1
        ;;
esac

print_status "Deployment process completed!"