# Troubleshooting

Common issues and solutions for the PoMa workspace.

## Installation Issues

### Python Environment Problems

**Issue: Virtual environment not found**
```
bash: venv/bin/activate: No such file or directory
```

**Solution:**
```bash
# Recreate the virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Issue: Permission denied on setup scripts**
```
bash: ./setup-dev-env.sh: Permission denied
```

**Solution:**
```bash
chmod +x setup-dev-env.sh setup-bgp-models.sh validate-*.sh
```

### Dependency Installation

**Issue: lxml installation fails**
```
error: Microsoft Visual C++ 14.0 is required
```

**Solution (Platform-specific):**

=== "macOS"
    ```bash
    # Install Xcode command line tools
    xcode-select --install
    
    # Or use Homebrew
    brew install libxml2 libxslt
    ```

=== "Ubuntu/Debian"
    ```bash
    sudo apt install libxml2-dev libxslt1-dev python3-dev
    ```

=== "Windows"
    ```bash
    # Install Microsoft C++ Build Tools
    # Or use conda instead of pip
    conda install lxml
    ```

### Git Submodule Issues

**Issue: Submodules not initializing**
```
fatal: No url found for submodule path 'yang-models-nokia'
```

**Solution:**
```bash
# Update .gitmodules and reinitialize
git submodule deinit --all
git submodule update --init --recursive
```

**Issue: Permission denied on submodule files**
```
error: unable to create file: Permission denied
```

**Solution:**
```bash
# Fix permissions and retry
sudo chown -R $USER:$USER .
git submodule update --init --recursive
```

## Validation Issues

### YANG Tool Problems

**Issue: pyang command not found**
```
bash: pyang: command not found
```

**Solution:**
```bash
# Ensure virtual environment is activated
source venv/bin/activate
which pyang  # Should show path in venv

# If still missing, reinstall
pip install --upgrade pyang
```

**Issue: yanglint validation errors**
```
yanglint[E]: Module "ietf-yang-types" not found
```

**Solution:**
```bash
# Ensure all dependencies are symlinked
./setup-bgp-models.sh

# Check symlinks
ls -la models/ietf/
```

### Model Validation

**Issue: Import resolution failures**
```
error: module "nokia-sros-yang-extensions" not found
```

**Solution:**
```bash
# Check model dependencies are properly linked
cd models
find . -name "nokia-sros-yang-extensions.yang"

# Re-run setup if missing
cd .. && ./setup-bgp-models.sh
```

**Issue: Circular import errors**
```
error: circular dependency detected
```

**Solution:**
```bash
# Use specific model paths
pyang --path=models/nokia:models/ietf models/nokia/nokia-sr-bgp.yang
```

## Documentation Issues

### MkDocs Problems

**Issue: mkdocs command not found**
```
bash: mkdocs: command not found
```

**Solution:**
```bash
source venv/bin/activate
pip install -r requirements.txt
```

**Issue: Documentation build fails**
```
WARNING - Doc file contains a link to 'missing-file.md'
```

**Solution:**
```bash
# Check mkdocs.yml navigation
# Remove or create missing files
mkdocs build --strict
```

### GitHub Pages

**Issue: Documentation not deploying**

**Check:**
1. Repository **Settings** > **Pages** > Source: "GitHub Actions"
2. Workflow completed successfully in **Actions** tab
3. Branch is `main` (not `master`)

**Issue: 404 on documentation site**

**Solutions:**
```bash
# Check site_url in mkdocs.yml
site_url: https://yourusername.github.io/poma

# Verify repository name matches
repo_url: https://github.com/yourusername/poma
```

## Performance Issues

### Slow Validation

**Issue: Validation takes too long**

**Solutions:**
```bash
# Use quiet mode for CI
./validate-bgp.sh -q

# Validate specific models only
pyang models/nokia/nokia-sr-bgp.yang

# Parallel validation
find models -name "*.yang" | xargs -P 4 -I {} pyang {}
```

### Large Repository

**Issue: Clone takes too long**

**Solutions:**
```bash
# Shallow clone
git clone --depth 1 --recursive

# Or partial checkout
git clone --filter=blob:none --recursive
```

## System-Specific Issues

### macOS Specific

**Issue: brew install fails**
```bash
# Update Homebrew first
brew update

# Fix permissions if needed
sudo chown -R $(whoami) /usr/local/var/homebrew
```

### Windows Specific

**Issue: Symlinks not working**
```bash
# Enable Developer Mode or run as Administrator
# Alternatively, use directory junctions
mklink /J models\nokia yang-models-nokia\nokia\7x50\yang-models
```

### Linux Specific

**Issue: Package manager conflicts**
```bash
# Use Python virtual environment instead of system packages
python3 -m venv venv --system-site-packages=false
```

## Getting Help

### Debug Information

To report issues, include:

```bash
# System information
uname -a
python --version
git --version

# Python environment
pip list
pip show pyang

# Repository status
git status
git submodule status

# Validation output
./validate-bgp.sh -v 2>&1 | head -50
```

### Useful Commands

```bash
# Reset everything
git clean -fdx
git submodule foreach --recursive git clean -fdx
git submodule update --init --recursive

# Reinstall Python environment
rm -rf venv
./setup-dev-env.sh

# Rebuild documentation
rm -rf site/
mkdocs build
```

### Still Need Help?

- Check [GitHub Issues](https://github.com/yourusername/poma/issues)
- Review [Installation Guide](installation.md)
- Contact the maintainers

## Prevention Tips

1. **Always use virtual environments** for Python dependencies
2. **Keep submodules updated** regularly
3. **Test validation scripts** after any changes
4. **Use version pinning** in requirements.txt for stability
5. **Regular backups** of working configurations
