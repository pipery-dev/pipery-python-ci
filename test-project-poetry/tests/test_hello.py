import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
from hello_pipery_poetry import greet

def test_greet():
    assert greet("Pipery") == "Hello from Poetry, Pipery!"
