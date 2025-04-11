#!/bin/bash
#==============================================================================
# Script: verify_ci_setup.sh
# Description: Verifies CI/CD setup and tests configuration
# Usage: ./verify_ci_setup.sh
#==============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "======================================"
echo "  CI/CD Setup Verification"
echo "======================================"
echo ""

ERRORS=0
WARNINGS=0

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} Found: $1"
    else
        echo -e "${RED}✗${NC} Missing: $1"
        ERRORS=$((ERRORS + 1))
    fi
}

# Function to check directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} Found: $1/"
    else
        echo -e "${RED}✗${NC} Missing: $1/"
        ERRORS=$((ERRORS + 1))
    fi
}

# Check workflow files
echo "${BLUE}Checking GitHub Actions workflows...${NC}"
check_file ".github/workflows/ci.yml"
check_file ".github/workflows/nightly.yml"
check_file ".github/workflows/release.yml"
check_file ".github/README.md"
echo ""

# Check documentation
echo "${BLUE}Checking CI/CD documentation...${NC}"
check_file "docs/ci_cd.md"
check_file "docs/CI_CD_QUICK_REF.md"
echo ""

# Check .gitignore
echo "${BLUE}Checking .gitignore...${NC}"
check_file ".gitignore"
if [ -f ".gitignore" ]; then
    if grep -q "build/" .gitignore && grep -q "*.vvp" .gitignore; then
        echo -e "${GREEN}✓${NC} .gitignore contains build artifact patterns"
    else
        echo -e "${YELLOW}⚠${NC} .gitignore may be missing some patterns"
        WARNINGS=$((WARNINGS + 1))
    fi
fi
echo ""

# Check scripts are executable
echo "${BLUE}Checking script permissions...${NC}"
if [ -x "scripts/compile.sh" ]; then
    echo -e "${GREEN}✓${NC} scripts/compile.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} scripts/compile.sh is not executable"
    echo "  Run: chmod +x scripts/compile.sh"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -x "scripts/simulate.sh" ]; then
    echo -e "${GREEN}✓${NC} scripts/simulate.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} scripts/simulate.sh is not executable"
    echo "  Run: chmod +x scripts/simulate.sh"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -x "sim/run_all_tests.sh" ]; then
    echo -e "${GREEN}✓${NC} sim/run_all_tests.sh is executable"
else
    echo -e "${YELLOW}⚠${NC} sim/run_all_tests.sh is not executable"
    echo "  Run: chmod +x sim/run_all_tests.sh"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Check for required directories
echo "${BLUE}Checking project structure...${NC}"
check_dir "rtl"
check_dir "sim"
check_dir "sim/testbenches"
check_dir "scripts"
check_dir "docs"
echo ""

# Check for iverilog
echo "${BLUE}Checking local tools...${NC}"
if command -v iverilog &> /dev/null; then
    VERSION=$(iverilog -v 2>&1 | head -1)
    echo -e "${GREEN}✓${NC} Icarus Verilog installed: $VERSION"
else
    echo -e "${YELLOW}⚠${NC} Icarus Verilog not installed (optional for local dev)"
    echo "  Install: brew install icarus-verilog (macOS) or apt install iverilog (Linux)"
    WARNINGS=$((WARNINGS + 1))
fi

if command -v docker &> /dev/null; then
    VERSION=$(docker --version)
    echo -e "${GREEN}✓${NC} Docker installed: $VERSION"
else
    echo -e "${YELLOW}⚠${NC} Docker not installed (recommended for CI replication)"
    echo "  Install from: https://docs.docker.com/get-docker/"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Check README badges
echo "${BLUE}Checking README.md...${NC}"
if [ -f "README.md" ]; then
    if grep -q "actions/workflows/ci.yml/badge.svg" README.md; then
        echo -e "${GREEN}✓${NC} README.md contains CI badge"
    else
        echo -e "${YELLOW}⚠${NC} README.md missing CI badge"
        WARNINGS=$((WARNINGS + 1))
    fi
    
    if grep -q "YOUR_USERNAME" README.md; then
        echo -e "${YELLOW}⚠${NC} README.md contains placeholder 'YOUR_USERNAME'"
        echo "  Update badge URLs with your GitHub username/repo"
        WARNINGS=$((WARNINGS + 1))
    else
        echo -e "${GREEN}✓${NC} README.md badge URLs updated"
    fi
fi
echo ""

# Test workflow YAML syntax (if python available)
echo "${BLUE}Checking workflow YAML syntax...${NC}"
if command -v python3 &> /dev/null; then
    python3 - <<'EOF'
import sys
import re

def check_yaml_basic(filename):
    try:
        with open(filename, 'r') as f:
            content = f.read()
            # Basic checks
            if not content.startswith('name:'):
                print(f"  ⚠ {filename} doesn't start with 'name:'")
                return False
            if 'on:' not in content:
                print(f"  ⚠ {filename} missing 'on:' trigger section")
                return False
            if 'jobs:' not in content:
                print(f"  ⚠ {filename} missing 'jobs:' section")
                return False
            return True
    except Exception as e:
        print(f"  ✗ Error reading {filename}: {e}")
        return False

files = [
    '.github/workflows/ci.yml',
    '.github/workflows/nightly.yml',
    '.github/workflows/release.yml'
]

all_ok = True
for f in files:
    if check_yaml_basic(f):
        print(f"  ✓ {f} has valid basic structure")
    else:
        all_ok = False

sys.exit(0 if all_ok else 1)
EOF
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Workflow files have valid basic structure"
    else
        echo -e "${RED}✗${NC} Some workflow files may have issues"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${YELLOW}⚠${NC} Python not available for YAML validation"
    WARNINGS=$((WARNINGS + 1))
fi
echo ""

# Summary
echo "======================================"
echo "  Verification Summary"
echo "======================================"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Your CI/CD setup is ready to use."
    echo ""
    echo "Next steps:"
    echo "1. Update README.md badge URLs with your GitHub username/repo"
    echo "2. Commit and push to GitHub: git add . && git commit -m 'Add CI/CD' && git push"
    echo "3. Check Actions tab on GitHub to see workflows"
    echo ""
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Passed with $WARNINGS warning(s)${NC}"
    echo ""
    echo "CI/CD setup is functional but has minor issues."
    echo "Review warnings above and fix if needed."
    echo ""
    exit 0
else
    echo -e "${RED}✗ Failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "Please fix the errors above before pushing to GitHub."
    echo ""
    exit 1
fi
