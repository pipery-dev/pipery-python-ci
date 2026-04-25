from hello_pipery import greet


def test_greet():
    assert greet("Pipery") == "Hello, Pipery!"


def test_greet_empty():
    assert greet("") == "Hello, !"
