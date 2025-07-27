# YANG Tools Reference

Complete reference for YANG validation and processing tools used in this project.

## Core Tools

### pyang

Primary YANG validator, converter, and code generator.

#### Installation
```bash
pip install pyang
```

#### Common Usage
```bash
# Validate YANG model
pyang --strict model.yang

# Generate tree view
pyang -f tree model.yang

# Generate documentation
pyang -f html model.yang

# Multiple output formats
pyang -f jstree model.yang    # JSON tree
pyang -f yin model.yang       # YIN format
```

#### Key Options
- `--strict`: Enable strict validation
- `--path PATH`: Add directories to module search path
- `-f FORMAT`: Output format (tree, html, jstree, yin, etc.)
- `--help`: Show all available options

### libyang (Optional)

C library providing `yanglint` tools and Python bindings.

#### Installation

**macOS:**
```bash
brew install libyang
pip install libyang  # Python bindings
```

**Ubuntu/Debian:**
```bash
sudo apt install libyang-dev libyang-tools
pip install libyang  # Python bindings
```

#### Usage
```bash
# Validate with yanglint
yanglint model.yang

# Validate data against model
yanglint -s model.yang data.json
```

## Project Scripts

### Main Validation Scripts

| Script | Purpose | Options |
|--------|---------|---------|
| `validate-bgp.sh` | Validate all BGP models | All options supported |
| `validate-nokia-bgp.sh` | Nokia BGP validation | All options supported |
| `validate-openconfig-bgp.sh` | OpenConfig BGP validation | All options supported |

### Script Options Reference

| Option | Long Form | Description | Example |
|--------|-----------|-------------|---------|
| `-h` | `--help` | Show help message | `./validate-bgp.sh -h` |
| `-t` | `--tree` | Show tree structure | `./validate-bgp.sh -t` |
| `-e` | `--errors` | Show detailed errors | `./validate-bgp.sh -e` |
| `-l NUM` | `--lines NUM` | Tree lines to show | `./validate-bgp.sh -t -l 50` |
| `-q` | `--quiet` | Minimal output | `./validate-bgp.sh -q` |
| `-a` | `--all` | All checks (tree + errors) | `./validate-bgp.sh -a` |

### Setup Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `scripts/setup-dev-env.sh` | Setup Python environment | `./scripts/setup-dev-env.sh` |
| `scripts/setup-bgp-models.sh` | Create model symlinks | `./scripts/setup-bgp-models.sh` |

## Advanced Usage

### Custom Validation

```bash
# Validate with custom search paths
pyang --strict --path types:common:ietf model.yang

# Validate multiple models
pyang --strict *.yang

# Generate trees for documentation
pyang -f tree --tree-line-length 80 model.yang
```

### Error Analysis

```bash
# Show detailed errors
pyang --strict --verbose model.yang

# Check specific warnings
pyang --strict --lint model.yang

# Validate imports only
pyang --strict --check-import-modules model.yang
```

### Output Formats

```bash
# Tree formats
pyang -f tree model.yang              # ASCII tree
pyang -f jstree model.yang            # JSON tree

# Documentation formats  
pyang -f html model.yang              # HTML documentation
pyang -f html --html-no-path model.yang  # Clean HTML

# Code generation
pyang -f yang model.yang              # Canonical YANG
pyang -f yin model.yang               # YIN XML format
```

## Environment Management

### Virtual Environment

```bash
# Create environment
python -m venv venv

# Activate (always required)
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements-dev.txt

# Deactivate when done
deactivate
```

### Search Paths

YANG models often depend on other modules. Use search paths to help pyang find dependencies:

```bash
# Single path
pyang --path types model.yang

# Multiple paths
pyang --path types:common:ietf model.yang

# Relative paths from model directory
pyang --path ../types:../common model.yang
```

## Troubleshooting

### Common Issues

**"module not found in search path"**
```bash
# Add missing directories to path
pyang --path types:common:vendor-specific model.yang
```

**"circular dependency"**
```bash
# This usually indicates a fundamental model architecture issue
# Try validating submodules individually
```

**"pyang command not found"**
```bash
# Ensure virtual environment is activated
source venv/bin/activate
```

### Debug Options

```bash
# Verbose output
pyang --verbose model.yang

# Show import tree
pyang --print-all-imports model.yang

# Lint checks
pyang --lint model.yang
```

## Integration with IDEs

### VS Code

Install the YANG extension for syntax highlighting and basic validation:
- Search for "YANG" in extensions
- Provides syntax highlighting and basic error detection

### Vim/Neovim

Add YANG syntax highlighting:
```vim
" Add to .vimrc
autocmd BufRead,BufNewFile *.yang set filetype=yang
```

## Next Steps

- **[Command Reference](command-reference.md)**: Complete command documentation
- **[Validation Guide](../user-guide/validation.md)**: Practical validation workflows
