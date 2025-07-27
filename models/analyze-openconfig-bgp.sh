#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default options
SHOW_TREE=true
SHOW_GROUPINGS=false
TREE_DEPTH=5
QUIET=false
OUTPUT_FILE=""

# Usage function
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Analyze OpenConfig BGP YANG models and generate root tree structure.

OPTIONS:
    -h, --help              Show this help message
    -t, --tree              Show BGP tree structure (default: enabled)
    -g, --groupings         Include groupings in tree output
    -d, --depth NUM         Tree depth limit (default: 5)
    -o, --output FILE       Save tree output to file
    -q, --quiet             Quiet mode - minimal output

EXAMPLES:
    $0                      Generate basic tree structure
    $0 -g                   Include groupings in output
    $0 -d 3                 Limit tree depth to 3 levels
    $0 -o oc-bgp-tree.txt   Save output to file
    $0 -g -d 10 -o full.txt Complete analysis saved to file
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
        -g|--groupings)
            SHOW_GROUPINGS=true
            shift
            ;;
        -d|--depth)
            TREE_DEPTH="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if we're in the right directory
if [[ ! -d "openconfig" ]]; then
    echo -e "${RED}❌ Please run this script from the models directory${NC}"
    exit 1
fi

# Activate virtual environment
if [[ ! -f "../venv/bin/activate" ]]; then
    echo -e "${RED}❌ Virtual environment not found. Please run setup-dev-env.sh first${NC}"
    exit 1
fi

if [[ "$QUIET" == "false" ]]; then
    echo -e "${BLUE}🔍 Analyzing OpenConfig BGP YANG models...${NC}"
    echo
fi

# Source the virtual environment
source ../venv/bin/activate

# Build pyang command
PYANG_CMD="pyang -f tree"

if [[ "$SHOW_GROUPINGS" == "true" ]]; then
    PYANG_CMD="$PYANG_CMD --tree-print-groupings"
fi

if [[ "$TREE_DEPTH" != "" ]]; then
    PYANG_CMD="$PYANG_CMD --tree-depth=$TREE_DEPTH"
fi

PYANG_CMD="$PYANG_CMD -p openconfig -p ietf -p ../open-config/release/models openconfig/bgp/openconfig-bgp.yang"

if [[ "$QUIET" == "false" ]]; then
    echo -e "${YELLOW}📊 Generating OpenConfig BGP tree structure...${NC}"
    echo -e "${BLUE}Command: $PYANG_CMD${NC}"
    echo
fi

# Generate the tree
if [[ "$OUTPUT_FILE" != "" ]]; then
    # Save to file
    if [[ "$QUIET" == "false" ]]; then
        echo -e "${GREEN}💾 Saving output to: $OUTPUT_FILE${NC}"
        echo
    fi
    
    {
        echo "# OpenConfig BGP YANG Model Tree Structure"
        echo "# Generated on: $(date)"
        echo "# Command: $PYANG_CMD"
        echo
        eval $PYANG_CMD 2>/dev/null
    } > "$OUTPUT_FILE"
    
    if [[ "$QUIET" == "false" ]]; then
        echo -e "${GREEN}✅ Tree structure saved to $OUTPUT_FILE${NC}"
        echo
        echo -e "${BLUE}📋 Summary:${NC}"
        echo "   - Lines: $(wc -l < "$OUTPUT_FILE")"
        echo "   - File size: $(ls -lh "$OUTPUT_FILE" | awk '{print $5}')"
    fi
else
    # Output to stdout
    eval $PYANG_CMD 2>/dev/null
fi

# Analysis summary
if [[ "$QUIET" == "false" ]]; then
    echo
    echo -e "${GREEN}🎉 OpenConfig BGP analysis complete!${NC}"
    echo
    echo -e "${BLUE}📋 Key Findings:${NC}"
    echo "   ✅ Main container: bgp (grouping: bgp-top)"
    echo "   ✅ Global configuration: bgp/global"
    echo "   ✅ Neighbor management: bgp/neighbors"
    echo "   ✅ Peer groups: bgp/peer-groups"
    echo "   ✅ BGP RIB: bgp/rib"
    echo "   ✅ Multi-protocol support: IPv4/IPv6 unicast, labeled-unicast, L3VPN, L2VPN, SR-TE"
    echo
    echo -e "${YELLOW}💡 Tips:${NC}"
    echo "   - Use -g flag to include all grouping definitions"
    echo "   - Use -d flag to control tree depth (default: 5)"
    echo "   - Use -o flag to save detailed analysis to file"
    echo "   - OpenConfig follows standardized configuration patterns"
    echo "   - Model supports comprehensive BGP feature set"
fi
