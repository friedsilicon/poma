# YANG Modelling

For the cursed, and the fallen. We are forced to live with YANG, so let's make it tolerable.

This repository contains a comprehensive collection of YANG models from various sources, along with tools and scripts to work with them. Use at your own peril, but hopefully with less suffering.

## Overview

This workspace aggregates YANG models from multiple authoritative sources to provide a centralized location for network modeling and validation. The repository includes both vendor-neutral industry standards and vendor-specific implementations.

## Repository Structure

```
├── README.md                 # This file
├── open-config/              # OpenConfig YANG models (submodule)
└── nokia/                    # Nokia SR OS YANG models (submodule)
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
- YANG tools (pyang, yanglint, etc.)
- Python environment for YANG processing

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
```

## Tools and Scripts

You will find various tools and scripts to deal with the sometimes awful organization of YANG information. These may include:

- Model validation scripts
- Documentation generators
- Model comparison utilities
- Configuration templates

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
