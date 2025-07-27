# Command Reference

Complete reference for YANG tools and commands used in the workspace.

## YANG Validation Tools

### pyang

**Description:** Primary YANG parser and validator  
**Version:** 2.5.0+  
**Documentation:** [pyang GitHub](https://github.com/mbj4668/pyang)

#### Basic Validation

```bash
# Validate single model
pyang model.yang

# Validate with dependencies
pyang --path=models/nokia:models/ietf models/nokia/nokia-sr-bgp.yang

# Strict validation
pyang --strict model.yang
```

#### Output Formats

```bash
# Tree structure (most common)
pyang --format=tree model.yang

# Tree with annotations
pyang --format=tree --tree-line-length=120 model.yang

# HTML documentation
pyang --format=jstree model.yang > model-doc.html

# UML diagram
pyang --format=uml model.yang > model.uml

# YANG canonical format
pyang --format=yang model.yang

# Sample XML configuration
pyang --format=sample-xml-skeleton model.yang

# XPath expressions  
pyang --format=xpath model.yang

# Dependency information
pyang --format=depend model.yang
```

#### Common Options

| Option | Description | Example |
|--------|-------------|---------|
| `--path=PATH` | Set module search path | `--path=models/nokia:models/ietf` |
| `--format=FORMAT` | Output format | `--format=tree` |
| `--output=FILE` | Output to file | `--output=tree.txt` |
| `--strict` | Strict validation mode | `--strict` |
| `--max-line-length=N` | Max line length for tree format | `--max-line-length=120` |
| `--tree-line-length=N` | Tree display width | `--tree-line-length=80` |
| `--print-error-code` | Include error codes | `--print-error-code` |
| `--ignore-error=CODE` | Ignore specific errors | `--ignore-error=UNUSED_IMPORT` |
| `--verbose` | Verbose output | `--verbose` |

#### Error Handling

```bash
# Validate with error codes
pyang --print-error-code model.yang

# Ignore specific warnings
pyang --ignore-error=UNUSED_IMPORT model.yang

# Treat warnings as errors
pyang --strict model.yang
```

#### Advanced Usage

```bash
# Multiple models
pyang models/nokia/*.yang

# Plugin usage
pyang --plugin=tools.yang2dsdl --dsdl model.yang

# Version-specific validation
pyang --yang-version=1.1 model.yang

# Custom error format
pyang --error-format='%(filename)s:%(line)s: %(level)s: %(msg)s' model.yang
```

### yanglint

**Description:** Alternative YANG validator from libyang  
**Version:** 2.0.0+  
**Documentation:** [libyang GitHub](https://github.com/CESNET/libyang)

#### Basic Usage

```bash
# Validate model
yanglint model.yang

# Validate with data
yanglint -s model.yang data.xml

# Validate JSON data
yanglint -s -t config model.yang data.json
```

#### Output Formats

```bash
# Tree format
yanglint -f tree model.yang

# Info format
yanglint -f info model.yang

# Schema validation
yanglint -s model.yang
```

#### Data Validation

```bash
# Validate XML configuration
yanglint -s model.yang config.xml

# Validate JSON configuration
yanglint -s -t config model.yang config.json

# Validate with specific data type
yanglint -s -t data model.yang operational-data.json
```

### pyangbind

**Description:** Generate Python bindings from YANG models  
**Version:** 0.8.0+  
**Documentation:** [pyangbind GitHub](https://github.com/robshakir/pyangbind)

#### Basic Usage

```bash
# Generate Python bindings
pyangbind --output=bindings.py model.yang

# Generate with specific options
pyangbind --output=bindings.py --use-xpathhelper model.yang
```

#### Generated Code Usage

```python
#!/usr/bin/env python3
import bindings

# Create instance
config = bindings.model()

# Set values
config.interface['eth0'].description = "Management interface"
config.interface['eth0'].enabled = True

# Serialize to JSON
print(config.dumps())
```

## Network Automation Tools

### netconf-console

**Description:** NETCONF client for testing  
**Installation:** `pip install ncclient`

#### Basic Operations

```bash
# Get configuration
netconf-console --host=router --user=admin --get-config

# Edit configuration
netconf-console --host=router --user=admin --edit-config=config.xml

# Validate configuration
netconf-console --host=router --user=admin --validate
```

### ncclient (Python)

**Description:** Python NETCONF client library

```python
from ncclient import manager

# Connect to device
with manager.connect(host='router', username='admin', password='pass', 
                    hostkey_verify=False) as m:
    # Get configuration
    config = m.get_config(source='running').data
    print(config)
    
    # Send configuration
    m.edit_config(target='candidate', config=new_config)
    m.commit()
```

## Documentation Tools

### mkdocs

**Description:** Documentation site generator  
**Version:** 1.5.0+

#### Basic Commands

```bash
# Serve documentation locally
mkdocs serve

# Build static site
mkdocs build

# Build with strict mode (warnings as errors)  
mkdocs build --strict

# Deploy to GitHub Pages
mkdocs gh-deploy
```

#### Configuration

```yaml
# mkdocs.yml
site_name: Documentation
theme:
  name: material
plugins:
  - search
  - git-revision-date-localized
markdown_extensions:
  - admonition
  - pymdownx.superfences
```

### pandoc

**Description:** Document format converter

```bash
# Convert YANG to markdown documentation
pandoc --from=yang --to=markdown model.yang > model.md

# Convert markdown to PDF
pandoc --from=markdown --to=pdf documentation.md -o documentation.pdf
```

## Development Tools

### Git Submodules

#### Basic Operations

```bash
# Add submodule
git submodule add https://github.com/vendor/yang-models.git vendor-models

# Initialize submodules
git submodule update --init --recursive

# Update submodules
git submodule update --remote

# Update specific submodule
git submodule update --remote vendor-models
```

#### Advanced Operations

```bash
# Shallow clone submodules
git submodule update --init --recursive --depth 1

# Parallel submodule operations
git submodule update --init --recursive --jobs 4

# Submodule status
git submodule status

# Remove submodule
git submodule deinit vendor-models
git rm vendor-models
```

### Python Virtual Environments

#### Creation and Management

```bash
# Create virtual environment
python3 -m venv venv

# Activate environment
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows

# Deactivate environment
deactivate

# Install requirements
pip install -r requirements.txt

# Freeze current packages
pip freeze > requirements.txt
```

### Code Quality Tools

#### black (Python formatter)

```bash
# Format Python code
black script.py

# Check without changes
black --check script.py

# Format entire directory
black .
```

#### flake8 (Python linter)

```bash
# Lint Python code
flake8 script.py

# With specific configuration
flake8 --max-line-length=88 script.py

# Ignore specific errors
flake8 --ignore=E203,W503 script.py
```

#### shellcheck (Shell script linter)

```bash
# Check shell script
shellcheck script.sh

# Check with specific shell
shellcheck --shell=bash script.sh

# Output format
shellcheck --format=json script.sh
```

## Validation Command Patterns

### Standard Validation Workflow

```bash
# 1. Setup environment
./scripts/setup-dev-env.sh
source venv/bin/activate

# 2. Initialize models
./scripts/setup-bgp-models.sh

# 3. Basic validation
./validate-bgp.sh -q

# 4. Detailed analysis
./validate-nokia-bgp.sh -t
./validate-openconfig-bgp.sh -t

# 5. Generate documentation
pyang --format=jstree models/nokia/nokia-sr-bgp.yang > nokia-bgp-tree.html
```

### CI/CD Validation

```bash
#!/bin/bash
# ci-validate.sh

set -euo pipefail

echo "Setting up environment..."
./scripts/setup-dev-env.sh
source venv/bin/activate

echo "Validating models..."
./validate-bgp.sh -q || exit 1
./validate-nokia-bgp.sh -q || exit 1  
./validate-openconfig-bgp.sh -q || exit 1

echo "Building documentation..."
mkdocs build --strict || exit 1

echo "All validations passed!"
```

### Debugging Validation Issues

```bash
# Verbose validation
./validate-bgp.sh -v

# Check specific model
pyang --print-error-code --path=models/nokia:models/ietf models/nokia/nokia-sr-bgp.yang

# Debug import issues
pyang --format=depend models/nokia/nokia-sr-bgp.yang

# Check symlinks
find models/ -type l ! -exec test -e {} \; -print

# Verify model syntax
pyang --strict models/nokia/nokia-sr-bgp.yang
```

## Utility Scripts

### Model Analysis

```bash
#!/bin/bash
# analyze-model.sh

MODEL="$1"

echo "Analyzing model: $MODEL"
echo

# Basic information
echo "=== Model Information ==="
pyang --format=info "$MODEL"

echo
echo "=== Dependencies ==="
pyang --format=depend "$MODEL"

echo  
echo "=== Tree Structure ==="
pyang --format=tree --tree-line-length=120 "$MODEL"

echo
echo "=== XPath Expressions ==="
pyang --format=xpath "$MODEL" | head -20
```

### Batch Validation

```bash
#!/bin/bash
# batch-validate.sh

find models/ -name "*.yang" | while read -r model; do
    echo -n "Validating $(basename "$model")... "
    if pyang "$model" >/dev/null 2>&1; then
        echo "✓"
    else
        echo "✗"
        pyang "$model" 2>&1 | head -3
    fi
done
```

### Model Comparison

```bash
#!/bin/bash
# compare-models.sh

MODEL1="$1"
MODEL2="$2"

echo "Comparing models:"
echo "  Model 1: $MODEL1"
echo "  Model 2: $MODEL2"
echo

# Generate trees for comparison
pyang --format=tree "$MODEL1" > /tmp/model1.tree
pyang --format=tree "$MODEL2" > /tmp/model2.tree

# Show differences
echo "=== Structural Differences ==="
diff -u /tmp/model1.tree /tmp/model2.tree || true

# Cleanup
rm -f /tmp/model1.tree /tmp/model2.tree
```

## Environment Variables

### Path Configuration

```bash
# YANG module search paths
export YANG_MODPATH="models/nokia:models/openconfig:models/ietf"

# Python path for custom tools
export PYTHONPATH="$PWD/tools:$PYTHONPATH"

# Documentation configuration
export MKDOCS_CONFIG_FILE="mkdocs.yml"
```

### Tool Configuration

```bash
# pyang configuration
export PYANG_PLUGINPATH="$HOME/.local/lib/python3.x/site-packages/pyang/plugins"

# yanglint configuration
export YANGLINT_SEARCHPATH="models/"

# Editor configuration for YANG files
export EDITOR="code"  # VS Code
export YANG_EDITOR_ARGS="--syntax=yang"
```

## Common Command Combinations

### Complete Model Validation

```bash
# Comprehensive validation pipeline
validate_complete() {
    local model="$1"
    
    echo "=== Syntax Validation ==="
    pyang --strict "$model"
    
    echo "=== Dependency Check ==="
    pyang --format=depend "$model"
    
    echo "=== Tree Generation ==="
    pyang --format=tree "$model"
    
    echo "=== Alternative Validation ==="
    yanglint "$model"
}
```

### Documentation Generation

```bash
# Generate complete documentation
generate_docs() {
    local model="$1"
    local output_dir="$2"
    
    mkdir -p "$output_dir"
    
    # HTML tree
    pyang --format=jstree "$model" > "$output_dir/tree.html"
    
    # Sample XML
    pyang --format=sample-xml-skeleton "$model" > "$output_dir/sample.xml"
    
    # XPath reference
    pyang --format=xpath "$model" > "$output_dir/xpath.txt"
    
    # UML diagram
    pyang --format=uml "$model" > "$output_dir/diagram.uml"
}
```

### Model Development Workflow

```bash
# Development workflow for new models
develop_model() {
    local vendor="$1"
    
    # Setup
    ./scripts/setup-dev-env.sh
    source venv/bin/activate
    
    # Create symlinks
    ./scripts/setup-bgp-models.sh
    
    # Validate
    "./validate-${vendor}-bgp.sh" -v
    
    # Generate docs
    mkdocs serve &
    
    echo "Development environment ready for $vendor"
    echo "Documentation available at: http://localhost:8000"
}
```

## Related Documentation

- [Scripts Reference](../user-guide/scripts-reference.md) - Workspace-specific scripts
- [YANG Tools Guide](yang-tools.md) - Installation and setup
- [Validation Workflows](../user-guide/validation.md) - Testing procedures
- [Troubleshooting](../getting-started/troubleshooting.md) - Common issues
