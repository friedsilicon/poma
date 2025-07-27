# Quick Start Guide

Get up and running with YANG model validation in just a few steps.

## Prerequisites

- **Git**: For cloning the repository
- **Python 3.8+**: For YANG tools and validation
- **macOS/Linux**: Windows users should use WSL

## New User Setup

### 1. Clone the Repository

```bash
# Clone with submodules (important!)
git clone --recursive <your-repo-url>
cd poma
```

!!! tip "Fast Setup Available"
    For faster setup, skip `--recursive` during clone and use our optimized scripts instead.

### 2. Fast Setup (Recommended)

=== "🚀 Fastest (Makefile)"
    ```bash
    # Complete setup in one command
    make setup
    ```

=== "⚡ Fast Scripts"
    ```bash
    # Step 1: Python environment
    ./scripts/setup-dev-env.sh
    
    # Step 2: Fast submodule setup (shallow clone)
    ./scripts/setup-submodules-fast.sh
    
    # Step 3: BGP model organization
    ./scripts/setup-bgp-models.sh
    ```

=== "🏗️ CI/Build (Ultra-fast)"
    ```bash
    # For CI or build environments
    ./scripts/setup-submodules-fast.sh ci
    ```

!!! info "Setup Options"
    - **`make setup`**: Complete workflow (recommended)
    - **`shallow`**: Fast setup with shallow clones (default)
    - **`ci`**: Fastest for automated builds
    - **`full`**: Complete git history (slower)

### 3. Traditional Setup (Slower)

```bash
# One-time setup (installs Python dependencies)
./scripts/setup-dev-env.sh
```

This script will:
- Create a Python virtual environment
- Install required packages (pyang, etc.)
- Verify YANG tool availability
- Test basic functionality

### 4. Activate and Test

```bash
# Activate the environment
source venv/bin/activate

# Test BGP model validation (using Makefile)
make validate

# OR test manually
./validate-bgp.sh
```

You should see output showing Nokia and OpenConfig BGP models validating successfully.

## Performance Comparison

| Method | Setup Time | Description |
|--------|------------|-------------|
| `make setup` | ~30s | Complete automated setup |
| `setup-submodules-fast.sh ci` | ~10s | Ultra-fast for CI |
| `setup-submodules-fast.sh shallow` | ~20s | Fast with shallow clones |
| `git submodule update --recursive` | ~3-5min | Traditional full clone |

!!! success "Acceleration Achieved"
    The optimized setup reduces clone time from **5+ minutes to under 30 seconds** by using shallow clones and targeted dependency management.

## Daily Workflow

### Basic Commands

```bash
# Activate environment (always do this first)
source venv/bin/activate

# Navigate to models directory
cd models

# Validate all BGP models
./validate-bgp.sh

# Validate with tree output
./validate-bgp.sh -t

# Quiet mode for scripting
./validate-bgp.sh -q
```

### Vendor-Specific Validation

```bash
# Nokia BGP models only
./validate-nokia-bgp.sh -t

# OpenConfig BGP models only  
./validate-openconfig-bgp.sh -t

# Help for any script
./validate-bgp.sh -h
```

## What's Next?

- **[Validation Workflows](../user-guide/validation.md)**: Learn about all validation options
- **[Models Overview](../user-guide/models-overview.md)**: Understand the model structure  
- **[Scripts Reference](../user-guide/scripts-reference.md)**: Complete command documentation

## Troubleshooting

### Common Issues

**Error: `pyang not found`**
```bash
# Make sure virtual environment is activated
source venv/bin/activate
```

**Error: `nokia-state-router-bgp.yang not found`**
```bash
# Ensure submodules are initialized
git submodule update --init --recursive

# Re-run setup
./scripts/setup-bgp-models.sh
```

**Virtual environment missing**
```bash
# Re-run setup script
./scripts/setup-dev-env.sh
```

For more troubleshooting help, see [Troubleshooting Guide](troubleshooting.md).
