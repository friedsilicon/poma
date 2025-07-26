#!/bin/bash

set -e

echo "� BGP YANG Model Validation Suite"
echo "=================================="
echo ""

# Check if any parameters are passed - if so, pass them to vendor scripts
SCRIPT_ARGS="$@"

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
if [[ -n "$SCRIPT_ARGS" ]]; then
    ./validate-nokia-bgp.sh $SCRIPT_ARGS
else
    ./validate-nokia-bgp.sh
fi

echo ""
echo "🌐 Running OpenConfig BGP validation..."
echo "=================================================="  
if [[ -n "$SCRIPT_ARGS" ]]; then
    ./validate-openconfig-bgp.sh $SCRIPT_ARGS
else
    ./validate-openconfig-bgp.sh
fi

echo ""
echo "🎉 Complete BGP model validation finished!"
echo ""
echo "💡 Available options for vendor scripts:"
echo "   -h, --help          Show help message"
echo "   -t, --tree          Show BGP tree structure"
echo "   -e, --errors        Show detailed error messages"  
echo "   -l, --lines NUM     Number of tree lines to show"
echo "   -q, --quiet         Quiet mode - minimal output"
echo "   -a, --all           Run all validation checks"
echo ""
echo "📝 Examples:"
echo "   ./validate-bgp.sh -q           # Quiet mode for all vendors"
echo "   ./validate-bgp.sh -t -l 30     # Tree output with 30 lines"
echo "   ./validate-bgp.sh -a           # All checks for all vendors"
echo ""
echo "📋 Summary:"
echo "   Nokia BGP models: Fully functional with tree generation"
echo "   OpenConfig BGP models: Individual components may work, full model needs dependencies"
