#!/bin/bash

set -e

echo "🔍 Validating BGP YANG models..."
echo ""

# Check if pyang is available, if not try to activate venv
if ! command -v pyang &> /dev/null; then
    if [ -f "../venv/bin/activate" ]; then
        echo "🔌 Activating virtual environment for pyang..."
        source ../venv/bin/activate
    else
        echo "❌ pyang not found and no virtual environment available"
        echo "   Run: source ../venv/bin/activate"
        exit 1
    fi
fi

echo "🏢 Running Nokia BGP validation..."
echo "=================================================="
./validate-nokia-bgp.sh

echo ""
echo "🌐 Running OpenConfig BGP validation..."
echo "=================================================="  
./validate-openconfig-bgp.sh

echo ""
echo "🎉 Complete BGP model validation finished!"
echo ""
echo "📋 Summary:"
echo "   Nokia BGP models: Fully functional with tree generation"
echo "   OpenConfig BGP models: Individual components may work, full model needs dependencies"
