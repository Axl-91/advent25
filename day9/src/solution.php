<?php

function calculate_area(int $lenght, int $width): int
{
    return $lenght * $width;
}

function solvePart1(string $input): string
{
    $pos = 0;
    $rectangles_areas = [];

    $lines = explode("\n", trim($input));

    foreach ($lines as $line) {
        [$x, $y] = array_map('intval', explode(',', $line));

        $new_lines = array_slice($lines, $pos);

        foreach ($new_lines as $new_line) {
            // echo "Comparing: " . $line . " With " . $new_line . PHP_EOL;
            [$z, $w] = array_map('intval', explode(',', $new_line));

            $length = ($x >= $z) ? $x - $z + 1 : $z - $x + 1;
            $width = ($y >= $w) ? $y - $w + 1 : $w - $y + 1;
            // echo $length, " ", $width, PHP_EOL;
            $area = calculate_area($length, $width);
            array_push($rectangles_areas, $area);
            // echo "Area: " . $area . PHP_EOL;
        }
        $pos++;
    }

    $max = array_reduce($rectangles_areas, function ($acc, $val) {
        return ($acc > $val ? $acc : $val);
    }, 0);

    return $max;
}

function solvePart2(string $input): string
{
    $lines = explode("\n", trim($input));
    return "Value";
}
