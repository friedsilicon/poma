# BGP YANG Models

This directory contains organized symlinks to BGP YANG models from Nokia and OpenConfig.

## Structure

```
models/
├── nokia/                          # Nokia models and dependencies
│   ├── bgp/                        # Nokia BGP models
│   │   ├── nokia-state-router-bgp.yang    # BGP state submodule
│   │   └── nokia-state.yang               # Main state module
│   └── types/                      # Nokia-specific types
│       ├── nokia-sros-yang-extensions.yang
│       ├── nokia-types-bgp.yang
│       ├── nokia-types-router.yang
│       ├── nokia-types-services.yang
│       └── nokia-types-sros.yang
├── openconfig/                     # OpenConfig models and dependencies
│   ├── bgp/                        # OpenConfig BGP models
│   │   └── openconfig-bgp.yang            # Main BGP module
│   ├── types/                      # OpenConfig types
│   │   ├── openconfig-extensions.yang
│   │   ├── openconfig-rib-bgp.yang
│   │   ├── openconfig-types.yang
│   │   ├── openconfig-inet-types.yang
│   │   ├── openconfig-yang-types.yang
│   │   ├── openconfig-bgp-types.yang
│   │   ├── openconfig-interfaces.yang
│   │   └── openconfig-routing-policy.yang
│   └── includes/                   # OpenConfig submodules
│       └── bgp/                    # BGP-specific includes
│           ├── openconfig-bgp-common.yang
│           ├── openconfig-bgp-common-multiprotocol.yang
│           ├── openconfig-bgp-common-structure.yang
│           ├── openconfig-bgp-peer-group.yang
│           ├── openconfig-bgp-neighbor.yang
│           └── openconfig-bgp-global.yang
└── ietf/                           # IETF standard types
    ├── ietf-inet-types.yang
    ├── ietf-yang-types.yang
    └── ietf-interfaces.yang
```

## Usage

### Validate Models
```bash
cd models
./validate-bgp.sh
```

### Using with pyang
```bash
# Nokia BGP (submodule - validate main module)
pyang --path nokia/types:ietf:nokia/bgp \
  nokia/bgp/nokia-state.yang

# OpenConfig BGP
pyang --path openconfig/types:ietf:openconfig/includes/bgp \
  openconfig/bgp/openconfig-bgp.yang
```

### Generate Documentation
```bash
# Nokia BGP tree
pyang -f tree --path nokia/types:ietf:nokia/bgp \
  nokia/bgp/nokia-state.yang

# OpenConfig BGP tree
pyang -f tree --path openconfig/types:ietf:openconfig/includes/bgp \
  openconfig/bgp/openconfig-bgp.yang
```

## Notes

- All files are symlinks to the original submodule files
- Models stay automatically synchronized with submodule updates
- Nokia BGP is a submodule, so validate the main `nokia-state.yang` file
- OpenConfig BGP uses include statements for its submodules
