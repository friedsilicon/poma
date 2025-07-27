# Installation

This guide covers the complete installation process for the PoMa workspace.

## Prerequisites

### System Requirements
- **Python 3.8+** (3.11 recommended)
- **Git** with submodule support
- **libxml2** and **libxslt** development libraries

### Platform-Specific Dependencies

=== "macOS"
    ```bash
    # Install Homebrew if not already installed
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Install dependencies
    brew install python@3.11 libxml2 libxslt
    ```

=== "Ubuntu/Debian"
    ```bash
    sudo apt update
    sudo apt install python3 python3-pip python3-venv \
                     libxml2-dev libxslt1-dev zlib1g-dev
    ```

=== "CentOS/RHEL"
    ```bash
    sudo yum install python3 python3-pip python3-venv \
                     libxml2-devel libxslt-devel
    ```

## Quick Installation

### 1. Clone Repository
```bash
git clone --recursive https://github.com/yourusername/poma.git
cd poma
```

### 2. Setup Development Environment
```bash
./scripts/setup-dev-env.sh
```

This script will:
- Create Python virtual environment
- Install all dependencies
- Verify YANG tool installation
- Check system dependencies

### 3. Setup Model Symlinks
```bash
./scripts/setup-bgp-models.sh
```

This creates organized symlinks for:
- Nokia SROS BGP models
- OpenConfig BGP models
- Required dependencies

### 4. Verify Installation
```bash
source venv/bin/activate
./validate-bgp.sh -t
```

## Manual Installation

If you prefer manual setup:

### 1. Create Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate
```

### 2. Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 3. Initialize Submodules
```bash
git submodule update --init --recursive
```

### 4. Create Model Symlinks
```bash
mkdir -p models/{nokia,openconfig,ietf}

# Nokia BGP models
ln -sf ../yang-models-nokia/nokia/7x50/yang-models/nokia-sr-bgp.yang models/nokia/
ln -sf ../yang-models-nokia/nokia/7x50/yang-models/nokia-sr-common.yang models/nokia/
# ... (additional symlinks as needed)

# OpenConfig BGP models  
ln -sf ../yang-models-openconfig/release/models/bgp/openconfig-bgp.yang models/openconfig/
# ... (additional symlinks as needed)
```

## Verification

### Check Python Environment
```bash
python --version  # Should show 3.8+
pip list | grep pyang  # Should show pyang installation
```

### Check YANG Tools
```bash
pyang --version
yanglint --version
```

### Test Model Validation
```bash
cd models
pyang --tree-type=usage nokia/nokia-sr-bgp.yang
```

## Troubleshooting

### Common Issues

**Virtual environment not activating:**
```bash
# Ensure you're in the project directory
cd poma
source venv/bin/activate
```

**Missing system libraries:**
```bash
# Check for libxml2/libxslt
python -c "import lxml; print('lxml OK')"
```

**Submodule errors:**
```bash
# Reset and re-initialize submodules
git submodule deinit --all
git submodule update --init --recursive
```

**Permission errors with symlinks:**
```bash
# Ensure you have write permissions
chmod +x setup-*.sh
```

For more troubleshooting, see the [Troubleshooting Guide](troubleshooting.md).

## Next Steps

- [Quick Start Guide](quick-start.md) - Basic usage examples
- [Validation Workflows](../user-guide/validation.md) - Testing YANG models
- [Models Overview](../user-guide/models-overview.md) - Available models
