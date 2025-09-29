.PHONY: help install install-dev test lint format clean build upload docs

help:  ## Show this help message
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

install:  ## Install package in normal mode
	pip install .

install-dev:  ## Install package in development mode with all dependencies
	pip install -e ".[dev]"
	pre-commit install

test:  ## Run tests
	pytest tests/ -v --cov=dln2_spi_wrapper --cov-report=html --cov-report=term

lint:  ## Run linting tools
	flake8 dln2_spi_wrapper/
	mypy dln2_spi_wrapper/

format:  ## Format code with black
	black dln2_spi_wrapper/

clean:  ## Clean build artifacts
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	find . -path "./venv" -prune -o -path "./.venv" -prune -o -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -path "./venv" -prune -o -path "./.venv" -prune -o -name "*.pyc" -delete 2>/dev/null || true

##@ Building and Distribution

build:  ## Build wheel and source distribution
	python -m build

check:  ## Check package with twine
	@pip show twine >/dev/null 2>&1 || pip install twine
	python -m twine check dist/*

upload-test:  ## Upload to TestPyPI
	@pip show twine >/dev/null 2>&1 || pip install twine
	python -m twine upload --repository testpypi dist/*

upload-test-dry:  ## Dry-run upload to TestPyPI (check without uploading)
	@pip show twine >/dev/null 2>&1 || pip install twine
	@echo "=== DRY RUN: This would upload the following files to TestPyPI ==="
	@ls -la dist/
	@echo "=== To actually upload, run: make upload-test ==="

upload:  ## Upload to PyPI (production)
	@pip show twine >/dev/null 2>&1 || pip install twine
	python -m twine upload dist/*

upload-pypi:  ## Upload to PyPI (production) - alias
	@pip show twine >/dev/null 2>&1 || pip install twine
	python -m twine upload --repository pypi dist/*

##@ Documentation

docs:  ## Build documentation (if using Sphinx)
	@echo "Documentation building not implemented yet"

help-upload:  ## Show upload help and instructions
	@echo "📦 PyPI Upload Instructions:"
	@echo ""
	@echo "1️⃣  PyPI API tokens are configured in ~/.pypirc"
	@echo ""
	@echo "2️⃣  Upload to TestPyPI (testing):"
	@echo "     make upload-test"
	@echo ""
	@echo "3️⃣  Upload to PyPI (production):"
	@echo "     make upload-pypi"
	@echo ""
	@echo "📝 Or use interactive script: ./publish.sh"

##@ Testing package

test-install:  ## Test installation from built package
	pip uninstall -y dln2-spi-wrapper || true
	pip install dist/*.whl

example:  ## Run example test
	dln2-spi-test --help

##@ Git workflows

tag:  ## Create and push a new tag (use with TAG=v0.1.0)
	@if [ -z "$(TAG)" ]; then echo "Usage: make tag TAG=v0.1.0"; exit 1; fi
	git tag -a $(TAG) -m "Release $(TAG)"
	git push origin $(TAG)

pre-commit:  ## Run pre-commit hooks on all files
	pre-commit run --all-files
