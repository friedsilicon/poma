# Documentation

This project uses **MkDocs with Material theme** for documentation, auto-published via GitHub Pages.

## View Documentation

**Live Site:** [https://yourusername.github.io/poma](https://yourusername.github.io/poma)

## Local Development

```bash
# Install all dependencies (includes MkDocs)
pip install -r requirements.txt

# Serve locally with live reload
mkdocs serve
# Visit: http://localhost:8000

# Build static site
mkdocs build
```

## Deployment

Documentation automatically deploys to GitHub Pages when changes are pushed to `main` branch via GitHub Actions.

**The workflow will automatically:**
- Enable GitHub Pages (if not already enabled)
- Configure Pages to use GitHub Actions as the source
- Build and deploy the documentation

**Manual setup (if needed):**
1. Repository Settings > Pages > Source: "GitHub Actions"
2. Update repository URLs in `mkdocs.yml`
3. Push changes to trigger deployment
