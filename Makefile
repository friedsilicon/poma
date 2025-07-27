# PoMa - YANG Model Analysis Makefile
# Accelerated development workflow

.PHONY: help setup setup-fast setup-ci setup-full clean validate test docs

# Default target
help:
	@echo "🎯 PoMa - YANG Model Analysis"
	@echo ""
	@echo "📦 Setup Commands:"
	@echo "  make setup      - Full setup (env + fast submodules + bgp models)"
	@echo "  make setup-fast - Fast submodule setup only (shallow clone)"
	@echo "  make setup-ci   - CI-optimized setup (fastest)"
	@echo "  make setup-full - Complete setup with full git history"
	@echo ""
	@echo "🧪 Development Commands:"
	@echo "  make validate   - Validate all BGP models"
	@echo "  make test       - Run YANG tools tests"
	@echo "  make docs       - Build documentation"
	@echo "  make clean      - Clean temporary files"
	@echo ""
	@echo "⚡ Quick start: make setup && make validate"

# Full setup workflow (recommended)
setup: setup-env setup-fast setup-bgp
	@echo "✅ Complete PoMa setup finished!"
	@echo "🧪 Run 'make validate' to test everything"

# Setup Python environment
setup-env:
	@echo "🔧 Setting up Python environment..."
	./scripts/setup-dev-env.sh

# Fast submodule setup (default)
setup-fast:
	@echo "📦 Setting up submodules with shallow clone..."
	./scripts/setup-submodules-fast.sh shallow

# CI-optimized setup (fastest)
setup-ci:
	@echo "🏗️  Setting up submodules for CI..."
	./scripts/setup-submodules-fast.sh ci

# Full submodule setup (complete git history)
setup-full:
	@echo "📚 Setting up submodules with full history..."
	./scripts/setup-submodules-fast.sh full

# Setup BGP model symlinks
setup-bgp:
	@echo "🔗 Setting up BGP model symlinks..."
	./scripts/setup-bgp-models.sh

# Validate all BGP models
validate:
	@echo "🧪 Validating BGP models..."
	./validate-bgp.sh
	./validate-nokia-bgp.sh
	./validate-openconfig-bgp.sh

# Test YANG tools
test:
	@echo "🔬 Testing YANG tools..."
	@if [ -f venv/bin/activate ]; then \
		source venv/bin/activate && python scripts/test-yang-tools.py; \
	else \
		echo "❌ Virtual environment not found. Run 'make setup-env' first."; \
	fi

# Build documentation
docs:
	@echo "📖 Building documentation..."
	@if [ -f venv/bin/activate ]; then \
		source venv/bin/activate && mkdocs build; \
	else \
		echo "❌ Virtual environment not found. Run 'make setup-env' first."; \
	fi

# Serve documentation locally
docs-serve:
	@echo "🌐 Serving documentation locally..."
	@if [ -f venv/bin/activate ]; then \
		source venv/bin/activate && mkdocs serve; \
	else \
		echo "❌ Virtual environment not found. Run 'make setup-env' first."; \
	fi

# Clean temporary files
clean:
	@echo "🧹 Cleaning temporary files..."
	rm -rf tmp/*.txt tmp/*.log
	rm -rf site/
	find . -name "*.pyc" -delete
	find . -name "__pycache__" -delete

# Show submodule status and sizes
status:
	@echo "📊 Submodule Status:"
	@git submodule status
	@echo ""
	@echo "📈 Repository Sizes:"
	@du -sh nokia/ open-config/ 2>/dev/null || echo "Some submodules not initialized"

# Quick benchmark of setup times
benchmark:
	@echo "⏱️  Benchmarking setup methods..."
	@echo "Testing shallow clone speed..."
	@time ./scripts/setup-submodules-fast.sh ci > /dev/null 2>&1 || echo "Benchmark failed"
