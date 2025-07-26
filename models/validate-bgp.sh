#!/bin/bash

set -e

echo "🔍 Validating BGP YANG models..."
echo ""

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
