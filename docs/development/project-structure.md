# Project Structure

Detailed overview of the YANG Modelling workspace organization and architecture.

## Repository Structure

### Top-Level Organization

```
yang-modelling/
├── .github/                    # GitHub configuration
│   └── workflows/
│       └── docs.yml           # Documentation deployment
├── .gitmodules                # Git submodule configuration
├── .gitignore                 # Git ignore patterns
├── README.md                  # Quick start guide
├── requirements.txt           # Python dependencies
├── mkdocs.yml                # Documentation configuration
├── setup-dev-env.sh          # Environment setup script
├── setup-bgp-models.sh       # Model symlink script
├── validate-*.sh             # Validation scripts
├── docs/                     # MkDocs documentation
├── models/                   # Organized YANG models (symlinks)
├── yang-models-nokia/        # Nokia YANG submodule
└── yang-models-openconfig/   # OpenConfig YANG submodule
```

### Core Components

#### Configuration Files

**`.gitmodules`** - Git submodule configuration
```ini
[submodule "yang-models-nokia"]
    path = yang-models-nokia
    url = https://github.com/nokia/7x50-YangModels.git

[submodule "yang-models-openconfig"]
    path = yang-models-openconfig
    url = https://github.com/openconfig/public.git
```

**`.gitignore`** - Ignore patterns for various file types
```gitignore
# Python
__pycache__/
*.pyc
venv/

# YANG tools
*.pyc
*.pyo

# Documentation
site/
.mkdocs_build/

# IDE
.vscode/
.idea/
```

**`requirements.txt`** - All project dependencies
```
# YANG Tools
pyang>=2.5.0
pyangbind>=0.8.0
yanglint>=2.0.0

# Documentation
mkdocs>=1.5.0
mkdocs-material>=9.0.0
mkdocs-git-revision-date-localized-plugin>=1.2.0

# Utilities
lxml>=4.9.0
```

#### Setup Scripts

**`setup-dev-env.sh`** - Development environment setup
- Creates Python virtual environment
- Installs all dependencies
- Verifies tool installation
- Checks system requirements

**`setup-bgp-models.sh`** - Model organization
- Creates vendor directories
- Establishes symlinks to submodule sources
- Organizes dependencies
- Verifies link integrity

### Model Organization

#### Directory Structure

```
models/
├── nokia/                    # Nokia SROS models
│   ├── nokia-sr-bgp.yang           → ../../yang-models-nokia/...
│   ├── nokia-sr-common.yang        → ../../yang-models-nokia/...
│   ├── nokia-sros-yang-extensions.yang → ../../yang-models-nokia/...
│   └── nokia-sr-types.yang         → ../../yang-models-nokia/...
├── openconfig/              # OpenConfig standard models
│   ├── openconfig-bgp.yang         → ../../yang-models-openconfig/...
│   ├── openconfig-bgp-types.yang   → ../../yang-models-openconfig/...
│   ├── openconfig-routing-policy.yang → ../../yang-models-openconfig/...
│   └── openconfig-interfaces.yang  → ../../yang-models-openconfig/...
└── ietf/                   # IETF standard types
    ├── ietf-yang-types.yang        → ../../yang-models-openconfig/...
    └── ietf-inet-types.yang        → ../../yang-models-openconfig/...
```

#### Symlink Strategy

**Benefits:**
- **Version control** - Source models remain in submodules
- **Organization** - Clean vendor-based structure  
- **Updates** - Easy submodule updates without reorganization
- **Efficiency** - No file duplication

**Implementation:**
```bash
# Example symlink creation
ln -sf ../../yang-models-nokia/nokia/7x50/yang-models/nokia-sr-bgp.yang \
       models/nokia/nokia-sr-bgp.yang
```

### Validation Scripts

#### Script Architecture

**Common Structure:**
```bash
#!/bin/bash
# Script header with description

set -euo pipefail              # Strict error handling

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly MODEL_DIR="${SCRIPT_DIR}/models"

# Reusable functions
usage() { ... }                # Help text
validate_model() { ... }       # Core validation logic
parse_options() { ... }        # Option parsing

# Main execution
main() { ... }
main "$@"
```

**Script Types:**

1. **`validate-bgp.sh`** - Generic BGP validation
   - Vendor-agnostic approach
   - Supports comparison mode
   - Multiple output formats

2. **`validate-nokia-bgp.sh`** - Nokia-specific validation
   - Nokia model paths and dependencies
   - SROS-specific validation rules
   - Nokia extension handling

3. **`validate-openconfig-bgp.sh`** - OpenConfig validation
   - Standards compliance checking
   - OpenConfig-specific tests
   - Cross-vendor compatibility validation

#### Option Standardization

**Common Options:**
- `-t, --tree` - Tree structure output
- `-q, --quiet` - Errors only (CI-friendly)
- `-h, --help` - Usage information
- `-v, --verbose` - Detailed output

**Script-Specific Options:**
- `-c, --compare` (generic) - Cross-vendor comparison
- `-d, --dependencies` (Nokia) - Dependency analysis
- `-s, --standards` (OpenConfig) - Standards compliance

### Documentation Architecture

#### MkDocs Structure

```
docs/
├── index.md                  # Landing page
├── getting-started/          # Setup and basics
│   ├── quick-start.md
│   ├── installation.md
│   └── troubleshooting.md
├── user-guide/              # Usage documentation
│   ├── validation.md
│   ├── models-overview.md
│   └── scripts-reference.md
├── models/                  # Model-specific docs
│   ├── index.md
│   ├── assessment.md
│   ├── nokia.md
│   └── openconfig.md
├── development/             # Contributor guides
│   ├── contributing.md
│   ├── project-structure.md
│   └── adding-models.md
└── reference/               # Command references
    ├── yang-tools.md
    └── command-reference.md
```

