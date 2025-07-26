#!/bin/bash

set -e

echo "🔍 Validating Nokia BGP YANG models..."
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

echo "📋 Nokia SROS BGP models:"

# Test Nokia BGP submodule (standalone)
echo "  Testing nokia-state-router-bgp.yang (BGP submodule)..."
if pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang > /dev/null 2>&1; then
    echo "  ✅ Nokia BGP submodule: VALID"
else
    echo "  ❌ Nokia BGP submodule: FAILED"
    echo "     Detailed error:"
    pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang
fi

echo ""

# Test Nokia router state module (includes all routing protocols)
echo "  Testing nokia-state-router.yang (includes BGP)..."
if pyang --strict --path nokia/types:nokia/common:nokia/router:ietf nokia/common/nokia-state-router.yang > /dev/null 2>&1; then
    echo "  ✅ Nokia router state (with BGP): VALID"
else
    echo "  ❌ Nokia router state (with BGP): FAILED"
    echo "     Note: This may fail due to missing dependencies for other protocols"
    echo "     Detailed error summary:"
    pyang --strict --path nokia/types:nokia/common:nokia/router:ietf nokia/common/nokia-state-router.yang 2>&1 | head -10
fi

echo ""

# Test Nokia BGP-only test model (complete tree)
echo "  Testing nokia-state-bgp-only.yang (BGP tree model)..."
if pyang --strict --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang > /dev/null 2>&1; then
    echo "  ✅ Nokia BGP tree model: VALID"
    echo ""
    echo "  📊 BGP Tree Structure (first 20 lines):"
    pyang -f tree --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang 2>/dev/null | head -20
else
    echo "  ❌ Nokia BGP tree model: FAILED"
    echo "     Detailed error:"
    pyang --strict --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang
fi

echo ""
echo "🎉 Nokia BGP model validation complete!"
echo ""
echo "💡 Tips:"
echo "   - Generate full tree: pyang -f tree --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang"
echo "   - Validate specific submodule: pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang"
