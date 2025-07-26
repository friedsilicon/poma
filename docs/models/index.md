# Available YANG Models

This section provides detailed information about the YANG models available in this repository.

## Nokia Models

### BGP Models (SROS 19.10)

| Model | Status | Tree Generation | Description |
|-------|--------|----------------|-------------|
| `nokia-state-router-bgp.yang` | ✅ **FULLY FUNCTIONAL** | ✅ **WORKING** | BGP router submodule |
| `nokia-state-bgp-only.yang` | ✅ **FULLY FUNCTIONAL** | ✅ **WORKING** | BGP-only test model |
| `nokia-state-router.yang` | ⚠️ **PARTIAL** | ⚠️ **PARTIAL** | Complete router state |

!!! success "Recommended for BGP Work"
    The Nokia BGP submodule and BGP-only test model are fully functional and recommended for BGP modeling work.

### Nokia Model Structure

```
models/nokia/
├── bgp/           # BGP-specific models
├── types/         # Type definitions
├── router/        # Router submodules  
├── common/        # Common modules
└── test/          # Test/validation models
```

### Notable Features

- **Complete BGP functionality**: Full BGP state model validation
- **Tree generation**: Comprehensive YANG tree output
- **Type dependencies**: All required Nokia types included
- **Test models**: Simplified models for validation and examples

## OpenConfig Models

### BGP Models

| Model | Status | Tree Generation | Description |
|-------|--------|----------------|-------------|
| `openconfig-bgp.yang` | ❌ **INCOMPLETE** | ❌ **NO** | Main BGP configuration |
| `openconfig-bgp-policy.yang` | ❌ **INCOMPLETE** | ❌ **NO** | BGP policy model |
| `openconfig-bgp-types.yang` | ❌ **INCOMPLETE** | ❌ **NO** | BGP type definitions |

!!! warning "Missing Dependencies"
    OpenConfig models require additional submodules from the OpenConfig repository for complete validation.

### OpenConfig Model Structure

```
models/openconfig/
├── bgp/           # BGP models
├── types/         # Type definitions
├── extensions/    # OpenConfig extensions
├── rib/           # RIB models
└── common/        # Common modules
```

### Known Issues

- Missing `openconfig-bgp-errors` module
- Missing additional extension modules
- Individual components may validate but full model needs dependencies

## IETF Models

### Standard Types

| Model | Status | Description |
|-------|--------|-------------|
| IETF Standard Types | ✅ **WORKING** | Standard type definitions |

The IETF modules provide standard type definitions used by both vendor implementations.

## Model Organization

Models are organized using symlinks for easy navigation and version control:

```
models/
├── nokia/              # Nokia-specific organization
│   ├── bgp/           # BGP models only
│   ├── types/         # All type definitions
│   ├── router/        # Router submodules
│   ├── common/        # Common modules
│   └── test/          # Test models
├── openconfig/         # OpenConfig organization
│   ├── bgp/           # BGP models
│   ├── types/         # Type definitions
│   ├── extensions/    # Extensions
│   ├── rib/           # RIB models
│   └── common/        # Common modules
└── ietf/              # IETF standard types
```

## Usage Examples

### Nokia Examples

```bash
# Validate Nokia BGP submodule
pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang

# Generate Nokia BGP tree
pyang -f tree --path nokia/types:nokia/router:ietf nokia/test/nokia-state-bgp-only.yang

# Validate using scripts
./validate-nokia-bgp.sh -t
```

### OpenConfig Examples

```bash
# Attempt OpenConfig BGP types validation
pyang --strict --path openconfig/types:openconfig/extensions:ietf openconfig/bgp/openconfig-bgp-types.yang

# Using scripts for better error reporting
./validate-openconfig-bgp.sh -e
```

## Next Steps

- **[Nokia Models Details](nokia.md)**: Detailed Nokia model information
- **[OpenConfig Models Details](openconfig.md)**: OpenConfig model specifics  
- **[Assessment](assessment.md)**: Analysis of making more models work
