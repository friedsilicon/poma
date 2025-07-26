# Contributing

Guidelines for contributing to the YANG Modelling workspace.

## Overview

We welcome contributions to improve YANG model validation, add new vendor support, enhance documentation, and fix issues. This guide outlines the contribution process and standards.

## Getting Started

### Development Setup

1. **Fork and clone the repository:**
   ```bash
   git clone https://github.com/yourusername/yang-modelling.git
   cd yang-modelling
   ```

2. **Set up development environment:**
   ```bash
   ./setup-dev-env.sh
   source venv/bin/activate
   ```

3. **Initialize models:**
   ```bash
   ./setup-bgp-models.sh
   ```

4. **Verify setup:**
   ```bash
   ./validate-bgp.sh -q
   ```

### Development Dependencies

Additional tools for contributors:
```bash
pip install black flake8 mypy pre-commit
pre-commit install
```

## Contribution Types

### 1. Adding New YANG Models

**When to contribute:**
- New vendor model support
- Additional protocol models (OSPF, ISIS, etc.)
- Updated model versions

**Process:**
1. Add vendor models as git submodules
2. Create symlink organization scripts
3. Develop validation scripts
4. Update documentation
5. Add tests

**Example - Adding Cisco Models:**
```bash
# 1. Add submodule
git submodule add https://github.com/YangModels/yang.git yang-models-cisco

# 2. Create symlinks
mkdir -p models/cisco
ln -sf ../../yang-models-cisco/vendor/cisco/xe/... models/cisco/

# 3. Create validation script
cp validate-nokia-bgp.sh validate-cisco-bgp.sh
# Modify for Cisco-specific paths and models

# 4. Update documentation
# Add docs/models/cisco.md
# Update docs/user-guide/models-overview.md
```

### 2. Improving Validation Scripts

**Areas for improvement:**
- Better error reporting
- Performance optimization
- Additional output formats
- Cross-vendor comparison features

**Script guidelines:**
- Use consistent option parsing (`-t`, `-q`, `-h`)
- Provide meaningful error messages
- Support both interactive and CI usage
- Include usage examples in help text

### 3. Documentation Updates

**Documentation standards:**
- Use clear, concise language
- Provide working examples
- Include troubleshooting sections
- Update navigation in `mkdocs.yml`

**Structure:**
```
docs/
├── getting-started/    # Setup and basics
├── user-guide/        # Usage documentation  
├── models/            # Model-specific docs
├── development/       # Contributor guides
└── reference/         # Command references
```

### 4. Bug Fixes and Improvements

**Common areas:**
- Symlink resolution issues
- Dependency management
- Cross-platform compatibility
- GitHub Actions workflow improvements

## Code Standards

### Shell Scripts

**Style guidelines:**
```bash
#!/bin/bash
# validate-example.sh
# Description of script purpose

set -euo pipefail  # Strict error handling

# Constants
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly MODEL_DIR="${SCRIPT_DIR}/models"

# Functions
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -t, --tree      Generate tree output
    -q, --quiet     Quiet mode (errors only)
    -h, --help      Show this help

Examples:
    $0              # Basic validation
    $0 --tree       # With tree output
    $0 -q           # Quiet mode
EOF
}

# Main function
main() {
    # Implementation
}

# Parse options and run
main "$@"
```

**Requirements:**
- Use `set -euo pipefail` for error handling
- Include usage functions with examples
- Use readonly variables for constants
- Provide meaningful error messages
- Support standard options (`-h`, `-q`, `-t`)

### Python Code

**For any Python utilities:**
```python
#!/usr/bin/env python3
"""Module docstring describing purpose."""

import sys
from pathlib import Path
from typing import List, Optional

def main() -> int:
    """Main function with return code."""
    try:
        # Implementation
        return 0
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1

if __name__ == "__main__":
    sys.exit(main())
```

**Standards:**
- Use type hints
- Include docstrings
- Follow PEP 8 style guide
- Use pathlib for file operations
- Proper error handling with exit codes

### Documentation

**Markdown standards:**
- Use meaningful headings (H1 for title, H2 for sections)
- Include code examples with syntax highlighting
- Use tables for structured information
- Add cross-references to related documentation
- Include working examples that can be copy-pasted

**MkDocs integration:**
- Update navigation in `mkdocs.yml`
- Use Material theme features (admonitions, tabs)
- Test locally with `mkdocs serve`

## Testing Guidelines

### Validation Testing

