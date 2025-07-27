# Nokia Models

Comprehensive documentation for Nokia SROS YANG models in the workspace.

## Overview

Nokia SROS (Service Router Operating System) provides YANG models for network configuration and management. This workspace includes the core BGP-related models and their dependencies.

**Source Repository:** [Nokia 7x50 YANG Models](https://github.com/nokia/7x50-YangModels)  
**Local Path:** `nokia/`  
**Symlink Location:** `models/nokia/`  
**Version:** **SROS 25.7 (Latest)**

## 🆕 Latest Updates

- ✅ **Upgraded to SROS 25.7** - Latest Nokia version with newest BGP features
- ✅ **Added Configuration Models** - Both state and configuration models available
- ✅ **Enhanced Validation** - Improved validation with proper dependencies
- ✅ **Better Organization** - Cleaner model structure and documentation

## Available Models

### BGP State Models (Monitoring & Telemetry)

#### `nokia-state-router-bgp.yang`
**Description:** BGP operational state model for monitoring and telemetry  
**Location:** `models/nokia/bgp/nokia-state-router-bgp.yang`  
**Version:** SROS 25.7  
**Status:** ✅ Validated (types), ⚠️ Complex dependencies (expected)

**Key Features:**
- BGP neighbor operational state
- BGP session statistics and counters
- Route table information
- BGP policy application state
- Performance metrics and monitoring data

#### `nokia-state.yang`
**Description:** Main Nokia state model (includes BGP submodule)  
**Location:** `models/nokia/common/nokia-state.yang`  
**Version:** SROS 25.7  
**Status:** ⚠️ Complex dependencies (expected for full model)

### BGP Configuration Models (Device Management)

#### `nokia-conf-router-bgp.yang`
**Description:** BGP configuration model for device configuration  
**Location:** `models/nokia/config/nokia-conf-router-bgp.yang`  
**Version:** SROS 25.7  
**Status:** ✅ Available, ⚠️ Complex dependencies (expected)

**Key Features:**
- BGP global configuration
- Neighbor configuration and policies  
- Route filtering and redistribution
- BGP communities and extended communities
- Multi-protocol BGP support (IPv4, IPv6, VPN)
- Administrative state controls

**For detailed configuration examples and comparisons with OpenConfig, see [BGP Configuration Model Comparison](bgp-config-comparison.md).**

#### `nokia-conf.yang`
**Description:** Main Nokia configuration model (includes BGP submodule)  
**Location:** `models/nokia/config/nokia-conf.yang`  
**Version:** SROS 25.7  
**Status:** ⚠️ Complex dependencies (expected for full model)

## Type Definitions (Standalone & Validated)

#### `nokia-types-bgp.yang`
**Description:** BGP-specific type definitions  
**Location:** `models/nokia/types/nokia-types-bgp.yang`  
**Version:** SROS 25.7  
**Status:** ✅ **Fully Validated**

#### `nokia-sros-yang-extensions.yang`
**Description:** Nokia SROS YANG extensions and annotations  
**Location:** `models/nokia/types/nokia-sros-yang-extensions.yang`  
**Version:** SROS 25.7  
**Status:** ✅ **Fully Validated**

## Quick Reference

### File Locations
```
models/nokia/
├── bgp/                    # BGP state models
│   └── nokia-state-router-bgp.yang
├── config/                 # BGP configuration models  
│   ├── nokia-conf-router-bgp.yang
│   └── nokia-conf.yang
├── common/                 # Common state models
│   ├── nokia-state.yang
│   └── nokia-state-router.yang
└── types/                  # Type definitions
    ├── nokia-types-bgp.yang
    └── nokia-sros-yang-extensions.yang
```

### Validation Status
- ✅ **Types and Extensions**: Fully validated standalone
- ✅ **State Models**: Available with expected complex dependencies
- ✅ **Configuration Models**: Available with expected complex dependencies
- ✅ **Version**: Latest SROS 25.7

### Usage Examples
```bash
# Validate Nokia BGP types (works standalone)
pyang --strict --path nokia/types:ietf nokia/types/nokia-types-bgp.yang

# Analyze Nokia BGP state structure  
pyang -f tree --tree-depth 3 nokia/bgp/nokia-state-router-bgp.yang

# Analyze Nokia BGP config structure
pyang -f tree --tree-depth 3 nokia/config/nokia-conf-router-bgp.yang
```

## Detailed Analysis

For comprehensive analysis and comparisons:
- **[BGP State Model Comparison](bgp-state-comparison.md)** - State models for monitoring
- **[BGP Configuration Model Comparison](bgp-config-comparison.md)** - Configuration models for management

## Model Dependencies

Nokia BGP models have several dependencies that are automatically handled by the project setup:

### Required Dependencies
**IETF Standards:**
- `ietf-yang-types.yang` - Standard YANG types
- `ietf-inet-types.yang` - Internet address types

**Nokia Specific:**
- `nokia-types-bgp.yang` - BGP-specific types
- `nokia-types-router.yang` - Router types
- `nokia-types-services.yang` - Service types
- `nokia-sros-yang-extensions.yang` - Nokia YANG extensions

### Validation

```bash
# Run validation (from models directory)
./validate-bgp.sh

# Expected output:
# 📋 Nokia SROS BGP Types (Standalone Models):
#   ✅ Nokia BGP types: VALID
#   ✅ Nokia SROS extensions: VALID
```

## Notes

- **Complex Dependencies**: Full BGP models (state and config) have complex interdependencies which is normal for enterprise networking models
- **Standalone Validation**: Type definitions and extensions validate successfully as standalone models
- **Latest Version**: All models use SROS 25.7 for access to the newest BGP features and fixes
