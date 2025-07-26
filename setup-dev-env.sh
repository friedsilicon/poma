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
pip install -r requirements-dev.txt

echo ""
echo "✅ Development environment setup complete!"
echo ""
echo "🚀 To activate the environment in the future:"
echo "   source venv/bin/activate"
echo ""
echo "🔍 To verify installation:"
echo "   pyang --version"
echo "   yanglint --version"
echo ""
echo "📚 To deactivate when done:"
echo "   deactivate"
echo ""
echo "🧪 Next steps:"
echo "   1. Test: cd models && ./validate-bgp.sh"
echo "   2. Explore: yanggui models/openconfig/bgp/openconfig-bgp.yang"
