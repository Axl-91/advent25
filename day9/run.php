<?php

require __DIR__ . '/src/solution.php';

$input = file_get_contents(__DIR__ . '/input_test');

echo "Part 1: " . solvePart1($input) . PHP_EOL;
echo "Part 2: " . solvePart2($input) . PHP_EOL;
