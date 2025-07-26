# Documentation

This project uses **MkDocs with Material theme** for documentation, auto-published via GitHub Pages.

## View Documentation

**Live Site:** [https://yourusername.github.io/yang-modelling](https://yourusername.github.io/yang-modelling)

## Local Development

```bash
# Install dependencies
pip install mkdocs-material mkdocs-git-revision-date-localized-plugin

# Serve locally with live reload
mkdocs serve
# Visit: http://localhost:8000

# Build static site
mkdocs build
```

## Deployment

Documentation automatically deploys to GitHub Pages when changes are pushed to `main` branch via GitHub Actions.

To enable:
1. Repository Settings > Pages > Source: "GitHub Actions"
2. Update repository URLs in `mkdocs.yml`
3. Push changes to trigger deployment
