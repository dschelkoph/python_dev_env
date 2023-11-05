def add_two(x: int) -> int:
    """Add 2 to a positive integer.

    This is a sample output from the 'autodocstring' extension

    Args:
        x (int): Input integer that will be increased by 2

    Raises:
        ValueError: Thrown if x < 0

    Returns:
        int: x + 2
    """
    if x < 0:
        raise ValueError(f"x must be greater than 0. Current value: {x}")
    return x + 2


def add_three(x: int) -> int:
    return x + 3

