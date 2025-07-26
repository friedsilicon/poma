# Adding Models

Step-by-step guide for integrating new YANG models into the workspace.

## Overview

This guide covers adding new vendor models, protocols, or updating existing model sources. The process maintains the organized structure while ensuring validation and documentation completeness.

## Before You Start

### Prerequisites

- Development environment set up (`./setup-dev-env.sh`)
- Understanding of the target vendor's YANG model structure
- Git submodule experience
- Basic YANG knowledge

### Planning Checklist

- [ ] Identify model source repository
- [ ] Understand vendor-specific dependencies
- [ ] Plan directory organization
- [ ] Consider validation requirements
- [ ] Review documentation needs

## Adding a New Vendor

### Step 1: Add Model Source as Submodule

```bash
# Example: Adding Cisco models
git submodule add https://github.com/YangModels/yang.git yang-models-cisco

# Or with specific branch/tag
git submodule add -b master https://github.com/YangModels/yang.git yang-models-cisco

# Initialize the submodule
git submodule update --init yang-models-cisco
```

**Best practices:**
- Use descriptive submodule names: `yang-models-{vendor}`
- Pin to specific tags when available for stability
- Document the source and version in commit message

### Step 2: Explore Model Structure

```bash
# Examine the submodule structure
cd yang-models-cisco
find . -name "*.yang" -path "*/bgp*" | head -10

# Identify key models and dependencies
grep -r "import.*bgp" . | head -5
```

**Look for:**
- BGP-related models
- Common type definitions
- Vendor-specific extensions
- Dependency relationships

### Step 3: Create Vendor Directory

```bash
# Create vendor model directory
mkdir -p models/cisco

# Plan symlink structure based on source layout
# Example structure for Cisco:
# models/cisco/
# ├── bgp/
# │   ├── cisco-bgp.yang
# │   └── cisco-bgp-types.yang
# └── common/
#     ├── cisco-common-types.yang
#     └── cisco-extensions.yang
```

### Step 4: Create Symlinks

Create symlinks to organize models from the submodule:

```bash
#!/bin/bash
# add to setup-bgp-models.sh or create setup-cisco-models.sh

# Cisco BGP models (example paths - adjust based on actual structure)
CISCO_SOURCE="yang-models-cisco/vendor/cisco/xe/16101"

# Create symlinks for Cisco BGP models
ln -sf "../../../${CISCO_SOURCE}/Cisco-IOS-XE-bgp.yang" models/cisco/
ln -sf "../../../${CISCO_SOURCE}/Cisco-IOS-XE-bgp-types.yang" models/cisco/

# Create symlinks for dependencies
ln -sf "../../../${CISCO_SOURCE}/Cisco-IOS-XE-native.yang" models/cisco/
ln -sf "../../../${CISCO_SOURCE}/Cisco-IOS-XE-types.yang" models/cisco/

echo "✓ Cisco BGP models linked"
```

**Symlink best practices:**
- Use relative paths for portability
- Group related models logically
- Include all dependencies
- Verify links work: `ls -la models/cisco/`

### Step 5: Create Validation Script

Create a vendor-specific validation script:

