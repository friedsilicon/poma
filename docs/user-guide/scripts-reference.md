# Scripts Reference

Complete reference for all validation and setup scripts in the workspace.

## Setup Scripts

### `setup-dev-env.sh`

Sets up the Python development environment with all dependencies.

**Usage:**
```bash
./scripts/setup-dev-env.sh
```

**What it does:**
- Creates Python virtual environment in `venv/`
- Installs all dependencies from `requirements.txt`
- Verifies YANG tool installation
- Checks system dependencies
- Provides activation instructions

**Options:**
- No command-line options (interactive script)

**Example output:**
```
✓ Creating virtual environment...
✓ Installing Python dependencies...
✓ Verifying YANG tools...
  - pyang: 2.5.3 ✓
  - yanglint: 2.1.0 ✓
✓ Environment ready!

To activate: source venv/bin/activate
```

### `setup-bgp-models.sh`

Creates organized symlinks for BGP models and dependencies.

**Usage:**
```bash
./scripts/setup-bgp-models.sh
```

**What it does:**
- Creates vendor directories: `models/nokia/`, `models/openconfig/`, `models/ietf/`
- Symlinks Nokia BGP models and dependencies
- Symlinks OpenConfig BGP models and dependencies  
- Symlinks IETF standard types
- Verifies symlink integrity

**Output structure:**
```
models/
├── nokia/
│   ├── nokia-sr-bgp.yang -> ../../yang-models-nokia/...
│   ├── nokia-sr-common.yang -> ../../yang-models-nokia/...
│   └── ...
├── openconfig/
│   ├── openconfig-bgp.yang -> ../../yang-models-openconfig/...
│   └── ...
└── ietf/
    ├── ietf-yang-types.yang -> ../../yang-models-openconfig/...
    └── ...
```

## Validation Scripts

### `validate-bgp.sh` 

Generic BGP model validation script (vendor-agnostic).

**Usage:**
```bash
./validate-bgp.sh [OPTIONS]
```

**Options:**
- `-t, --tree` : Generate tree structure output
- `-q, --quiet` : Quiet mode (errors only)
- `-v, --verbose` : Verbose output with detailed information
- `-c, --compare` : Compare models across vendors
- `-h, --help` : Show help message

**Examples:**
```bash
# Basic validation
./validate-bgp.sh

# Tree structure output
./validate-bgp.sh --tree

# Quiet mode for CI
./validate-bgp.sh -q

# Verbose debugging
./validate-bgp.sh -v
```

**Exit codes:**
- `0` : All validations passed
- `1` : Validation errors found
- `2` : Script usage error

### `validate-nokia-bgp.sh`

Nokia-specific BGP model validation.

**Usage:**
```bash
./validate-nokia-bgp.sh [OPTIONS]
```

**Options:**
- `-t, --tree` : Generate tree structure for Nokia models
- `-q, --quiet` : Quiet mode (errors only)
- `-d, --dependencies` : Show dependency tree
- `-h, --help` : Show help message

**Examples:**
```bash
# Validate Nokia BGP models
./validate-nokia-bgp.sh

# Generate tree output
./validate-nokia-bgp.sh -t

# Check dependencies
./validate-nokia-bgp.sh -d
```

**Validated models:**
- `nokia-sr-bgp.yang` - Core BGP configuration
- `nokia-sr-common.yang` - Common definitions
- `nokia-sros-yang-extensions.yang` - Nokia extensions

### `validate-openconfig-bgp.sh`

OpenConfig-specific BGP model validation.

**Usage:**
```bash
./validate-openconfig-bgp.sh [OPTIONS]
```

**Options:**
- `-t, --tree` : Generate tree structure for OpenConfig models
- `-q, --quiet` : Quiet mode (errors only)
- `-s, --standards` : Validate against IETF standards compliance
- `-h, --help` : Show help message

**Examples:**
```bash
# Validate OpenConfig BGP models
./validate-openconfig-bgp.sh

# Generate tree output  
./validate-openconfig-bgp.sh -t

# Standards compliance check
./validate-openconfig-bgp.sh -s
```

**Validated models:**
- `openconfig-bgp.yang` - Main BGP configuration
- `openconfig-bgp-types.yang` - BGP-specific types
- `openconfig-routing-policy.yang` - Policy definitions

## Script Options Reference

### Common Options

All validation scripts support these common options:

| Option | Short | Description | Example |
|--------|-------|-------------|---------|
| `--tree` | `-t` | Generate tree structure output | `./validate-bgp.sh -t` |
| `--quiet` | `-q` | Suppress normal output, show errors only | `./validate-bgp.sh -q` |
| `--help` | `-h` | Show usage help | `./validate-bgp.sh -h` |

