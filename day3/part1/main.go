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

func getMaxJoltage(joltageStr string) int {
	first, firstIdx := getMax(joltageStr, 0, len(joltageStr)-1)
	second, _ := getMax(joltageStr, firstIdx+1, len(joltageStr))

	maxJoltage := first*10 + second
	return maxJoltage
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
		result += getMaxJoltage(line)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println(result)
}
