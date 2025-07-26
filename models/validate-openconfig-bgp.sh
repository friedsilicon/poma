#!/bin/bash

set -e

echo "🔍 Validating OpenConfig BGP YANG models..."
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

echo "📋 OpenConfig BGP models:"

# Test OpenConfig BGP types
echo "  Testing openconfig-bgp-types.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-types.yang > /dev/null 2>&1; then
    echo "  ✅ OpenConfig BGP types: VALID"
else
    echo "  ❌ OpenConfig BGP types: FAILED"
    echo "     Detailed error:"
    pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-types.yang 2>&1 | head -10
fi

echo ""

# Test OpenConfig BGP policy
echo "  Testing openconfig-bgp-policy.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-policy.yang > /dev/null 2>&1; then
    echo "  ✅ OpenConfig BGP policy: VALID"
else
    echo "  ❌ OpenConfig BGP policy: FAILED"
    echo "     Detailed error:"
    pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-policy.yang 2>&1 | head -10
fi

echo ""

# Test main OpenConfig BGP model
echo "  Testing openconfig-bgp.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:openconfig/common:ietf \
    openconfig/bgp/openconfig-bgp.yang > /dev/null 2>&1; then
    echo "  ✅ OpenConfig BGP main model: VALID"
    echo ""
    echo "  📊 BGP Tree Structure (if available):"
    pyang -f tree --path openconfig/types:openconfig/extensions:openconfig/rib:openconfig/common:ietf \
        openconfig/bgp/openconfig-bgp.yang 2>/dev/null | head -20 || echo "     (Tree generation may require additional dependencies)"
else
    echo "  ❌ OpenConfig BGP main model: FAILED"
    echo "     Note: This may fail due to missing OpenConfig submodules"
    echo "     Detailed error summary:"
    pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:openconfig/common:ietf \
        openconfig/bgp/openconfig-bgp.yang 2>&1 | head -10
fi

echo ""

# Check what OpenConfig models we have available
echo "📂 Available OpenConfig BGP models:"
find openconfig -name "*.yang" | sort | while read file; do
    echo "  - $file"
done

echo ""
echo "🎉 OpenConfig BGP model validation complete!"
echo ""
echo "💡 Tips:"
echo "   - OpenConfig models may need additional submodules for complete validation"
echo "   - Individual type/policy models may validate successfully"
echo "   - Check OpenConfig documentation for complete model dependencies"
