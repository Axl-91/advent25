# dial_solver.py
MAX_DIALS = 100


def main():
    dial = 50
    password = 0

    with open("input", "r") as f:
        for raw in f:
            line = raw.strip()
            direction = line[0]
            clicks = int(line[1:])

            for _ in range(clicks):
                if direction == "L":
                    dial = (dial - 1) % MAX_DIALS
                else:
                    dial = (dial + 1) % MAX_DIALS

                if dial == 0:
                    password += 1

    print(password)
    return 0


if __name__ == "__main__":
    main()
