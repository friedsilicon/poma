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
cd yang-modelling
```

!!! warning "Submodules Required"
    The `--recursive` flag is essential as this repository contains Nokia and OpenConfig models as git submodules.

### 2. Set Up Development Environment

```bash
# One-time setup (installs Python dependencies)
./setup-dev-env.sh
```

This script will:
- Create a Python virtual environment
- Install required packages (pyang, etc.)
- Verify YANG tool availability
- Test basic functionality

### 3. Activate and Test

```bash
# Activate the environment
source venv/bin/activate

# Test BGP model validation
cd models && ./validate-bgp.sh
```

You should see output showing Nokia BGP models validating successfully.

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
./setup-bgp-models.sh
```

**Virtual environment missing**
```bash
# Re-run setup script
./setup-dev-env.sh
```

For more troubleshooting help, see [Troubleshooting Guide](troubleshooting.md).
