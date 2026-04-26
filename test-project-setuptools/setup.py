from setuptools import setup, find_packages

setup(
    name="hello-pipery-setuptools",
    version="0.1.0",
    description="Test fixture using setuptools",
    package_dir={"": "src"},
    packages=find_packages(where="src"),
)
