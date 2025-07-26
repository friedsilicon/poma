#!/bin/bash

set -e

echo "🔗 Setting up BGP YANG model symlinks..."
echo ""

# Create models directory structure
echo "📁 Creating directory structure..."
mkdir -p models/{nokia/{bgp,types,common},openconfig/{bgp,types,extensions,rib,common},ietf}

echo ""
echo "📁 Setting up Nokia BGP models (SROS 19.10)..."

# Nokia BGP submodule (the main file you want)
ln -sf ../../../nokia/latest_sros_19.10/nokia-state-router-bgp.yang \
    models/nokia/bgp/nokia-state-router-bgp.yang

# Nokia main state file (includes the BGP submodule)
ln -sf ../../../nokia/latest_sros_19.10/nokia-state.yang \
    models/nokia/common/nokia-state.yang

# Nokia type dependencies for BGP
ln -sf ../../../nokia/latest_sros_19.10/nokia-sros-yang-extensions.yang \
    models/nokia/types/nokia-sros-yang-extensions.yang
ln -sf ../../../nokia/latest_sros_19.10/nokia-types-bgp.yang \
    models/nokia/types/nokia-types-bgp.yang
ln -sf ../../../nokia/latest_sros_19.10/nokia-types-router.yang \
    models/nokia/types/nokia-types-router.yang
ln -sf ../../../nokia/latest_sros_19.10/nokia-types-services.yang \
    models/nokia/types/nokia-types-services.yang
ln -sf ../../../nokia/latest_sros_19.10/nokia-types-sros.yang \
    models/nokia/types/nokia-types-sros.yang

echo ""
echo "📁 Setting up OpenConfig BGP models..."

# OpenConfig BGP model (the main file you want)
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp.yang \
    models/openconfig/bgp/openconfig-bgp.yang

# OpenConfig BGP dependencies
ln -sf ../../../open-config/release/models/extensions/openconfig-extensions.yang \
    models/openconfig/extensions/openconfig-extensions.yang
ln -sf ../../../open-config/release/models/rib/openconfig-rib-bgp.yang \
    models/openconfig/rib/openconfig-rib-bgp.yang

# Additional OpenConfig BGP files that might be useful
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-policy.yang \
    models/openconfig/bgp/openconfig-bgp-policy.yang
ln -sf ../../../open-config/release/models/bgp/openconfig-bgp-types.yang \
    models/openconfig/bgp/openconfig-bgp-types.yang

# OpenConfig type dependencies
ln -sf ../../../open-config/release/models/types/openconfig-types.yang \
    models/openconfig/types/openconfig-types.yang
ln -sf ../../../open-config/release/models/types/openconfig-inet-types.yang \
    models/openconfig/types/openconfig-inet-types.yang
ln -sf ../../../open-config/release/models/types/openconfig-yang-types.yang \
    models/openconfig/types/openconfig-yang-types.yang

# Additional OpenConfig dependencies that BGP might need
if [ -f "open-config/release/models/policy/openconfig-routing-policy.yang" ]; then
    ln -sf ../../../open-config/release/models/policy/openconfig-routing-policy.yang \
        models/openconfig/common/openconfig-routing-policy.yang
fi

if [ -f "open-config/release/models/interfaces/openconfig-interfaces.yang" ]; then
    ln -sf ../../../open-config/release/models/interfaces/openconfig-interfaces.yang \
        models/openconfig/common/openconfig-interfaces.yang
fi

echo ""
echo "📁 Setting up IETF standard dependencies..."

# IETF standard types (from OpenConfig third_party)
ln -sf ../../open-config/third_party/ietf/ietf-inet-types.yang \
    models/ietf/ietf-inet-types.yang
ln -sf ../../open-config/third_party/ietf/ietf-yang-types.yang \
    models/ietf/ietf-yang-types.yang

echo ""
echo "📝 Creating models directory README..."

cat > models/README.md << 'EOF'
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
EOF

echo ""
echo "📝 Creating validation script..."

cat > models/validate-bgp.sh << 'EOF'
#!/bin/bash

set -e

echo "🔍 Validating BGP YANG models..."
echo ""

# Test Nokia BGP models
echo "📋 Nokia SROS BGP models:"
echo "  Testing nokia-state-router-bgp.yang..."
if pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang > /dev/null 2>&1; then
    echo "  ✅ Nokia BGP submodule: VALID"
else
    echo "  ❌ Nokia BGP submodule: FAILED"
    echo "     Detailed error:"
    pyang --strict --path nokia/types:ietf nokia/bgp/nokia-state-router-bgp.yang
fi

echo ""
echo "  Testing nokia-state.yang (includes BGP)..."
if pyang --strict --path nokia/types:ietf nokia/common/nokia-state.yang > /dev/null 2>&1; then
    echo "  ✅ Nokia main state (with BGP): VALID"
else
    echo "  ❌ Nokia main state (with BGP): FAILED"
    echo "     Detailed error:"
    pyang --strict --path nokia/types:ietf nokia/common/nokia-state.yang
fi

echo ""
echo "📋 OpenConfig BGP models:"
echo "  Testing openconfig-bgp.yang..."
if pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:ietf \
    openconfig/bgp/openconfig-bgp.yang > /dev/null 2>&1; then
    echo "  ✅ OpenConfig BGP: VALID"
else
    echo "  ❌ OpenConfig BGP: FAILED"
    echo "     Detailed error:"
    pyang --strict --path openconfig/types:openconfig/extensions:openconfig/rib:ietf \
        openconfig/bgp/openconfig-bgp.yang
fi

echo ""
echo "🎉 BGP model validation complete!"
EOF

chmod +x models/validate-bgp.sh

echo ""
echo "✅ BGP model symlinks created successfully!"
echo ""
echo "📊 Summary of created symlinks:"
echo "📁 Nokia models:"
find models/nokia -name "*.yang" | sort

echo ""
echo "📁 OpenConfig models:"
find models/openconfig -name "*.yang" | sort

echo ""
echo "📁 IETF models:"
find models/ietf -name "*.yang" | sort

echo ""
echo "🧪 Test the setup:"
echo "   cd models && ./validate-bgp.sh"
echo ""
echo "🔍 Explore models:"
echo "   pyang -f tree models/nokia/bgp/nokia-state-router-bgp.yang"
echo "   pyang -f tree models/openconfig/bgp/openconfig-bgp.yang"
