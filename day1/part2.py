MAX_DIALS = 100


def rotations_left(dial, clicks):
    clicks_to_zero = dial if dial != 0 else MAX_DIALS
    if clicks < clicks_to_zero:
        return 0
    return 1 + (clicks - clicks_to_zero) // MAX_DIALS


def rotations_right(dial, clicks):
    # Quantity of clicks from dial to full rotation (moves until I reach dial 0)
    clicks_to_zero = MAX_DIALS if dial == 0 else MAX_DIALS - dial
    if clicks < clicks_to_zero:
        return 0
    return 1 + (clicks - clicks_to_zero) // MAX_DIALS


def main():
    dial = 50
    password = 0

    with open("input", "r") as f:
        for raw in f:
            line = raw.strip()
            direction = line[0]
            clicks = int(line[1:])

            if direction == "L":
                password += rotations_left(dial, clicks)
                dial = (dial - clicks) % MAX_DIALS
            if direction == "R":
                password += rotations_right(dial, clicks)
                dial = (dial + clicks) % MAX_DIALS

    print(password)
    return 0


if __name__ == "__main__":
    main()
