# Additional YANG Tools Installation

This document covers installation of YANG tools that aren't available via pip.

## libyang (C library and tools)

The libyang library provides `yanglint` command-line tools and also enables Python bindings via the `libyang` PyPI package.

### macOS
```bash
# Using Homebrew (installs both library and yanglint tool)
brew install libyang

# Verify installation
yanglint --version
```

### Ubuntu/Debian
```bash
# Install both tools and development headers (needed for Python bindings)
sudo apt-get update
sudo apt-get install libyang-tools libyang-dev python3-dev gcc python3-cffi

# Verify installation
yanglint --version
```

### Other Linux Distributions
```bash
# CentOS/RHEL/Fedora
sudo yum install libyang-tools libyang-devel python3-devel gcc
# or
sudo dnf install libyang-tools libyang-devel python3-devel gcc

# Arch Linux
sudo pacman -S libyang python-cffi gcc
```

### Python Bindings (Optional)

After installing the system libyang library and headers, you can install Python bindings:

```bash
# Activate your virtual environment first
source venv/bin/activate

# Install Python bindings (requires system libyang)
pip install libyang
```

**Note**: The Python `libyang` package requires:
- System-level libyang C library and headers
- Python development headers
- GCC compiler
- CFFI library

If you get build errors, ensure all system dependencies are installed first.

## yanggui (YANG GUI Tool)

A graphical tool for visualizing YANG models.

### Installation
Since this is not widely packaged, you may need to build from source:

```bash
# Clone the repository
git clone https://github.com/alliedtelesis/yanggui.git
cd yanggui

# Follow the build instructions in their README
# (typically requires Qt and other dependencies)
```

### Alternative GUI Tools
- **YANG Explorer** - Web-based YANG browser
- **Visual Studio Code** - With YANG language extensions
- **pyang** with HTML output - `pyang -f jstree model.yang -o model.html`

## Verification

After installation, test the tools:

```bash
# Test pyang (should be installed via pip)
pyang --version

# Test yanglint (if installed)
yanglint --version

# Test validation
cd models
pyang --strict --path nokia/types:ietf:nokia/bgp nokia/bgp/nokia-state.yang
```

## Notes

- **pyang** is the primary tool and handles most YANG validation needs
- **yanglint** provides additional features and different validation approaches
- **GUI tools** are optional but helpful for model exploration
- All examples in this repository work with just `pyang`
