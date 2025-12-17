<?php

require __DIR__ . '/src/solution.php';

$input = file_get_contents(__DIR__ . '/input');

echo "Part 1: " . solve_part1($input) . PHP_EOL;
echo "Part 2: " . solve_part2($input) . PHP_EOL;
