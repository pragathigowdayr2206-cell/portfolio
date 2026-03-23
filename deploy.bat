@echo off
REM Portfolio Deployment Script for Windows
REM This script helps deploy the portfolio to various platforms

echo 🚀 Portfolio Deployment Script
echo ===============================

REM Check if we're in the right directory
if not exist "package.json" (
    echo [ERROR] Please run this script from the portfolio root directory
    pause
    exit /b 1
)

if not exist "index.html" (
    echo [ERROR] Please run this script from the portfolio root directory
    pause
    exit /b 1
)

REM Check if git is initialized
if not exist ".git" (
    echo [ERROR] This is not a git repository. Please initialize git first.
    pause
    exit /b 1
)

REM Main menu
echo Choose deployment option:
echo 1. Deploy to GitHub Pages (using gh-pages)
echo 2. Setup GitHub Pages (push to GitHub)
echo 3. Check deployment status
echo 4. Install dependencies
echo 5. Exit

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto deploy_github
if "%choice%"=="2" goto setup_github
if "%choice%"=="3" goto check_status
if "%choice%"=="4" goto install_deps
if "%choice%"=="5" goto exit_script

echo [ERROR] Invalid choice. Please run the script again.
pause
exit /b 1

:deploy_github
echo [INFO] Deploying to GitHub Pages...
echo [INFO] Installing gh-pages if not already installed...
call npm install -g gh-pages
echo [INFO] Deploying...
call gh-pages -d .
echo [INFO] Deployment to GitHub Pages completed!
echo [INFO] Your site should be available at: https://pragathigowdayr2206-cell.github.io/portfolio
goto end

:setup_github
echo [INFO] Setting up GitHub Pages...

REM Check current branch
for /f "tokens=*" %%i in ('git branch --show-current') do set current_branch=%%i
echo [INFO] Current branch: %current_branch%

if not "%current_branch%"=="main" (
    echo [WARNING] You are not on the main branch.
    set /p switch_branch="Do you want to switch to main branch? (y/n): "
    if /i "%switch_branch%"=="y" (
        git checkout main
    )
)

echo [INFO] Pushing to GitHub...
git add .
git commit -m "Deploy portfolio"
git push origin main
echo [INFO] Code pushed to GitHub. GitHub Actions will handle the deployment.
goto end

:check_status
echo [INFO] Checking deployment status...

if exist ".github\workflows\deploy.yml" (
    echo [INFO] GitHub Actions workflow found. Check your repository's Actions tab for deployment status.
) else (
    echo [WARNING] No GitHub Actions workflow found.
)

if exist "netlify.toml" (
    echo [INFO] Netlify configuration found. You can deploy to Netlify by connecting your repository.
)

if exist "vercel.json" (
    echo [INFO] Vercel configuration found. You can deploy to Vercel by connecting your repository.
)
goto end

:install_deps
echo [INFO] Installing dependencies...
call npm install
echo [INFO] Dependencies installed successfully.
goto end

:exit_script
echo [INFO] Goodbye!
goto end

:end
echo [INFO] Deployment process completed!
pause