```bash
#!/bin/bash
# validate-cisco-bgp.sh

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CISCO_MODEL_DIR="${SCRIPT_DIR}/models/cisco"
readonly IETF_MODEL_DIR="${SCRIPT_DIR}/models/ietf"

# Cisco-specific models to validate
readonly CISCO_BGP_MODELS=(
    "Cisco-IOS-XE-bgp.yang"
    "Cisco-IOS-XE-bgp-types.yang"
)

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Validate Cisco BGP YANG models.

Options:
    -t, --tree      Generate tree structure output
    -q, --quiet     Quiet mode (errors only)
    -d, --deps      Show dependency analysis
    -h, --help      Show this help

Examples:
    $0              # Basic validation
    $0 --tree       # With tree output
    $0 -q           # Quiet mode for CI

EOF
}

validate_cisco_models() {
    local tree_output=false
    local quiet_mode=false
    local show_deps=false
    
    # Parse options (implementation details...)
    
    echo "Validating Cisco BGP models..."
    
    local error_count=0
    
    for model in "${CISCO_BGP_MODELS[@]}"; do
        local model_path="${CISCO_MODEL_DIR}/${model}"
        
        if [[ ! -f "$model_path" ]]; then
            echo "ERROR: Model not found: $model_path"
            ((error_count++))
            continue
        fi
        
        if $quiet_mode; then
            pyang --path="${CISCO_MODEL_DIR}:${IETF_MODEL_DIR}" "$model_path" 2>/dev/null
        elif $tree_output; then
            echo "=== Tree structure for $model ==="
            pyang --format=tree --path="${CISCO_MODEL_DIR}:${IETF_MODEL_DIR}" "$model_path"
        else
            echo -n "Validating $model... "
            if pyang --path="${CISCO_MODEL_DIR}:${IETF_MODEL_DIR}" "$model_path" >/dev/null 2>&1; then
                echo "✓ Valid"
            else
                echo "✗ Invalid"
                pyang --path="${CISCO_MODEL_DIR}:${IETF_MODEL_DIR}" "$model_path"
                ((error_count++))
            fi
        fi
    done
    
    if [[ $error_count -eq 0 ]]; then
        echo "Summary: All Cisco BGP models validated successfully"
        return 0
    else
        echo "Summary: $error_count validation errors found"
        return 1
    fi
}

# Option parsing
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tree)
            tree_output=true
            shift
            ;;
        -q|--quiet)
            quiet_mode=true
            shift
            ;;
        -d|--deps)
            show_deps=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            exit 1
            ;;
    esac
done

# Main execution
validate_cisco_models
```

### Step 6: Test Validation

```bash
# Make script executable
chmod +x validate-cisco-bgp.sh

# Test basic validation
./validate-cisco-bgp.sh

# Test different output modes
./validate-cisco-bgp.sh -t
./validate-cisco-bgp.sh -q

# Test error handling
./validate-cisco-bgp.sh --invalid-option
```

### Step 7: Update Setup Scripts

Add the new vendor to existing setup scripts:

```bash
# Update setup-bgp-models.sh
echo "Setting up Cisco BGP models..."
./setup-cisco-models.sh  # Or inline the symlink creation

# Or create a comprehensive setup script
# setup-all-models.sh that calls individual vendor scripts
```

### Step 8: Create Documentation

Create vendor-specific documentation at `docs/models/cisco.md`:

```markdown
# Cisco Models

Comprehensive documentation for Cisco IOS-XE YANG models.

## Overview

Cisco IOS-XE provides YANG models for network configuration...

## Available Models

### Core BGP Models

#### `Cisco-IOS-XE-bgp.yang`
**Description:** Main BGP configuration model for Cisco IOS-XE
**Location:** `models/cisco/Cisco-IOS-XE-bgp.yang`
**Status:** ✅ Validated

...

## Validation Examples

### Basic Validation
```bash
./validate-cisco-bgp.sh
```

...
```

### Step 9: Update Navigation

Update `mkdocs.yml` to include the new documentation:

```yaml
nav:
  # ... existing navigation ...
  - Models:
    - Overview: models/index.md
    - Nokia Models: models/nokia.md
    - OpenConfig Models: models/openconfig.md
    - Cisco Models: models/cisco.md  # Add new entry
    - Assessment: models/assessment.md
```

### Step 10: Update Overview Documentation

Update `docs/user-guide/models-overview.md`:

```markdown
### Cisco IOS-XE Models
**Location:** `models/cisco/`  
**Source:** [YangModels Repository](../yang-models-cisco/)

| Model | Status | Description |
|-------|--------|-------------|
| `Cisco-IOS-XE-bgp.yang` | ✅ Validated | Core BGP configuration model |
| `Cisco-IOS-XE-bgp-types.yang` | ✅ Validated | BGP-specific types |
```

## Adding a New Protocol

### Example: Adding OSPF Support

