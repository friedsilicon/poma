# YANG Modelling

For the cursed, and the fallen. We are forced to live with YANG, so let's make it tolerable.

This repository contains a comprehensive collection of YANG models from various sources, along with tools and scripts to work with them. Use at your own peril, but hopefully with less suffering.

## Overview

This workspace aggregates YANG models from multiple authoritative sources to provide a centralized location for network modeling and validation. The repository includes both vendor-neutral industry standards and vendor-specific implementations.

## Repository Structure

```
├── README.md                 # This file
├── .gitignore               # Python and YANG-specific ignores
├── requirements-dev.txt     # Development dependencies
├── setup-dev-env.sh         # Automated development environment setup
├── setup-bgp-models.sh      # Script to create BGP model symlinks
├── models/                  # Organized YANG models (symlinks)
│   ├── nokia/              # Nokia models and types
│   ├── openconfig/         # OpenConfig models and types  
│   └── ietf/               # IETF standard types
├── open-config/            # OpenConfig YANG models (submodule)
└── nokia/                  # Nokia SR OS YANG models (submodule)
```

## Submodules

### OpenConfig Public Models (`open-config/`)

**Source:** [openconfig/public](https://github.com/openconfig/public.git)

The OpenConfig working group develops vendor-neutral, model-driven network management standards. These YANG models provide:

- Vendor-agnostic network device configuration and operational state models
- Standardized interfaces for network management systems
- Models for BGP, OSPF, interfaces, routing policy, and more
- Widely adopted across the industry for multi-vendor network automation

**Key Features:**
- Vendor-neutral design
- Operational and configuration state separation
- Comprehensive protocol and feature coverage
- Active community development

### Nokia 7x50 YANG Models (`nokia/`)

**Source:** [nokia/7x50_YangModels](https://github.com/nokia/7x50_YangModels.git)

Nokia's SR OS (Service Router Operating System) YANG models for their 7750 SR and 7950 XRS series routers. Includes models for multiple SR OS versions:

**Available Versions:**
- SR OS 19.5 through 25.7
- Latest stable releases for each major version
- Comprehensive coverage of Nokia-specific features and extensions

**Key Features:**
- Nokia-specific service and protocol implementations
- Support for advanced MPLS/VPN services
- Carrier-grade networking features
- Version-specific model evolution

## Getting Started

### Prerequisites

- Git with submodule support
- Python 3.8+ environment
- YANG tools (see Development Setup below)

### Development Setup

**Quick Setup (Recommended):**
```bash
# Run the automated setup script
./setup-dev-env.sh
```

**Manual Setup:**
```bash
# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install development dependencies
pip install --upgrade pip
pip install -r requirements-dev.txt

# Verify installation
pyang --version
yanglint --version
```

**Virtual Environment Management:**
```bash
# Activate environment (do this each time you work on the project)
source venv/bin/activate

# Deactivate when done
deactivate

# Remove environment (if needed)
rm -rf venv
```

### Alternative Virtual Environment Options

While we recommend `venv` for this project, here are other options:

- **`conda`** - Good if you need scientific packages or manage multiple Python versions
- **`poetry`** - Excellent for complex dependency management and packaging
- **`pipenv`** - Combines pip and venv with Pipfile management
- **`virtualenv`** - Older tool, mostly superseded by `venv`

**For YANG modeling work, `venv` is ideal because:**
- Most YANG tools are pip-installable
- Simple dependency tree
- Lightweight and fast
- Works well with CI/CD

**Key Tools Included:**
- `pyang` - YANG validator, converter, and code generator
- `yanglint` - libyang-based YANG linter and validator  
- `yanggui` - GUI tool for YANG model visualization
- `yangson` - JSON/YANG data processing
- `pyangbind` - Python bindings for YANG models

### Cloning the Repository

```bash
# Clone with submodules
git clone --recursive https://github.com/your-repo/yang-modelling.git

# Or clone and initialize submodules separately
git clone https://github.com/your-repo/yang-modelling.git
cd yang-modelling
git submodule update --init --recursive
```

### Updating Submodules

To get the latest updates from the upstream repositories:

```bash
# Update all submodules to latest
git submodule update --remote

# Update specific submodule
git submodule update --remote open-config
git submodule update --remote nokia
```

## Working with YANG Models

### Basic Validation

```bash
# Validate a YANG model using pyang
pyang --strict open-config/release/models/interfaces/openconfig-interfaces.yang

# Validate with dependencies
pyang --path open-config/release/models open-config/release/models/interfaces/openconfig-interfaces.yang
```

### Generating Documentation

```bash
# Generate HTML documentation
pyang -f jstree open-config/release/models/interfaces/openconfig-interfaces.yang -o interfaces.html

# Generate tree view
pyang -f tree open-config/release/models/interfaces/openconfig-interfaces.yang

# Generate UML diagram (requires graphviz)
pyang -f uml open-config/release/models/bgp/openconfig-bgp.yang -o bgp-model.png
```

### Using YANG GUI Tools

```bash
# Launch YANG GUI for visual model exploration
yanggui

# Open specific model in GUI
yanggui models/openconfig/bgp/openconfig-bgp.yang

# Validate with yanglint (alternative to pyang)
yanglint models/nokia/bgp/nokia-state.yang
```

## Tools and Scripts

You will find various tools and scripts to deal with the sometimes awful organization of YANG information. These may include:

- Model validation scripts
- Documentation generators
- Model comparison utilities
- Configuration templates

## Organized Models

This repository includes a pre-configured `models/` directory with vendor-specific symlinks to the most commonly used YANG models. **The symlinks are tracked in git**, so they're automatically available after cloning.

### BGP Models (Pre-configured)
- **Nokia BGP**: `models/nokia/bgp/` - Nokia SROS 19.10 BGP state models
- **OpenConfig BGP**: `models/openconfig/bgp/` - Industry-standard BGP models
- **Dependencies**: Organized in `models/nokia/types/`, `models/openconfig/types/`, and `models/ietf/`

### Testing the Models
```bash
# Activate your development environment
source venv/bin/activate

# Test model validation
cd models && ./validate-bgp.sh

# Explore with GUI
yanggui openconfig/bgp/openconfig-bgp.yang
```

All required models have already been symlinked. Raise an issue, or reach via slack if you need other models. 

## Contributing

When adding new YANG model sources:

1. Add as git submodules to maintain upstream tracking
2. Update this README with source information
3. Add any necessary tooling or scripts
4. Document known issues or workarounds

## Resources

- [OpenConfig Documentation](https://openconfig.net/)
- [Nokia SR OS YANG Models Guide](https://documentation.nokia.com/)
- [RFC 7950 - The YANG 1.1 Data Modeling Language](https://tools.ietf.org/html/rfc7950)
- [pyang - YANG validator and converter](https://github.com/mbj4668/pyang)

## License

This repository aggregates models from various sources. Please refer to individual submodules for their respective licenses:

- OpenConfig models: Apache License 2.0
- Nokia models: See Nokia's licensing terms

---

*"In the grim darkness of network management, there is only YANG."*
