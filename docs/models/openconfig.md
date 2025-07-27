# OpenConfig Models

Comprehensive documentation for OpenConfig YANG models in the workspace.

## Overview

OpenConfig is an industry initiative to develop vendor-neutral, standards-based network configuration and telemetry models. The workspace includes BGP-related OpenConfig models and their dependencies.

**Source Repository:** [OpenConfig Public YANG Models](https://github.com/openconfig/public)  
**Local Path:** `open-config/`  
**Symlink Location:** `models/openconfig/`

## Available Models

### BGP Models

#### `openconfig-bgp.yang`
**Description:** Main BGP configuration and state model following OpenConfig standards  
**Location:** `models/openconfig/bgp/openconfig-bgp.yang`  
**Status:** ✅ Available, ⚠️ Complex dependencies (expected)

**Key Features:**
- Vendor-neutral BGP configuration
- Comprehensive neighbor management
- Policy framework integration
- Operational state modeling
- Multi-protocol support (IPv4, IPv6, L3VPN, EVPN)

**For detailed configuration examples and comparisons with Nokia, see [BGP Configuration Model Comparison](bgp-config-comparison.md) and [BGP State Model Comparison](bgp-state-comparison.md).**

#### `openconfig-bgp-types.yang`
**Description:** BGP-specific type definitions and identities  
**Location:** `models/openconfig/bgp/openconfig-bgp-types.yang`  
**Status:** ✅ **Validated**

#### `openconfig-bgp-policy.yang`
**Description:** BGP policy configuration model  
**Location:** `models/openconfig/bgp/openconfig-bgp-policy.yang`  
**Status:** ✅ Available, ⚠️ Complex dependencies (expected)

### Type and Extension Models

#### `openconfig-extensions.yang`
**Description:** OpenConfig YANG extensions and annotations  
**Location:** `models/openconfig/extensions/openconfig-extensions.yang`  
**Status:** ✅ **Validated**

#### `openconfig-types.yang`
**Description:** Common OpenConfig type definitions  
**Location:** `models/openconfig/types/openconfig-types.yang`  
**Status:** ✅ Available

## Quick Reference

### File Locations
```
models/openconfig/
├── bgp/                    # BGP models
│   ├── openconfig-bgp.yang
│   ├── openconfig-bgp-types.yang
│   └── openconfig-bgp-policy.yang
├── types/                  # Common type definitions
│   ├── openconfig-types.yang
│   ├── openconfig-inet-types.yang
│   └── openconfig-yang-types.yang
├── extensions/             # OpenConfig extensions
│   └── openconfig-extensions.yang
├── rib/                    # RIB models
│   └── openconfig-rib-bgp.yang
└── common/                 # Common models
    ├── openconfig-interfaces.yang
    └── openconfig-routing-policy.yang
```

### Validation Status
- ✅ **BGP Types**: Validated standalone
- ✅ **Extensions**: Validated standalone  
- ✅ **Main BGP Model**: Available with expected complex dependencies
- ✅ **Policy Models**: Available with expected complex dependencies

### Usage Examples
```bash
# Validate OpenConfig BGP types (works standalone)
pyang --strict --path openconfig/types:openconfig/extensions:ietf \
  openconfig/bgp/openconfig-bgp-types.yang

# Analyze OpenConfig BGP structure
pyang -f tree --tree-depth 3 openconfig/bgp/openconfig-bgp.yang
```

