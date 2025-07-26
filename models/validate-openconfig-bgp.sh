#!/bin/bash

set -e

# Default options
SHOW_TREE=false
SHOW_ERRORS=false
TREE_LINES=20
QUIET=false
RUN_ALL=false

# Usage function
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Validate OpenConfig BGP YANG models with various options.

OPTIONS:
    -h, --help          Show this help message
    -t, --tree          Show BGP tree structure
    -e, --errors        Show detailed error messages
    -l, --lines NUM     Number of tree lines to show (default: 20)
    -q, --quiet         Quiet mode - minimal output
    -a, --all           Run all validation checks (includes tree and errors)
    --tree-lines NUM    Alias for --lines

EXAMPLES:
    $0                  Basic validation
    $0 -t               Validation with tree structure
    $0 -e               Validation with detailed errors
    $0 -a               All checks with tree and errors
    $0 -t -l 50         Tree with 50 lines
    $0 -q               Quiet mode
EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -t|--tree)
            SHOW_TREE=true
            shift
            ;;
        -e|--errors)
            SHOW_ERRORS=true
            shift
            ;;
        -l|--lines|--tree-lines)
            TREE_LINES="$2"
            shift 2
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -a|--all)
            RUN_ALL=true
            SHOW_TREE=true
            SHOW_ERRORS=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Set outputs based on modes
if [[ "$RUN_ALL" == "true" ]]; then
    SHOW_TREE=true
    SHOW_ERRORS=true
fi

# Quiet mode overrides
if [[ "$QUIET" == "true" ]]; then
    SHOW_TREE=false
    SHOW_ERRORS=false
fi

[[ "$QUIET" != "true" ]] && echo "🔍 Validating OpenConfig BGP YANG models..."
[[ "$QUIET" != "true" ]] && echo ""

# Check if pyang is available, if not try to activate venv
if ! command -v pyang &> /dev/null; then
    if [ -f "../venv/bin/activate" ]; then
        [[ "$QUIET" != "true" ]] && echo "🔌 Activating virtual environment for pyang..."
        source ../venv/bin/activate
    else
        echo "❌ pyang not found and no virtual environment available"
        echo "   Run: source ../venv/bin/activate"
        exit 1
    fi
fi

[[ "$QUIET" != "true" ]] && echo "📋 OpenConfig BGP models:"

# Test OpenConfig BGP types
[[ "$QUIET" != "true" ]] && echo "  Testing openconfig-bgp-types.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-types.yang > /dev/null 2>&1; then
    [[ "$QUIET" != "true" ]] && echo "  ✅ OpenConfig BGP types: VALID"
    [[ "$QUIET" == "true" ]] && echo "OpenConfig BGP types: VALID"
else
    echo "  ❌ OpenConfig BGP types: FAILED"
    if [[ "$SHOW_ERRORS" == "true" ]]; then
        echo "     Detailed error:"
        pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-types.yang
    elif [[ "$QUIET" != "true" ]]; then
        echo "     Use -e flag for detailed errors"
    fi
fi

[[ "$QUIET" != "true" ]] && echo ""

# Test OpenConfig BGP policy
[[ "$QUIET" != "true" ]] && echo "  Testing openconfig-bgp-policy.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-policy.yang > /dev/null 2>&1; then
    [[ "$QUIET" != "true" ]] && echo "  ✅ OpenConfig BGP policy: VALID"
    [[ "$QUIET" == "true" ]] && echo "OpenConfig BGP policy: VALID"
else
    echo "  ❌ OpenConfig BGP policy: FAILED"
    if [[ "$SHOW_ERRORS" == "true" ]]; then
        echo "     Detailed error:"
        pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-policy.yang
    elif [[ "$QUIET" != "true" ]]; then
        echo "     Use -e flag for detailed errors"
    fi
fi

[[ "$QUIET" != "true" ]] && echo ""

# Test main OpenConfig BGP model
[[ "$QUIET" != "true" ]] && echo "  Testing openconfig-bgp.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:openconfig/common:ietf \
    openconfig/bgp/openconfig-bgp.yang > /dev/null 2>&1; then
    [[ "$QUIET" != "true" ]] && echo "  ✅ OpenConfig BGP main model: VALID"
    [[ "$QUIET" == "true" ]] && echo "OpenConfig BGP main model: VALID"
    
    if [[ "$SHOW_TREE" == "true" ]]; then
        echo ""
        echo "  📊 BGP Tree Structure (first $TREE_LINES lines):"
        pyang -f tree --path openconfig/types:openconfig/extensions:openconfig/rib:openconfig/common:ietf \
            openconfig/bgp/openconfig-bgp.yang 2>/dev/null | head -"$TREE_LINES" || echo "     (Tree generation may require additional dependencies)"
    fi
else
    echo "  ❌ OpenConfig BGP main model: FAILED"
    if [[ "$SHOW_ERRORS" == "true" ]]; then
        echo "     Note: This may fail due to missing OpenConfig submodules"
        echo "     Detailed error summary:"
        pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:openconfig/common:ietf \
            openconfig/bgp/openconfig-bgp.yang
    elif [[ "$QUIET" != "true" ]]; then
        echo "     Note: This may fail due to missing OpenConfig submodules"
        echo "     Use -e flag for detailed errors"
    fi
fi

[[ "$QUIET" != "true" ]] && echo ""

# Check what OpenConfig models we have available
if [[ "$QUIET" != "true" ]] && [[ "$SHOW_ERRORS" == "true" || "$RUN_ALL" == "true" ]]; then
    echo "📂 Available OpenConfig BGP models:"
    find openconfig -name "*.yang" | sort | while read file; do
        echo "  - $file"
    done
fi

[[ "$QUIET" != "true" ]] && echo ""
[[ "$QUIET" != "true" ]] && echo "🎉 OpenConfig BGP model validation complete!"

if [[ "$QUIET" != "true" ]]; then
    echo ""
    echo "💡 Tips:"
    echo "   - Generate tree structure: $0 -t"
    echo "   - Show detailed errors: $0 -e" 
    echo "   - Run all checks: $0 -a"
    echo "   - Quiet mode: $0 -q"
    echo "   - Help: $0 -h"
    echo "   - OpenConfig models may need additional submodules for complete validation"
    echo "   - Individual type/policy models may validate successfully"
fi
