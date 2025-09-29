#!/bin/bash
# Quick PyPI upload script for dln2-spi-wrapper

set -e  # Exit on any error

echo "=== Quick PyPI Upload ==="

# Check virtual environment
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "❌ Please activate virtual environment: source venv/bin/activate"
    exit 1
fi

# Check if package is built
if [ ! -f "dist/dln2_spi_wrapper-0.1.0-py3-none-any.whl" ]; then
    echo "📦 Building package first..."
    make clean
    make build
    make check
fi

echo "🚀 Uploading to PyPI (production)..."
echo ""
echo "⚠️  WARNING: This uploads to PRODUCTION PyPI!"
echo "PyPI API token is configured in ~/.pypirc"
echo ""

read -p "Continue with PyPI upload? (y/N): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Upload to PyPI
    python -m twine upload dist/*
    
    echo ""
    echo "🎉 Successfully uploaded to PyPI!"
    echo ""
    echo "📦 Your package is now available:"
    echo "   pip install dln2-spi-wrapper"
    echo ""
    echo "🌐 View on PyPI:"
    echo "   https://pypi.org/project/dln2-spi-wrapper/"
    echo ""
    echo "📝 Next steps:"
    echo "   - Test installation: pip install dln2-spi-wrapper"
    echo "   - Test CLI commands: dln2-spi-test --help"
    echo "   - Update GitHub releases with the package files"
else
    echo "❌ Upload cancelled"
    exit 0
fi
