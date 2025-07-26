# BGP YANG Models

This directory contains symlinks to BGP-related YANG models from various vendors,
organized by vendor for easy navigation and validation.

## Structure

```
models/
├── nokia/
│   ├── bgp/           # Nokia BGP models
│   ├── types/         # Nokia type definitions
│   ├── router/        # Nokia router submodules
│   ├── common/        # Nokia common modules
│   └── test/          # Nokia test/validation models
├── openconfig/
│   ├── bgp/           # OpenConfig BGP models
│   ├── types/         # OpenConfig type definitions
│   ├── extensions/    # OpenConfig extensions
│   ├── rib/           # OpenConfig RIB models
│   └── common/        # OpenConfig common modules
└── ietf/              # IETF standard types
```

## Validation Scripts

### Main Validation
- `validate-bgp.sh` - Validates both Nokia and OpenConfig BGP models

### Vendor-Specific Validation  
- `validate-nokia-bgp.sh` - Nokia BGP model validation only
- `validate-openconfig-bgp.sh` - OpenConfig BGP model validation only

### Script Options

All validation scripts support the following command-line options:

| Option | Description | Example |
|--------|-------------|---------|
| `-h, --help` | Show help message | `./validate-bgp.sh -h` |
| `-t, --tree` | Show BGP tree structure | `./validate-bgp.sh -t` |
| `-e, --errors` | Show detailed error messages | `./validate-bgp.sh -e` |
| `-l, --lines NUM` | Number of tree lines to show (default: 20) | `./validate-bgp.sh -t -l 50` |
| `-q, --quiet` | Quiet mode - minimal output | `./validate-bgp.sh -q` |
| `-a, --all` | Run all validation checks (includes tree and errors) | `./validate-bgp.sh -a` |

### Usage Examples

```bash
# Basic validation for all vendors
./validate-bgp.sh

# Quiet mode for CI/automation
./validate-bgp.sh -q

# Show tree structures with 30 lines
./validate-bgp.sh -t -l 30

# Show all details including errors
./validate-bgp.sh -a

# Nokia-specific validation with tree
./validate-nokia-bgp.sh -t

# OpenConfig-specific validation with errors
./validate-openconfig-bgp.sh -e
```

## Models Included

### Nokia (SROS 19.10)
- ✅ `nokia-state-router-bgp.yang` - BGP router submodule (**FULLY FUNCTIONAL**)
- ✅ `nokia-state-bgp-only.yang` - BGP-only test model with tree generation
- ⚠️  `nokia-state-router.yang` - Complete router state (needs all protocol dependencies)
- 📦 Complete type dependencies and router submodules

### OpenConfig
- ⚠️  `openconfig-bgp.yang` - Main BGP configuration model (needs submodules)
- ⚠️  `openconfig-bgp-policy.yang` - BGP policy model (needs dependencies)
- ⚠️  `openconfig-bgp-types.yang` - BGP type definitions (needs dependencies)
- 📦 Basic type dependencies and extensions

### IETF
- ✅ Standard type definitions used by both vendors

## Usage

### Quick Validation
```bash
# Validate all BGP models (basic)
./validate-bgp.sh

# Validate all with tree output
./validate-bgp.sh -t

# Validate all with detailed errors
./validate-bgp.sh -e

# Validate all with comprehensive output
./validate-bgp.sh -a

# Quiet mode for automation
./validate-bgp.sh -q
```

### Vendor-Specific Usage
```bash
# Nokia validation with tree (20 lines)
./validate-nokia-bgp.sh -t

# Nokia validation with extended tree (50 lines)
./validate-nokia-bgp.sh -t -l 50

# OpenConfig validation with error details
./validate-openconfig-bgp.sh -e

# Nokia quiet mode for CI
./validate-nokia-bgp.sh -q
```

### Manual Validation Examples
```bash
# Nokia BGP submodule (core functionality)
pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang

# Nokia BGP tree generation
pyang -f tree --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang

# OpenConfig BGP types
pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-types.yang
```

## Status Summary

| Model | Status | Tree Generation | Notes |
|-------|--------|----------------|-------|
| Nokia BGP Submodule | ✅ WORKING | ✅ WORKING | Fully functional |
| Nokia BGP Test Model | ✅ WORKING | ✅ WORKING | Complete tree structure |
| Nokia Router State | ⚠️ PARTIAL | ⚠️ PARTIAL | Needs more dependencies |
| OpenConfig BGP | ❌ INCOMPLETE | ❌ NO | Missing submodules |
| OpenConfig BGP Types | ❌ INCOMPLETE | ❌ NO | Missing dependencies |

## Notes

- **Nokia models** are fully functional for BGP validation and tree generation
- **OpenConfig models** need additional submodules from the OpenConfig repository
- Symlinks are tracked in git for ease of use across different environments
- Run setup scripts from parent directory to recreate symlinks if needed

## Nokia Router State Model Assessment

The Nokia `nokia-state-router.yang` model currently fails validation due to missing dependencies. Here's an analysis of what would be required to make it pass:

### Issues Identified

1. **Circular Dependencies**
   - Router submodules (IGMP, LDP, MPLS, OSPF3, RSVP) create circular references to the main router module
   - This is a fundamental architectural issue in how Nokia structured these modules

2. **Missing Service Dependencies** 
   - Need 23+ service state modules (`nokia-state-svc-*`)
   - Service modules have their own dependency chains
   - Missing: `nokia-state-svc-epipe`, `nokia-state-svc-sdp`, `nokia-state-svc-vpls`, `nokia-state-svc-vprn`, etc.

3. **Missing Type Dependencies**
   - Need 49+ type definition modules (`nokia-types-*`) 
   - Missing: `nokia-types-filter`, `nokia-types-eth-cfm`, and many others

### Effort Required

**Minimal Approach (70+ files):**
- Create symlinks for all 23 service state modules
- Create symlinks for ~25 additional type modules  
- Add service and additional type paths to validation scripts
- **Estimated effort: 2-3 hours**

**Complete Approach (100+ files):**
- Create comprehensive Nokia module structure
- Handle circular dependency issues (may require module modifications)
- Create robust search path management
- **Estimated effort: 4-6 hours**

### Recommendation

**Don't pursue full router state validation** for these reasons:

1. **Scope Creep**: BGP focus would be diluted by adding 70+ non-BGP modules
2. **Circular Dependencies**: Fundamental architectural issues that may require Nokia module modifications  
3. **Maintenance Burden**: Much larger symlink structure to maintain
4. **Current Success**: Nokia BGP submodule and BGP-only test model already work perfectly

**Current BGP-focused approach is optimal** - we have fully functional Nokia BGP validation and tree generation, which meets the primary goal for BGP modeling work.

## Dependencies

All validation requires:
- Python virtual environment with pyang installed
- Proper YANG module search paths
- Complete type definition chains
