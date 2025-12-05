package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func getMax(numStr string, first int, last int) (int, int) {
	max := -1
	maxIdx := -1

	for i := first; i < last; i++ {
		intChr := int(numStr[i] - '0')

		if intChr > max {
			max = intChr
			maxIdx = i
		}
	}
	return max, maxIdx
}

func getMaxJoltage(joltageStr string, numLength int) int {
	maxJoltage := 0
	oldIdxPos := 0
	idxPos := 0
	offset := len(joltageStr) - numLength + 1

	for {
		maxVal, maxIdx := getMax(joltageStr, idxPos, idxPos+offset)

		idxPos = maxIdx + 1
		maxJoltage = maxJoltage*10 + maxVal

		numLength -= 1
		offset = len(joltageStr) - (maxIdx - oldIdxPos) - numLength
		if numLength == 0 {
			return maxJoltage
		}
	}
}

func main() {
	result := 0

	data, err := os.Open("input")
	if err != nil {
		fmt.Println("There was an unexpected error")
		log.Fatal(err)
		return
	}
	defer data.Close()

	scanner := bufio.NewScanner(data)

	for scanner.Scan() {
		line := scanner.Text()
		result += getMaxJoltage(line, 12)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println(result)
}
