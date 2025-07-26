# BGP YANG Models

This directory contains symlinks to BGP-related YANG models organized by vendor.

## Structure

```
models/
├── nokia/
│   ├── bgp/              # Nokia BGP-specific models
│   ├── types/            # Nokia type definitions
│   └── common/           # Nokia common modules
├── openconfig/
│   ├── bgp/              # OpenConfig BGP models
│   ├── types/            # OpenConfig type definitions
│   ├── extensions/       # OpenConfig extensions
│   ├── rib/              # RIB-related models
│   └── common/           # Common OpenConfig modules
└── ietf/                 # IETF standard types
```

## Key Models

### Nokia SROS 19.10
- **`nokia/bgp/nokia-state-router-bgp.yang`** - Main Nokia BGP state model
- `nokia/common/nokia-state.yang` - Main state file that includes BGP submodule
- `nokia/types/` - Nokia-specific type definitions

### OpenConfig
- **`openconfig/bgp/openconfig-bgp.yang`** - Main OpenConfig BGP model
- `openconfig/bgp/openconfig-bgp-policy.yang` - BGP policy model
- `openconfig/bgp/openconfig-bgp-types.yang` - BGP type definitions
- `openconfig/types/` - OpenConfig type definitions

### IETF
- Standard type definitions used by both vendors

## Validation Examples

### Nokia BGP Model
```bash
# Validate Nokia BGP submodule
pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang

# Validate main Nokia state (includes BGP)
pyang --strict --path nokia/types:ietf nokia/common/nokia-state.yang
```

### OpenConfig BGP Model
```bash
# Validate OpenConfig BGP
pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:ietf \
    openconfig/bgp/openconfig-bgp.yang
```

## Notes

- These are symlinks to the actual files in the git submodules
- Symlinks are tracked in git for reproducible setup
- Run `../setup-bgp-models.sh` to recreate if needed
- Use the validation script: `./validate-bgp.sh`
