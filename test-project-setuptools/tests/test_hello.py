import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
from hello_pipery_setuptools import greet

def test_greet():
    assert greet("Pipery") == "Hello from setuptools, Pipery!"
