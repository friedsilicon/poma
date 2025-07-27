# Available YANG Models

This section provides detailed information about the YANG models available in this repository.

## 📊 Model Comparisons

### Comprehensive Comparisons
- **[BGP State Model Comparison](bgp-state-comparison.md)** - Nokia vs OpenConfig state models for monitoring
- **[BGP Configuration Model Comparison](bgp-config-comparison.md)** - Nokia vs OpenConfig config models for management

### Individual Model Details
- **[Nokia Models Overview](nokia.md)** - Nokia SROS-specific model details
- **[OpenConfig Models Overview](openconfig.md)** - OpenConfig model details
- **[Assessment](assessment.md)** - Current implementation status

## Quick Status Overview

### Nokia SROS 25.7 (Latest)

| Model Type | Status | Notes |
|------------|--------|-------|
| **BGP Types** | ✅ **Fully Validated** | Standalone validation works |
| **BGP State Models** | ✅ Available | Complex dependencies (expected) |
| **BGP Config Models** | ✅ Available | Complex dependencies (expected) |
| **Extensions** | ✅ **Fully Validated** | SROS YANG extensions validated |

### OpenConfig

| Model Type | Status | Notes |
|------------|--------|-------|
| **BGP Types** | ✅ **Fully Validated** | Standalone validation works |
| **BGP Main Models** | ✅ Available | Complex dependencies (expected) |
| **Extensions** | ✅ **Fully Validated** | OpenConfig extensions validated |
| **Policy Models** | ✅ Available | Complex dependencies (expected) |

## Getting Started

1. **Quick Setup**: Run `make setup` for complete environment
2. **Validation**: Run `./validate-bgp.sh` from the `models/` directory  
3. **Detailed Analysis**: Review the comparison documents above
4. **Model Exploration**: Use `pyang -f tree` commands for structure analysis

## Key Improvements

- ✅ **Latest Nokia Version**: Now using SROS 25.7 (latest available)
