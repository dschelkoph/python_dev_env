import pytest

from sample_package import adder


def test_add_two_success():
    assert adder.add_two(x=2) == 4


def test_add_two_fail():
    with pytest.raises(ValueError):
        adder.add_two(-2)
