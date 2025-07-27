# PoMa

For the cursed, and the fallen. We are forced to live with YANG, so let's make it tolerable.

This repository contains a comprehensive collection of YANG models from various sources, along with tools and scripts to work with them. Use at your own peril, but hopefully with less suffering.

!!! info "About the Name"
    **PoMa** is derived from "Porul Matraam" (பொருள் மாற்றம்), which means "Semantic Transformation" in Tamil. The name reflects the project's goal of transforming complex YANG models into more manageable and understandable formats.

## Features

✅ **Vendor-Organized Models**: Nokia and OpenConfig BGP models with proper dependencies  
✅ **Automated Validation**: Parameterized scripts for flexible validation workflows  
✅ **Tree Generation**: YANG tree visualization for model understanding  
✅ **Development Environment**: Automated setup with Python tooling  
✅ **BGP Focus**: Specialized support for BGP model validation and testing  

## Quick Start

```bash
# Clone with submodules
git clone --recursive <your-repo-url>
cd poma

# Setup environment
./setup-dev-env.sh

# Test BGP models
source venv/bin/activate
cd models && ./validate-bgp.sh
```

## What's Inside

- **Nokia BGP Models**: Fully functional SROS BGP models with tree generation
- **OpenConfig BGP Models**: Industry-standard BGP configuration models  
- **Validation Scripts**: Automated testing with multiple output formats
- **Development Tools**: Pre-configured Python environment with YANG tooling

## Documentation Sections

- **[Getting Started](getting-started/quick-start.md)**: Setup and first steps
- **[User Guide](user-guide/validation.md)**: Validation workflows and scripts
- **[Models](models/index.md)**: Available YANG models and their status
- **[Reference](reference/yang-tools.md)**: Tools and command documentation

!!! tip "New to YANG?"
    Start with the [Quick Start Guide](getting-started/quick-start.md) for a guided walkthrough of setting up your environment and running your first validation.

!!! warning "Repository Structure"
    This repository uses git submodules for vendor model sources. Always clone with `--recursive` flag or run `git submodule update --init --recursive` after cloning.
