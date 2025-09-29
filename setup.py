#!/usr/bin/env python3
"""
Setup script for dln2-spi-wrapper package.
"""

from setuptools import setup, find_packages
import os

# Read the README file
def read_readme():
    readme_path = os.path.join(os.path.dirname(__file__), 'README.md')
    if os.path.exists(readme_path):
        with open(readme_path, 'r', encoding='utf-8') as f:
            return f.read()
    return "DLN2 SPI Wrapper - A Python library for interfacing with DLN2 SPI adapters"

# Read version from package
def read_version():
    version_file = os.path.join(os.path.dirname(__file__), 'dln2_spi_wrapper', '__init__.py')
    if os.path.exists(version_file):
        with open(version_file, 'r', encoding='utf-8') as f:
            for line in f:
                if line.startswith('__version__'):
                    return line.split('=')[1].strip().strip('"').strip("'")
    return "0.1.0"

setup(
    name="dln2-spi-wrapper",
    version=read_version(),
    author="IPM Group",
    author_email="",
    description="A Python library for interfacing with DLN2 SPI adapters with spidev-compatible API",
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    url="https://github.com/ipmgroup/dln2_spi_wrapper",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: System :: Hardware :: Hardware Drivers",
        "License :: OSI Approved :: Apache Software License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Operating System :: POSIX :: Linux",
        "Operating System :: Microsoft :: Windows",
        "Operating System :: MacOS",
    ],
    python_requires=">=3.7",
    install_requires=[
        "pyusb>=1.0.0",
    ],
    extras_require={
        "dev": [
            "pytest>=6.0",
            "pytest-cov",
            "black",
            "flake8",
            "mypy",
        ],
    },
    entry_points={
        "console_scripts": [
            "dln2-spi-test=dln2_spi_wrapper.examples.spidev_test:main",
            "dln2-spi-bpw-test=dln2_spi_wrapper.examples.bpw_tester:main",
        ],
    },
    project_urls={
        "Bug Reports": "https://github.com/ipmgroup/dln2_spi_wrapper/issues",
        "Source": "https://github.com/ipmgroup/dln2_spi_wrapper",
        "Documentation": "https://github.com/ipmgroup/dln2_spi_wrapper/blob/master/README.md",
    },
    keywords="dln2 spi usb hardware driver spidev",
    include_package_data=True,
    zip_safe=False,
)
