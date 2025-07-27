# PoMa

For the cursed, and the fallen. We are forced to live with YANG, so let's make it tolerable.

A comprehensive collection of YANG models and validation tools for network automation and modeling.

## 🚀 Quick Start

```bash
## 🚀 Quick Start

**⚡ Fast automated setup (recommended):**
```bash
git clone https://github.com/friedsilicon/poma.git
cd poma
make setup    # Complete setup in ~30 seconds
make validate # Test everything
```

**🛠️ Manual setup:**
```bash
# Clone with submodules
git clone --recursive https://github.com/friedsilicon/poma.git
cd poma

# Setup environment  
./scripts/setup-dev-env.sh

# Test BGP models
source venv/bin/activate
./validate-bgp.sh -t
```

**🏗️ CI/Build optimized:**
```bash
git clone https://github.com/friedsilicon/poma.git
cd poma
./scripts/setup-submodules-fast.sh ci  # Ultra-fast ~10 seconds
```

## 📚 Documentation

**Full documentation is available [here](https://friedsilicon.github.io/poma)**

### 🔍 Model Comparisons (New!)
- **[BGP State Model Comparison](docs/models/bgp-state-comparison.md)** - Nokia vs OpenConfig for monitoring
- **[BGP Config Model Comparison](docs/models/bgp-config-comparison.md)** - Nokia vs OpenConfig for configuration

### 📖 Guides & References
- **[Getting Started](docs/getting-started/quick-start.md)** - Setup and first steps
- **[Validation Guide](docs/user-guide/validation.md)** - BGP model validation workflows  
- **[Models Overview](docs/models/index.md)** - Available YANG models and status
- **[Tools Reference](docs/reference/yang-tools.md)** - YANG tools and installation

## ✨ What's Included

- **Nokia BGP Models**: Latest SROS 25.7 models (state & configuration) with comprehensive BGP support
- **OpenConfig BGP Models**: Industry-standard BGP configuration models
- **Validation Scripts**: Automated testing with multiple output formats  
- **Development Tools**: Pre-configured Python environment with YANG tooling
- **Performance Optimizations**: Fast submodule setup (30s vs 5+ min traditional)

## 🆕 Recent Updates

- ✅ **Upgraded to Nokia SROS 25.7** - Latest version with newest BGP features
- ✅ **Added Configuration Models** - Both state and config models now available
- ✅ **Enhanced Documentation** - Comprehensive Nokia vs OpenConfig comparisons
- ✅ **Performance Improvements** - 90% faster setup with optimized submodule handling

## 📁 Repository Structure

```
├── models/                  # Organized YANG models (symlinks)
│   ├── nokia/              # Nokia SROS models
│   ├── openconfig/         # OpenConfig models
│   └── ietf/               # IETF standard types
├── scripts/                # Setup and utility scripts
├── docs/                   # Documentation (MkDocs)
├── requirements.txt        # All dependencies (YANG tools + docs)
├── open-config/            # OpenConfig submodule
└── nokia/                  # Nokia submodule
```

## 🛠️ Key Commands

```bash
# Validate all BGP models (from models/ directory)
cd models && ./validate-bgp.sh

# Nokia BGP with tree output
cd models && ./validate-nokia-bgp.sh -t

# Quiet mode for CI
./validate-bgp.sh -q

# Help for any script
cd models && ./validate-bgp.sh -h
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
