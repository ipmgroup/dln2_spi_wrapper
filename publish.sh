#!/bin/bash
# Auto-publish script for dln2-spi-wrapper

set -e  # Exit on any error

echo "=== DLN2 SPI Wrapper Publishing Script ==="

# Check if we're in virtual environment
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "❌ No virtual environment detected. Please activate venv first:"
    echo "   source venv/bin/activate"
    exit 1
fi

# Check if we have API token
if [[ "$TWINE_PASSWORD" == "" ]]; then
    echo "❌ TWINE_PASSWORD environment variable not set."
    echo "   Set your TestPyPI API token:"
    echo "   export TWINE_USERNAME=__token__"
    echo "   export TWINE_PASSWORD=pypi-YOUR_TESTPYPI_TOKEN"
    exit 1
fi

echo "✅ Virtual environment: $VIRTUAL_ENV"
echo "✅ TWINE credentials configured"

# Clean and build
echo ""
echo "🧹 Cleaning previous builds..."
make clean

echo ""
echo "🔨 Building package..."
make build

echo ""
echo "✅ Checking package integrity..."
make check

echo ""
echo "📋 Package contents:"
make upload-test-dry

echo ""
read -p "🚀 Upload to TestPyPI? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Uploading to TestPyPI..."
    make upload-test
    
    echo ""
    echo "✅ Upload completed!"
    echo ""
    echo "🔍 To test the uploaded package:"
    echo "   pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple dln2-spi-wrapper"
    echo ""
    echo "🌐 View on TestPyPI:"
    echo "   https://test.pypi.org/project/dln2-spi-wrapper/"
else
    echo "❌ Upload cancelled by user"
    exit 0
fi
