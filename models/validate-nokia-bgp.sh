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

Validate Nokia BGP YANG models with various options.

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

[[ "$QUIET" != "true" ]] && echo "🔍 Validating Nokia BGP YANG models..."
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

[[ "$QUIET" != "true" ]] && echo "📋 Nokia SROS BGP models:"

# Test Nokia BGP submodule (standalone)
[[ "$QUIET" != "true" ]] && echo "  Testing nokia-state-router-bgp.yang (BGP submodule)..."
if pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang > /dev/null 2>&1; then
    [[ "$QUIET" != "true" ]] && echo "  ✅ Nokia BGP submodule: VALID"
    [[ "$QUIET" == "true" ]] && echo "Nokia BGP submodule: VALID"
else
    echo "  ❌ Nokia BGP submodule: FAILED"
    if [[ "$SHOW_ERRORS" == "true" ]]; then
        echo "     Detailed error:"
        pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang
    fi
fi

[[ "$QUIET" != "true" ]] && echo ""

# Test Nokia router state module (includes all routing protocols)
[[ "$QUIET" != "true" ]] && echo "  Testing nokia-state-router.yang (includes BGP)..."
if pyang --strict --path nokia/types:nokia/common:nokia/router:ietf nokia/common/nokia-state-router.yang > /dev/null 2>&1; then
    [[ "$QUIET" != "true" ]] && echo "  ✅ Nokia router state (with BGP): VALID"
    [[ "$QUIET" == "true" ]] && echo "Nokia router state: VALID"
else
    [[ "$QUIET" != "true" ]] && echo "  ❌ Nokia router state (with BGP): FAILED"
    [[ "$QUIET" == "true" ]] && echo "Nokia router state: FAILED"
    if [[ "$SHOW_ERRORS" == "true" ]]; then
        echo "     Note: This may fail due to missing dependencies for other protocols"
        echo "     Detailed error summary:"
        pyang --strict --path nokia/types:nokia/common:nokia/router:ietf nokia/common/nokia-state-router.yang 2>&1 | head -10
    elif [[ "$QUIET" != "true" ]]; then
        echo "     Note: This may fail due to missing dependencies for other protocols"
        echo "     Use -e flag for detailed errors"
    fi
fi

[[ "$QUIET" != "true" ]] && echo ""

# Test Nokia BGP-only test model (complete tree)
[[ "$QUIET" != "true" ]] && echo "  Testing nokia-state-bgp-only.yang (BGP tree model)..."
if pyang --strict --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang > /dev/null 2>&1; then
    [[ "$QUIET" != "true" ]] && echo "  ✅ Nokia BGP tree model: VALID"
    [[ "$QUIET" == "true" ]] && echo "Nokia BGP tree model: VALID"
    
    if [[ "$SHOW_TREE" == "true" ]]; then
        echo ""
        echo "  📊 BGP Tree Structure (first $TREE_LINES lines):"
        pyang -f tree --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang 2>/dev/null | head -"$TREE_LINES"
    fi
else
    echo "  ❌ Nokia BGP tree model: FAILED"
    if [[ "$SHOW_ERRORS" == "true" ]]; then
        echo "     Detailed error:"
        pyang --strict --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang
    fi
fi

[[ "$QUIET" != "true" ]] && echo ""
[[ "$QUIET" != "true" ]] && echo "🎉 Nokia BGP model validation complete!"

if [[ "$QUIET" != "true" ]]; then
    echo ""
    echo "💡 Tips:"
    echo "   - Generate full tree: $0 -t"
    echo "   - Show detailed errors: $0 -e" 
    echo "   - Run all checks: $0 -a"
    echo "   - Quiet mode: $0 -q"
    echo "   - Help: $0 -h"
fi
