MAX_DIALS = 100


def main():
    dial = 50
    password = 0

    with open("input", "r") as fileInput:
        for line in fileInput:
            line = line.strip()
            direction = line[0]
            clicks = int(line[1:])

            if direction == "L":
                dial = (dial - clicks) % MAX_DIALS
            elif direction == "R":
                dial = (dial + clicks) % MAX_DIALS

            if dial == 0:
                password += 1

    print(password)
    return 0


if __name__ == "__main__":
    main()