#### Step 1: Identify OSPF Models

```bash
# Search existing submodules for OSPF models
find yang-models-* -name "*ospf*" -type f
find yang-models-* -name "*routing*" -type f | grep -i ospf
```

#### Step 2: Plan Directory Structure

```
models/
├── nokia/
│   ├── bgp/      # Existing
│   └── ospf/     # New
├── openconfig/
│   ├── bgp/      # Existing
│   └── ospf/     # New
└── cisco/
    ├── bgp/      # Existing (if added)
    └── ospf/     # New
```

#### Step 3: Create OSPF-Specific Scripts

```bash
# Copy and modify existing BGP scripts
cp validate-bgp.sh validate-ospf.sh
cp validate-nokia-bgp.sh validate-nokia-ospf.sh
cp validate-openconfig-bgp.sh validate-openconfig-ospf.sh

# Modify for OSPF-specific models and paths
```

#### Step 4: Update Setup Scripts

```bash
# Extend setup-bgp-models.sh or create setup-ospf-models.sh
echo "Setting up OSPF models..."

# Nokia OSPF models
ln -sf "../../../yang-models-nokia/nokia/7x50/yang-models/nokia-sr-ospf.yang" models/nokia/ospf/

# OpenConfig OSPF models  
ln -sf "../../../yang-models-openconfig/release/models/ospf/openconfig-ospf.yang" models/openconfig/ospf/
```

## Advanced Integration

### Handling Complex Dependencies

#### Dependency Analysis

```bash
#!/bin/bash
# analyze-dependencies.sh

MODEL_FILE="$1"

echo "Analyzing dependencies for: $MODEL_FILE"
echo

# Extract import statements
echo "Direct imports:"
grep -E "^\s*import\s+" "$MODEL_FILE" | sed 's/.*import \([^{;]*\).*/\1/' | sort | uniq

echo
echo "Indirect dependencies:"
# More complex analysis using pyang
pyang --print-error-code --format=depend "$MODEL_FILE"
```

#### Complex Symlink Structures

For vendors with complex directory structures:

```bash
# Handle nested directories
mkdir -p models/vendor/{bgp,ospf,common,types}

# Preserve some source structure
ln -sf "../../../../yang-models-vendor/protocols/bgp/vendor-bgp.yang" models/vendor/bgp/
ln -sf "../../../../yang-models-vendor/protocols/ospf/vendor-ospf.yang" models/vendor/ospf/
ln -sf "../../../../yang-models-vendor/common/vendor-types.yang" models/vendor/common/
```

### Version Management

#### Pinning Submodule Versions

```bash
# Pin to specific tag
cd yang-models-vendor
git checkout v2.1.0
cd ..
git add yang-models-vendor
git commit -m "Pin vendor models to v2.1.0"

# Document version in setup script
echo "# Using vendor models v2.1.0"
echo "# Release notes: https://github.com/vendor/yang/releases/tag/v2.1.0"
```

#### Handling Model Updates

```bash
#!/bin/bash
# update-vendor-models.sh

echo "Updating vendor YANG models..."

# Save current version
CURRENT_COMMIT=$(cd yang-models-vendor && git rev-parse HEAD)
echo "Current version: $CURRENT_COMMIT"

# Update to latest
git submodule update --remote yang-models-vendor

# Test validation
if ./validate-vendor-bgp.sh -q; then
    echo "✓ Validation passed with updated models"
    git add yang-models-vendor
    git commit -m "Update vendor models

Previous: $CURRENT_COMMIT
Current: $(cd yang-models-vendor && git rev-parse HEAD)"
else
    echo "✗ Validation failed, reverting update"
    cd yang-models-vendor
    git checkout "$CURRENT_COMMIT"
    cd ..
    exit 1
fi
```

### Cross-Vendor Validation

#### Comparative Analysis

