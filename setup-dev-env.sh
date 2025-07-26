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

# Create virtual environment
echo "🏗️  Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip

# Install development dependencies
echo "📦 Installing YANG development tools..."
pip install -r requirements-dev.txt

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
echo "   3. Add more models: edit setup-bgp-models.sh and re-run if needed"
