import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))
from hello_broken import greet

def test_greet():
    # This test expects the WRONG output on purpose — should FAIL
    assert greet("Pipery") == "Goodbye, Pipery!", "Expected test to fail"
