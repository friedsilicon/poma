#!/bin/bash

# Fast Submodule Setup Script
# Optimizes submodule cloning for PoMa project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "🚀 Setting up PoMa submodules with optimizations..."

# Check if git supports shallow submodules
GIT_VERSION=$(git --version | cut -d' ' -f3)
echo "Git version: $GIT_VERSION"

# Function to setup submodules with optimizations
setup_submodules() {
    echo "📦 Initializing submodules with shallow clone..."
    
    # Use shallow clone with depth=1 for faster initial clone
    git submodule update --init --depth 1 --recursive
    
    echo "✅ Submodules initialized with shallow clone"
}

# Function to setup submodules for CI/build environments
setup_submodules_ci() {
    echo "🏗️  Setting up submodules for CI/build environment..."
    
    # Even more aggressive optimization for CI
    git config submodule.recurse false
    git submodule update --init --depth 1 --single-branch --no-fetch
    
    echo "✅ CI-optimized submodules setup complete"
}

# Function to convert to full clone if needed
convert_to_full() {
    echo "🔄 Converting shallow submodules to full clones..."
    
    cd open-config
    git fetch --unshallow || echo "Already full clone or failed to unshallow"
    cd ..
    
    cd nokia  
    git fetch --unshallow || echo "Already full clone or failed to unshallow"
    cd ..
    
    echo "✅ Submodules converted to full clones"
}

# Main logic
case "${1:-default}" in
    "ci")
        setup_submodules_ci
        ;;
    "full")
        setup_submodules
        convert_to_full
        ;;
    "shallow"|"default")
        setup_submodules
        ;;
    *)
        echo "Usage: $0 [ci|shallow|full]"
        echo "  ci      - Fastest setup for CI/build environments"
        echo "  shallow - Fast setup with shallow clones (default)"
        echo "  full    - Complete setup with full git history"
        exit 1
        ;;
esac

# Verify setup
echo "📊 Submodule status:"
git submodule status

echo "📈 Repository sizes:"
du -sh nokia/ open-config/ 2>/dev/null || echo "Some submodules not yet cloned"

echo ""
echo "🎯 Next steps:"
echo "  1. Run: source venv/bin/activate (if venv exists)"
echo "  2. Run: ./scripts/setup-bgp-models.sh"
echo "  3. Run: ./validate-bgp.sh"
echo ""
echo "✨ Fast submodule setup complete!"
