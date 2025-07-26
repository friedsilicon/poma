# YANG Modelling

For the cursed, and the fallen. We are forced to live with YANG, so let's make it tolerable.

A comprehensive collection of YANG models and validation tools for network automation and modeling.

## 🚀 Quick Start

```bash
# Clone with submodules
git clone --recursive <your-repo-url>
cd yang-modelling

# Setup environment
./setup-dev-env.sh

# Test BGP models
source venv/bin/activate
cd models && ./validate-bgp.sh -t
```

## 📚 Documentation

**Full documentation is available [here](https://shiva.github.io/yang-modelling)**

- **[Getting Started](docs/getting-started/quick-start.md)** - Setup and first steps
- **[Validation Guide](docs/user-guide/validation.md)** - BGP model validation workflows  
- **[Models Overview](docs/models/index.md)** - Available YANG models and status
- **[Tools Reference](docs/reference/yang-tools.md)** - YANG tools and installation

## ✨ What's Included

- **Nokia BGP Models**: Fully functional SROS BGP models with tree generation
- **OpenConfig BGP Models**: Industry-standard BGP configuration models
- **Validation Scripts**: Automated testing with multiple output formats  
- **Development Tools**: Pre-configured Python environment with YANG tooling

## 📁 Repository Structure

```
├── models/                  # Organized YANG models (symlinks)
│   ├── nokia/              # Nokia SROS models
│   ├── openconfig/         # OpenConfig models
│   └── ietf/               # IETF standard types
├── docs/                   # Documentation (MkDocs)
├── requirements.txt        # All dependencies (YANG tools + docs)
├── open-config/            # OpenConfig submodule
└── nokia/                  # Nokia submodule
```

## 🛠️ Key Commands

```bash
# Validate all BGP models
./validate-bgp.sh

# Nokia BGP with tree output
./validate-nokia-bgp.sh -t

# Quiet mode for CI
./validate-bgp.sh -q

# Help for any script
./validate-bgp.sh -h
```

## 📖 Local Documentation

```bash
# Install all dependencies (includes docs tools)
pip install -r requirements.txt

# Serve docs locally
mkdocs serve
# Visit: http://localhost:8000
```

## 🤝 Contributing

1. Add new YANG sources as git submodules
2. Update documentation in `docs/`
3. Add validation scripts as needed
4. Test with existing validation workflows

---

*"In the grim darkness of network management, there is only YANG."*
