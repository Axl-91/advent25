package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func getMaxJoltage(joltageString string) int {
	first := -1
	firstIdx := -1
	second := -1

	for i := 0; i < len(joltageString)-1; i++ {
		intChr := int(joltageString[i] - '0')

		if intChr > first {
			first = intChr
			firstIdx = i
		}
	}

	for i := firstIdx + 1; i < len(joltageString); i++ {
		intChr := int(joltageString[i] - '0')
		if intChr > second {
			second = intChr
		}
	}

	return (first*10 + second)
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
