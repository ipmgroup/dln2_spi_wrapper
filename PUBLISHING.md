# Publishing Guide

This document explains how to publish the `dln2-spi-wrapper` package to PyPI.

## Prerequisites

1. **PyPI account**: Create accounts on both:
   - [TestPyPI](https://test.pypi.org/account/register/) (for testing)
   - [PyPI](https://pypi.org/account/register/) (for production)

2. **API Tokens**: Generate API tokens for both TestPyPI and PyPI:
   - TestPyPI: https://test.pypi.org/manage/account/token/
   - PyPI: https://pypi.org/manage/account/token/

3. **Configure credentials** in `~/.pypirc`:
   ```ini
   [distutils]
   index-servers = 
       pypi
       testpypi

   [pypi]
   username = __token__
   password = pypi-YOUR_ACTUAL_PYPI_TOKEN_HERE

   [testpypi]
   repository = https://test.pypi.org/legacy/
   username = __token__
   password = pypi-YOUR_ACTUAL_TESTPYPI_TOKEN_HERE
   ```

   **Note**: Replace `YOUR_ACTUAL_*_TOKEN_HERE` with your actual API tokens from the websites above.

4. **Alternative: Using environment variables** (more secure):
   ```bash
   # Set tokens as environment variables
   export TWINE_USERNAME=__token__
   export TWINE_PASSWORD=pypi-YOUR_TESTPYPI_TOKEN_HERE  # for TestPyPI
   # OR for PyPI:
   # export TWINE_PASSWORD=pypi-YOUR_PYPI_TOKEN_HERE
   
   # Then upload without ~/.pypirc
   twine upload --repository testpypi dist/*
   ```

## Development Workflow

### 1. Setup Development Environment

```bash
# Clone the repository
git clone https://github.com/ipmgroup/dln2_spi_wrapper.git
cd dln2_spi_wrapper

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install development dependencies
pip install -e ".[dev]"
```

### 2. Development Commands

```bash
# Install dev tools and pre-commit hooks
make install-dev

# Format code
make format

# Run linting
make lint

# Run tests (when implemented)
make test

# Build package
make build

# Clean build artifacts
make clean
```

### 3. Testing the Package

```bash
# Test installation from wheel
make test-install

# Test console commands
dln2-spi-test --help
dln2-spi-bpw-test --help

# Test importing
python -c "from dln2_spi_wrapper import SpiDev; print('Success!')"
```

## Publishing Process

### 1. Update Version

Update version in:
- `dln2_spi_wrapper/__init__.py`
- `pyproject.toml`

```bash
# Example: updating to v0.1.1
sed -i 's/__version__ = "0.1.0"/__version__ = "0.1.1"/' dln2_spi_wrapper/__init__.py
sed -i 's/version = "0.1.0"/version = "0.1.1"/' pyproject.toml
```

### 2. Build Package

```bash
# Clean previous builds
make clean

# Build source distribution and wheel
make build

# Verify build contents
tar -tzf dist/dln2_spi_wrapper-*.tar.gz
unzip -l dist/dln2_spi_wrapper-*-py3-none-any.whl
```

### 3. Test on TestPyPI

```bash
# Upload to TestPyPI
make upload-test

# Test installation from TestPyPI
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple dln2-spi-wrapper

# Test functionality
python -c "from dln2_spi_wrapper import SpiDev; print('TestPyPI install works!')"
```

### 4. Release to PyPI

```bash
# Upload to production PyPI
make upload

# Verify on PyPI
pip install dln2-spi-wrapper
```

### 5. Create Git Tag and Release

```bash
# Create and push tag
make tag TAG=v0.1.1

# Create GitHub release
# Go to: https://github.com/ipmgroup/dln2_spi_wrapper/releases/new
# - Tag: v0.1.1
# - Title: Release v0.1.1
# - Description: Release notes
# - Attach: dist/dln2_spi_wrapper-0.1.1.tar.gz and .whl files
```

## Version Management

This project uses semantic versioning (SemVer):
- **MAJOR**: Incompatible API changes
- **MINOR**: Add functionality in backwards compatible manner  
- **PATCH**: Backwards compatible bug fixes

Examples:
- `0.1.0` → `0.1.1`: Bug fix
- `0.1.0` → `0.2.0`: New feature
- `0.1.0` → `1.0.0`: Breaking change

## Release Checklist

Before releasing:

- [ ] All tests pass
- [ ] Code formatted with `black`
- [ ] No linting errors
- [ ] Version updated in all files
- [ ] README.md updated if needed
- [ ] CHANGELOG.md updated (if exists)
- [ ] Built package tested locally
- [ ] Tested on TestPyPI
- [ ] Git changes committed and pushed

## Manual Publishing Commands

If you prefer manual commands over Makefile:

```bash
# Install publishing tools
pip install build twine

# Build
python -m build

# Upload to TestPyPI
python -m twine upload --repository testpypi dist/*

# Upload to PyPI  
python -m twine upload dist/*

# Check package
python -m twine check dist/*
```

## Troubleshooting

### Common Issues

1. **ImportError during build**
   - Ensure all dependencies are properly specified
   - Check relative imports in `__init__.py`

2. **Missing files in package**
   - Check `MANIFEST.in` for included files
   - Verify `pyproject.toml` package configuration

3. **Upload failures**
   - Verify API tokens in `~/.pypirc`
   - Ensure unique version number
   - Check package name availability

4. **Console scripts not working**
   - Verify entry points in `pyproject.toml`
   - Check import paths in console script functions
   - Test with `pip install -e .`

### Testing Package Contents

```bash
# List wheel contents
python -m zipfile -l dist/*.whl

# List source distribution contents  
tar -tzf dist/*.tar.gz

# Test wheel installation
pip install dist/*.whl --force-reinstall
```

## Automated CI/CD (Future)

Consider setting up GitHub Actions for:
- Automated testing on multiple Python versions
- Automated building and publishing on tag push
- Code quality checks on pull requests

Example workflow location: `.github/workflows/publish.yml`