```bash
#!/bin/bash
# compare-vendors.sh

echo "Comparing BGP models across vendors..."

# Generate tree structures for comparison
pyang --format=tree models/nokia/nokia-sr-bgp.yang > /tmp/nokia-tree.txt
pyang --format=tree models/openconfig/openconfig-bgp.yang > /tmp/openconfig-tree.txt
pyang --format=tree models/cisco/Cisco-IOS-XE-bgp.yang > /tmp/cisco-tree.txt

# Compare capabilities
echo "=== Feature Comparison ==="
echo "Nokia BGP containers:"
grep -E "^\s*\+--rw\s+" /tmp/nokia-tree.txt | wc -l

echo "OpenConfig BGP containers:"
grep -E "^\s*\+--rw\s+" /tmp/openconfig-tree.txt | wc -l

echo "Cisco BGP containers:"
grep -E "^\s*\+--rw\s+" /tmp/cisco-tree.txt | wc -l
```

## Integration Testing

### Automated Testing

```bash
#!/bin/bash
# test-new-vendor.sh

set -euo pipefail

VENDOR="$1"

echo "Testing $VENDOR integration..."

# Test 1: Symlinks exist
echo "Checking symlinks..."
if [[ ! -d "models/$VENDOR" ]]; then
    echo "✗ Vendor directory missing"
    exit 1
fi

find "models/$VENDOR" -type l | while read -r link; do
    if [[ ! -e "$link" ]]; then
        echo "✗ Broken symlink: $link"
        exit 1
    fi
done
echo "✓ All symlinks valid"

# Test 2: Validation script works
echo "Testing validation script..."
if "./validate-$VENDOR-bgp.sh" -q; then
    echo "✓ Validation script passes"
else
    echo "✗ Validation script fails"
    exit 1
fi

# Test 3: Documentation builds
echo "Testing documentation..."
if mkdocs build --strict >/dev/null 2>&1; then
    echo "✓ Documentation builds successfully"
else
    echo "✗ Documentation build fails"
    exit 1
fi

echo "✓ All tests passed for $VENDOR"
```

### Continuous Integration

Add vendor-specific testing to GitHub Actions:

```yaml
# .github/workflows/test-models.yml
name: Test YANG Models

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        vendor: [nokia, openconfig, cisco]
    
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install -r requirements.txt
      
      - name: Setup models
        run: ./setup-bgp-models.sh
      
      - name: Validate ${{ matrix.vendor }}
        run: ./validate-${{ matrix.vendor }}-bgp.sh -q
```

## Best Practices

### Naming Conventions

- **Submodules:** `yang-models-{vendor}`
- **Directories:** `models/{vendor}/`
- **Scripts:** `validate-{vendor}-{protocol}.sh`
- **Documentation:** `docs/models/{vendor}.md`

### Error Handling

```bash
# Robust symlink creation
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -f "$source" ]]; then
        echo "WARNING: Source file not found: $source"
        return 1
    fi
    
    mkdir -p "$(dirname "$target")"
    
    if [[ -L "$target" ]]; then
        rm "$target"  # Remove existing symlink
    fi
    
    ln -sf "$source" "$target"
    echo "✓ Created: $target -> $source"
}
```

### Documentation Standards

- **Comprehensive examples** for each model
- **Version compatibility** information
- **Troubleshooting sections** for known issues
- **Cross-references** to related documentation

## Troubleshooting

### Common Issues

**Broken symlinks:**
```bash
find models/ -type l ! -exec test -e {} \; -print
```

**Missing dependencies:**
```bash
pyang --print-error-code models/vendor/model.yang
```

**Import resolution failures:**
```bash
pyang --path=models/vendor:models/ietf:models/common models/vendor/model.yang
```

### Recovery Procedures

**Reset symlinks:**
```bash
find models/ -type l -delete
./setup-bgp-models.sh
```

**Submodule issues:**
```bash
git submodule deinit --all
git submodule update --init --recursive
```

## Related Documentation

- [Project Structure](project-structure.md) - Repository organization
- [Contributing Guide](contributing.md) - General contribution guidelines
- [Models Overview](../user-guide/models-overview.md) - Current model status
- [Validation Workflows](../user-guide/validation.md) - Testing procedures