**Before submitting changes:**
```bash
# Test all validation scripts
./validate-bgp.sh -q
./validate-nokia-bgp.sh -q
./validate-openconfig-bgp.sh -q

# Test with different output modes
./validate-bgp.sh -t
./validate-bgp.sh -v

# Test error handling
./validate-bgp.sh --invalid-option  # Should show usage
```

### Documentation Testing

```bash
# Test documentation build
mkdocs build --strict

# Test links
mkdocs serve &
# Visit http://localhost:8000 and test navigation

# Test GitHub Pages deployment locally
mkdocs gh-deploy --dry-run
```

### Cross-Platform Testing

If possible, test on multiple platforms:
- **Linux** - Primary development platform
- **macOS** - Common developer platform  
- **Windows** - Using WSL or Git Bash

## Submission Process

### 1. Prepare Changes

```bash
# Create feature branch
git checkout -b feature/new-vendor-support

# Make changes
# ... implement your contribution ...

# Test thoroughly
./validate-bgp.sh -q
mkdocs build --strict

# Commit changes
git add .
git commit -m "Add Cisco BGP model support

- Add cisco-bgp model symlinks
- Create validate-cisco-bgp.sh script  
- Add Cisco documentation
- Update models overview"
```

### 2. Update Documentation

**Required updates:**
- Model-specific documentation (if adding models)
- Update `docs/user-guide/models-overview.md`
- Update scripts reference if adding validation scripts
- Add troubleshooting notes for new features

### 3. Create Pull Request

**PR Guidelines:**
- **Title:** Clear, descriptive summary
- **Description:** Explain the problem and solution
- **Changes:** List all files changed and why
- **Testing:** Describe testing performed
- **Breaking changes:** Note any compatibility issues

**PR Template:**
```markdown
## Description
Brief description of changes and motivation.

## Changes
- [ ] Added new vendor model support
- [ ] Updated validation scripts
- [ ] Updated documentation
- [ ] Added tests

## Testing
- [ ] All existing validation scripts pass
- [ ] New scripts work with sample configurations
- [ ] Documentation builds without errors
- [ ] Cross-platform testing completed

## Breaking Changes
None / List any breaking changes

## Related Issues
Fixes #123
```

### 4. Review Process

**Review criteria:**
- Code follows project standards
- Documentation is complete and accurate
- Tests pass and cover new functionality
- No breaking changes without justification
- Follows security best practices

**Addressing feedback:**
```bash
# Make requested changes
git add .
git commit -m "Address PR feedback: fix script permissions"

# Push updates
git push origin feature/new-vendor-support
```

## Release Process

### Version Management

**Versioning scheme:**
- **Major (X.0.0)** - Breaking changes, major new features
- **Minor (1.X.0)** - New features, backward compatible
- **Patch (1.1.X)** - Bug fixes, documentation updates

### Release Checklist

For maintainers preparing releases:

1. **Update version references**
2. **Test all validation scripts**  
3. **Update CHANGELOG.md**
4. **Tag release**
5. **Update documentation**
6. **Verify GitHub Pages deployment**

## Community Guidelines

### Code of Conduct

- **Be respectful** in all interactions
- **Be constructive** when providing feedback
- **Be patient** with new contributors
- **Focus on the technical** aspects of contributions

### Communication

- **GitHub Issues** - Bug reports, feature requests
- **Pull Requests** - Code review and discussion
- **Discussions** - General questions and ideas

### Recognition

Contributors are recognized in:
- README.md acknowledgments
- Release notes for significant contributions
- Documentation authorship

## Getting Help

### For Contributors

**Before asking:**
1. Check existing documentation
2. Search closed issues and PRs
3. Test with a minimal example

**When asking for help:**
- Provide context and environment details
- Include relevant error messages
- Share what you've already tried

**Resources:**
- [Troubleshooting Guide](../getting-started/troubleshooting.md)
- [Project Structure](project-structure.md)
- [GitHub Issues](https://github.com/yourusername/yang-modelling/issues)

### For Maintainers

**Maintainer responsibilities:**
- Review PRs promptly and constructively
- Maintain project standards and consistency
- Update dependencies and submodules regularly
- Keep documentation current
- Foster welcoming community environment

## Thank You

Thank you for contributing to the YANG Modelling workspace! Your contributions help make network automation more accessible and reliable for everyone.

## Related Documentation

- [Project Structure](project-structure.md) - Codebase organization
- [Adding Models](adding-models.md) - Detailed model integration guide
- [Troubleshooting](../getting-started/troubleshooting.md) - Common issues
- [Scripts Reference](../user-guide/scripts-reference.md) - Validation tools
