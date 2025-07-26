# BGP Model Validation

Learn how to validate YANG models with flexible options and output formats.

## Available Scripts

| Script | Purpose | Focus |
|--------|---------|-------|
| `validate-bgp.sh` | Main validation script | All vendors |
| `validate-nokia-bgp.sh` | Nokia-specific validation | Nokia SROS |
| `validate-openconfig-bgp.sh` | OpenConfig-specific validation | OpenConfig |

## Command Options

All validation scripts support the same command-line options:

| Option | Description | Example |
|--------|-------------|---------|
| `-h, --help` | Show help message | `./validate-bgp.sh -h` |
| `-t, --tree` | Show BGP tree structure | `./validate-bgp.sh -t` |
| `-e, --errors` | Show detailed error messages | `./validate-bgp.sh -e` |
| `-l, --lines NUM` | Number of tree lines to show (default: 20) | `./validate-bgp.sh -t -l 50` |
| `-q, --quiet` | Quiet mode - minimal output | `./validate-bgp.sh -q` |
| `-a, --all` | Run all validation checks (includes tree and errors) | `./validate-bgp.sh -a` |

## Validation Workflows

### Development Workflow

For active development and debugging:

```bash
# Full validation with tree and errors
./validate-bgp.sh -a

# Focus on specific vendor with extended tree
./validate-nokia-bgp.sh -t -l 50

# Debug specific failures
./validate-openconfig-bgp.sh -e
```

### CI/Automation Workflow

For automated testing and scripts:

```bash
# Quiet mode - only shows pass/fail
./validate-bgp.sh -q

# Check exit code for automation
if ./validate-nokia-bgp.sh -q; then
    echo "Nokia BGP models passed"
else
    echo "Nokia BGP models failed"
fi
```

### Documentation Workflow

For generating documentation or examples:

```bash
# Generate tree structure for documentation
./validate-nokia-bgp.sh -t -l 100 > nokia-bgp-tree.txt

# Capture validation status
./validate-bgp.sh > validation-report.txt
```

## Understanding Output

### Validation Status

- ✅ **VALID**: Model passes all pyang validation checks
- ❌ **FAILED**: Model has validation errors  
- ⚠️ **PARTIAL**: Model has some issues but core functionality works

### Tree Output

Tree output shows the YANG model structure:

```
module: nokia-state
  +--ro state
     +--ro router
        +--ro router-instance* [router-name]
           +--ro router-name    string
           +--ro bgp
              +--ro convergence
              |  +--ro family* [family-type]
              |     +--ro family-type                  enumeration
```

Legend:
- `+--ro`: Read-only data
- `+--rw`: Read-write configuration
- `*`: List entries
- `?`: Optional elements

### Error Messages

Error messages help identify missing dependencies:

```
nokia/router/nokia-state-router-l2tp.yang:10: error: module "nokia-types-l2tp" not found in search path
```

This indicates a missing module dependency that would need to be added as a symlink.

## Manual Validation

For advanced use cases, you can run pyang directly:

```bash
# Validate specific model
pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang

# Generate tree for specific model
pyang -f tree --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang

# Different output formats
pyang -f jstree nokia/bgp/nokia-state-router-bgp.yang  # JSON tree
pyang -f yin nokia/bgp/nokia-state-router-bgp.yang     # YIN format
```

## Next Steps

- **[Models Overview](models-overview.md)**: Understand available models and their status
- **[Scripts Reference](scripts-reference.md)**: Complete script documentation
- **[Command Reference](../reference/command-reference.md)**: All available commands
