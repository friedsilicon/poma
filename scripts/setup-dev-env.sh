#!/bin/bash

set -e

echo "🔧 Setting up YANG Modeling Development Environment"
echo ""

# Check Python version
PYTHON_VERSION=$(python3 --version 2>/dev/null || echo "Python not found")
echo "📍 Found: $PYTHON_VERSION"

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not found. Please install Python 3.8+ first."
    exit 1
fi

echo "🏗️  Creating virtual environment..."
python3 -m venv venv

echo "🔌 Activating virtual environment..."
source venv/bin/activate

echo "⬆️  Upgrading pip..."
pip install --upgrade pip

echo "📦 Installing YANG development tools..."
pip install -r requirements.txt

# Attempt to install libyang Python bindings if system libyang is available
echo ""
echo "🔧 Attempting to install libyang Python bindings..."
if command -v yanglint &> /dev/null; then
    echo "   System libyang detected, trying to install Python bindings..."
    if pip install libyang; then
        echo "✅ libyang Python bindings installed successfully"
    else
        echo "⚠️  Failed to install libyang Python bindings"
        echo "   This is optional - you can still use pyang for validation"
        echo "   See docs/reference/yang-tools.md for troubleshooting"
    fi
else
    echo "   System libyang not found - skipping Python bindings"
    echo "   Install system libyang first if you need the Python bindings"
    echo "   See docs/reference/yang-tools.md for installation instructions"
fi

# Check for system-level YANG tools
echo ""
echo "🔍 Checking for additional YANG tools..."

if command -v yanglint &> /dev/null; then
    echo "✅ yanglint found: $(yanglint --version 2>/dev/null || echo 'installed')"
else
    echo "⚠️  yanglint not found - install with:"
    echo "   macOS: brew install libyang"
    echo "   Ubuntu: sudo apt-get install libyang-tools"
    echo "   See docs/reference/yang-tools.md for details"
fi

if command -v yanggui &> /dev/null; then
    echo "✅ yanggui found"
else
    echo "ℹ️  yanggui not found - optional GUI tool"
    echo "   See: https://github.com/alliedtelesis/yanggui"
fi

# Check if models directory exists, if not create BGP models
if [ ! -d "models" ]; then
    echo "🔗 Setting up BGP model symlinks..."
    ./setup-bgp-models.sh
else
    echo "📂 Models directory already exists - symlinks preserved"
fi

echo ""
echo "✅ Development environment setup complete!"
echo ""
echo "🧪 Testing YANG tools..."
python test-yang-tools.py
echo ""
echo "� For fast submodule setup (recommended):"
echo "   ./scripts/setup-submodules-fast.sh"
echo ""
echo "�🚀 To activate the environment in the future:"
echo "   source venv/bin/activate"
echo ""
echo "🔍 To verify tools anytime:"
echo "   python test-yang-tools.py"
echo ""
echo "📚 To deactivate when done:"
echo "   deactivate"
echo ""
echo "🧪 Next steps:"
echo "   1. Setup models: ./scripts/setup-submodules-fast.sh"
echo "   2. Create symlinks: ./scripts/setup-bgp-models.sh"  
echo "   3. Test: ./validate-bgp.sh"
