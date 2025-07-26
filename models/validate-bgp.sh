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

# Test Nokia BGP models
echo "📋 Nokia SROS BGP models:"
echo "  Testing nokia-state-router-bgp.yang..."
if pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang > /dev/null 2>&1; then
    echo "  ✅ Nokia BGP submodule: VALID"
else
    echo "  ❌ Nokia BGP submodule: FAILED"
    echo "     Detailed error:"
    pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang
fi

echo ""
echo "  Testing nokia-state.yang (includes BGP)..."
if pyang --strict --path nokia/types:ietf nokia/common/nokia-state.yang > /dev/null 2>&1; then
    echo "  ✅ Nokia main state (with BGP): VALID"
else
    echo "  ❌ Nokia main state (with BGP): FAILED"
    echo "     Detailed error:"
    pyang --strict --path nokia/types:ietf nokia/common/nokia-state.yang
fi

echo ""
echo "📋 OpenConfig BGP models:"
echo "  Testing openconfig-bgp.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:ietf \
    openconfig/bgp/openconfig-bgp.yang > /dev/null 2>&1; then
    echo "  ✅ OpenConfig BGP: VALID"
else
    echo "  ❌ OpenConfig BGP: FAILED"
    echo "     Detailed error:"
    pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:ietf \
        openconfig/bgp/openconfig-bgp.yang
fi

echo ""
echo "🎉 BGP model validation complete!"