#### Navigation Configuration

**`mkdocs.yml` Structure:**
```yaml
nav:
  - Home: index.md
  - Getting Started:
    - Quick Start: getting-started/quick-start.md
    - Installation: getting-started/installation.md
    - Troubleshooting: getting-started/troubleshooting.md
  - User Guide:
    - Validation Workflows: user-guide/validation.md
    - Models Overview: user-guide/models-overview.md
    - Scripts Reference: user-guide/scripts-reference.md
  # ... additional sections
```

### Git Submodules

#### Submodule Management

**Configuration:**
- **Nokia Models:** `yang-models-nokia/` pointing to Nokia 7x50 repository
- **OpenConfig Models:** `yang-models-openconfig/` pointing to OpenConfig public repository

**Update Process:**
```bash
# Update all submodules to latest
git submodule update --remote

# Update specific submodule
git submodule update --remote yang-models-nokia

# Commit submodule updates
git add .gitmodules yang-models-*
git commit -m "Update YANG model submodules"
```

**Initialization:**
```bash
# Clone with submodules
git clone --recursive <repo-url>

# Or initialize after clone
git submodule update --init --recursive
```

### GitHub Actions

#### Workflow Structure

**`.github/workflows/docs.yml`:**
```yaml
name: Deploy Documentation
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
      - name: Setup Python
      - name: Install dependencies
      - name: Build documentation
      - name: Upload artifact
      
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
```

**Features:**
- **Shallow clone** for faster builds
- **Dependency caching** for pip packages
- **Strict mode** building to catch errors
- **Conditional deployment** only on main branch

### File Naming Conventions

#### Scripts
- **Executable scripts:** `kebab-case.sh`
- **Setup scripts:** `setup-*.sh`
- **Validation scripts:** `validate-*.sh`

#### Documentation
- **Markdown files:** `kebab-case.md`
- **Directory names:** `kebab-case/`
- **Config files:** Standard names (`mkdocs.yml`, `requirements.txt`)

#### Models
- **Vendor directories:** Lowercase vendor names (`nokia/`, `openconfig/`)
- **Model files:** Original YANG file names (preserved from source)

### Dependency Management

#### Python Dependencies

**Categories:**
```txt
# Core YANG tools
pyang>=2.5.0                  # YANG parser and validator
pyangbind>=0.8.0             # Python bindings generator
yanglint>=2.0.0              # Alternative YANG validator

# Documentation
mkdocs>=1.5.0                # Documentation generator
mkdocs-material>=9.0.0       # Material theme
mkdocs-git-revision-date-localized-plugin>=1.2.0

# System dependencies
lxml>=4.9.0                  # XML processing
```

**System Dependencies:**
- **libxml2-dev** - XML parsing libraries
- **libxslt1-dev** - XSLT processing
- **Python 3.8+** - Runtime environment

#### Model Dependencies

**IETF Standards:** Required by all vendors
- `ietf-yang-types.yang`
- `ietf-inet-types.yang`

**Vendor-Specific:**
- **Nokia:** `nokia-sr-common.yang`, `nokia-sros-yang-extensions.yang`
- **OpenConfig:** `openconfig-types.yang`, `openconfig-extensions.yang`

### Build and Deployment

#### Local Development

```bash
# Setup
./setup-dev-env.sh
source venv/bin/activate

# Validation
./validate-bgp.sh -q

# Documentation
mkdocs serve  # http://localhost:8000
```

#### CI/CD Pipeline

1. **Trigger:** Push to main branch
2. **Build:** 
   - Checkout code and submodules
   - Setup Python environment
   - Install dependencies
   - Build documentation with strict mode
3. **Deploy:**
   - Upload build artifacts
   - Deploy to GitHub Pages
   - Update live documentation site

### Extension Points

#### Adding New Vendors

**Required files:**
1. **Submodule:** `yang-models-vendor/`
2. **Symlinks:** `models/vendor/`
3. **Script:** `validate-vendor-bgp.sh`
4. **Documentation:** `docs/models/vendor.md`

**Integration:**
- Update `setup-bgp-models.sh`
- Update navigation in `mkdocs.yml`
- Add to models overview documentation

#### Adding New Protocols

**Structure:**
```
models/
├── nokia/
│   ├── bgp/          # Existing
│   └── ospf/         # New protocol
├── openconfig/
│   ├── bgp/          # Existing  
│   └── ospf/         # New protocol
```

**Scripts:**
- `validate-ospf.sh` - Generic protocol validation
- `validate-nokia-ospf.sh` - Vendor-specific validation

## Design Principles

### Modularity
- **Vendor separation** - Clean boundaries between vendors
- **Protocol isolation** - Each protocol independently testable
- **Script reusability** - Common functions and patterns

### Maintainability
- **Clear structure** - Predictable organization
- **Documentation** - Comprehensive guides and references
- **Automation** - Minimal manual steps for setup and validation

### Extensibility
- **Plugin architecture** - Easy addition of new vendors/protocols
- **Template scripts** - Consistent patterns for new components
- **Flexible configuration** - Environment variable support

### Reliability
- **Version control** - All dependencies tracked in git
- **Automated testing** - CI validation of changes
- **Error handling** - Graceful failure modes and clear error messages

## Related Documentation

- [Contributing Guide](contributing.md) - How to contribute
- [Adding Models](adding-models.md) - Detailed integration guide
- [Installation Guide](../getting-started/installation.md) - Setup instructions
- [Troubleshooting](../getting-started/troubleshooting.md) - Common issues
