#!/bin/bash

set -e

echo "🔧 Setting up BGP YANG model symlinks..."

# Create organized directory structure
echo "📁 Creating directory structure..."
mkdir -p models/nokia/bgp
mkdir -p models/nokia/types
mkdir -p models/openconfig/bgp
mkdir -p models/openconfig/types
mkdir -p models/openconfig/includes/bgp
mkdir -p models/ietf

echo "🔗 Setting up Nokia BGP model symlinks..."

# Nokia BGP primary files
ln -sf ../../nokia/latest_sros_19.10/nokia-state-router-bgp.yang models/nokia/bgp/
ln -sf ../../nokia/latest_sros_19.10/nokia-state.yang models/nokia/bgp/

# Nokia-specific types
ln -sf ../../nokia/latest_sros_19.10/nokia-sros-yang-extensions.yang models/nokia/types/
ln -sf ../../nokia/latest_sros_19.10/nokia-types-bgp.yang models/nokia/types/
ln -sf ../../nokia/latest_sros_19.10/nokia-types-router.yang models/nokia/types/
ln -sf ../../nokia/latest_sros_19.10/nokia-types-services.yang models/nokia/types/
ln -sf ../../nokia/latest_sros_19.10/nokia-types-sros.yang models/nokia/types/

# IETF types (from Nokia repo)
ln -sf ../../nokia/latest_sros_19.10/ietf-inet-types.yang models/ietf/
ln -sf ../../nokia/latest_sros_19.10/ietf-yang-types.yang models/ietf/

echo "🔗 Setting up OpenConfig BGP model symlinks..."

# OpenConfig BGP primary file
ln -sf ../../open-config/release/models/bgp/openconfig-bgp.yang models/openconfig/bgp/

# OpenConfig BGP includes (submodules)
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-common.yang models/openconfig/includes/bgp/
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-common-multiprotocol.yang models/openconfig/includes/bgp/
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-common-structure.yang models/openconfig/includes/bgp/
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-peer-group.yang models/openconfig/includes/bgp/
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-neighbor.yang models/openconfig/includes/bgp/
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-global.yang models/openconfig/includes/bgp/

# OpenConfig types and dependencies
ln -sf ../../open-config/release/models/openconfig-extensions.yang models/openconfig/types/
ln -sf ../../open-config/release/models/rib/openconfig-rib-bgp.yang models/openconfig/types/
ln -sf ../../open-config/release/models/types/openconfig-types.yang models/openconfig/types/
ln -sf ../../open-config/release/models/types/openconfig-inet-types.yang models/openconfig/types/
ln -sf ../../open-config/release/models/types/openconfig-yang-types.yang models/openconfig/types/
ln -sf ../../open-config/release/models/bgp/openconfig-bgp-types.yang models/openconfig/types/
ln -sf ../../open-config/release/models/interfaces/openconfig-interfaces.yang models/openconfig/types/
ln -sf ../../open-config/release/models/policy/openconfig-routing-policy.yang models/openconfig/types/

# IETF dependencies from OpenConfig (only if not already linked)
ln -sf ../../open-config/third_party/ietf/ietf-interfaces.yang models/ietf/ 2>/dev/null || true

echo "📝 Creating validation script..."
cat > models/validate-bgp.sh << 'EOF'
#!/bin/bash

echo "🔍 Validating Nokia SROS 19.10 BGP models..."
echo "Main module: nokia-state.yang with submodule: nokia-state-router-bgp.yang"

pyang --strict \
  --path nokia/types:ietf:nokia/bgp \
  nokia/bgp/nokia-state.yang

if [ $? -eq 0 ]; then
    echo "✅ Nokia BGP models validated successfully!"
else
    echo "❌ Nokia BGP models validation failed!"
    exit 1
fi

echo ""
echo "🔍 Validating OpenConfig BGP models..."

pyang --strict \
  --path openconfig/types:ietf:openconfig/includes/bgp \
  openconfig/bgp/openconfig-bgp.yang

if [ $? -eq 0 ]; then
    echo "✅ OpenConfig BGP models validated successfully!"
else
    echo "❌ OpenConfig BGP models validation failed!"
    exit 1
fi

echo ""
echo "🎉 All BGP models validated successfully!"
EOF

chmod +x models/validate-bgp.sh

echo "📊 Creating file listing..."
cat > models/README.md << 'EOF'
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
EOF

echo ""
echo "✅ BGP model symlink structure created successfully!"
echo ""
echo "📂 Directory structure:"
find models -type l | head -20
echo ""
echo "🚀 Next steps:"
echo "  1. Run: cd models && ./validate-bgp.sh"
echo "  2. Check: ls -la models/nokia/ models/openconfig/"
echo "  3. Read: cat models/README.md"
