# Quick Start Workflow

## New User Setup
```bash
# Clone the repository
git clone --recursive <your-repo-url>
cd yang-modelling

# Set up development environment (one time)
./setup-dev-env.sh

# Activate environment and test
source venv/bin/activate
cd models && ./validate-bgp.sh
```

## Daily Workflow
```bash
# Activate environment
source venv/bin/activate

# Work with models (they're already available as symlinks)
pyang -f tree nokia/bgp/nokia-state.yang
yanggui openconfig/bgp/openconfig-bgp.yang

# When done
deactivate
```

## Adding New Models
```bash
# Edit the setup script to add new symlinks
vim setup-bgp-models.sh

# Run to create new symlinks
./setup-bgp-models.sh

# Commit the new symlinks
git add models/
git commit -m "Add new model symlinks"
```

## Updating Submodules
```bash
# Update to latest upstream versions
git submodule update --remote

# If symlinks point to non-existent files, recreate them
./setup-bgp-models.sh

# Commit any changes
git add . && git commit -m "Update submodules and refresh symlinks"
```
