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

echo "✅ Virtual environment: $VIRTUAL_ENV"

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
echo "🔧 Publishing Options:"
echo "1) TestPyPI (for testing) - requires TestPyPI API token"
echo "2) PyPI (production) - requires PyPI API token" 
echo "3) Cancel"
echo ""
read -p "Choose option (1/2/3): " -n 1 -r
echo

case $REPLY in
    1)
        echo ""
        echo "🚀 Uploading to TestPyPI..."
        echo "TestPyPI credentials are configured in ~/.pypirc"
        echo ""
        read -p "Continue with TestPyPI upload? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            make upload-test
            echo ""
            echo "✅ TestPyPI upload completed!"
            echo ""
            echo "🔍 To test the uploaded package:"
            echo "   pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple dln2-spi-wrapper"
            echo ""
            echo "🌐 View on TestPyPI:"
            echo "   https://test.pypi.org/project/dln2-spi-wrapper/"
        else
            echo "❌ TestPyPI upload cancelled"
        fi
        ;;
    2)
        echo ""
        echo "🚀 Uploading to PyPI (PRODUCTION)..."
        echo "⚠️  WARNING: This will publish to production PyPI!"
        echo "PyPI credentials are configured in ~/.pypirc"
        echo ""
        read -p "Are you sure you want to upload to production PyPI? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            make upload-pypi
            echo ""
            echo "🎉 PyPI upload completed!"
            echo ""
            echo "🔍 Your package is now available:"
            echo "   pip install dln2-spi-wrapper"
            echo ""
            echo "🌐 View on PyPI:"
            echo "   https://pypi.org/project/dln2-spi-wrapper/"
        else
            echo "❌ PyPI upload cancelled"
        fi
        ;;
    3|*)
        echo "❌ Upload cancelled by user"
        exit 0
        ;;
esac