### Advanced Options

| Option | Script | Description |
|--------|--------|-------------|
| `--verbose` | `validate-bgp.sh` | Detailed debugging output |
| `--compare` | `validate-bgp.sh` | Cross-vendor model comparison |
| `--dependencies` | `validate-nokia-bgp.sh` | Show dependency relationships |
| `--standards` | `validate-openconfig-bgp.sh` | IETF compliance checking |

## Output Formats

### Standard Output

Default validation output includes:
```
Validating Nokia BGP models...
✓ nokia-sr-bgp.yang: Valid
✓ nokia-sr-common.yang: Valid  
✓ Dependencies resolved: 3/3
Summary: 2 models validated, 0 errors
```

### Tree Output (`-t`)

Tree structure visualization:
```
module: nokia-sr-bgp
  +--rw configure
     +--rw router* [router-name]
        +--rw bgp
           +--rw admin-state?   nokia-types:admin-state
           +--rw router-id?     inet:ipv4-address
           +--rw neighbor* [ip-address]
              +--rw ip-address    inet:ip-address
              +--rw admin-state?  nokia-types:admin-state
```

### Quiet Output (`-q`)

Error-only output for CI/automation:
```
ERROR: nokia-sr-bgp.yang:45: undefined prefix: nokia-types
```

### Verbose Output (`-v`)

Detailed debugging information:
```
Validating Nokia BGP models...
[DEBUG] Model path: models/nokia/nokia-sr-bgp.yang
[DEBUG] Dependencies: nokia-sr-common.yang, ietf-yang-types.yang
[DEBUG] pyang command: pyang --path=models/nokia:models/ietf models/nokia/nokia-sr-bgp.yang
✓ nokia-sr-bgp.yang: Valid (45 nodes, 12 containers, 33 leaves)
```

## Integration Examples

### CI/CD Usage

```bash
#!/bin/bash
# CI validation script

set -e

# Setup environment
./scripts/setup-dev-env.sh
source venv/bin/activate

# Validate all models
./validate-bgp.sh -q || exit 1
./validate-nokia-bgp.sh -q || exit 1
./validate-openconfig-bgp.sh -q || exit 1

echo "All validations passed"
```

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Only validate if YANG files changed
if git diff --cached --name-only | grep -q '\.yang$'; then
    echo "YANG files modified, running validation..."
    ./validate-bgp.sh -q
fi
```

### Makefile Integration

```makefile
.PHONY: validate validate-nokia validate-openconfig

validate: validate-nokia validate-openconfig

validate-nokia:
	./validate-nokia-bgp.sh -q

validate-openconfig:
	./validate-openconfig-bgp.sh -q

tree:
	./validate-bgp.sh -t > bgp-tree.txt
```

## Troubleshooting Scripts

### Common Script Issues

**Script not executable:**
```bash
chmod +x validate-*.sh setup-*.sh
```

**Virtual environment not found:**
```bash
./scripts/setup-dev-env.sh  # Recreate environment
source venv/bin/activate
```

**Missing dependencies:**
```bash
source venv/bin/activate
pip install -r requirements.txt
```

**Symlink errors:**
```bash
./scripts/setup-bgp-models.sh  # Recreate symlinks
ls -la models/*/  # Verify links
```

### Debug Mode

For troubleshooting, run scripts with bash debug:
```bash
bash -x ./validate-bgp.sh -v
```

## Script Customization

### Adding New Validation Scripts

Template for vendor-specific scripts:
```bash
#!/bin/bash
# validate-vendor-bgp.sh

VENDOR="vendor"
MODEL_DIR="models/${VENDOR}"
MODELS=("vendor-bgp.yang" "vendor-common.yang")

# Include common functions
source validate-common.sh

validate_vendor_models() {
    echo "Validating ${VENDOR} BGP models..."
    for model in "${MODELS[@]}"; do
        validate_model "${MODEL_DIR}/${model}"
    done
}

# Parse options and run validation
parse_options "$@"
validate_vendor_models
```

### Configuration Files

Scripts can be configured via environment variables:
```bash
# Custom model paths
export NOKIA_MODEL_PATH="custom/path/nokia"
export OPENCONFIG_MODEL_PATH="custom/path/openconfig"

# Validation options
export PYANG_OPTIONS="--strict --max-line-length=120"
export YANG_PATH="models/nokia:models/openconfig:models/ietf"
```

## Related Documentation

- [Models Overview](models-overview.md) - Available YANG models
- [Validation Workflows](validation.md) - Testing procedures  
- [Command Reference](../reference/command-reference.md) - Individual tool commands
- [Troubleshooting](../getting-started/troubleshooting.md) - Common issues
