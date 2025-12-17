<?php

function calculate_area(int $lenght, int $width): int
{
    return $lenght * $width;
}

function get_areas(array $points): array
{
    $pos = 0;
    $rectangle_areas = [];

    foreach ($points as [$x, $y]) {
        $other_points = array_slice($points, $pos);

        foreach ($other_points as [$z, $w]) {
            $length = ($x >= $z) ? $x - $z + 1 : $z - $x + 1;
            $width = ($y >= $w) ? $y - $w + 1 : $w - $y + 1;
            $area = calculate_area($length, $width);
            array_push($rectangle_areas, $area);
        }
        $pos++;
    }
    return $rectangle_areas;
}

function parse_input(string $input): array
{
    $points = [];
    $lines = explode("\n", trim($input));

    foreach ($lines as $line) {
        $point = array_map('intval', explode(',', $line));
        array_push($points, $point);
    }
    return $points;
}

function solve_part1(string $input): string
{
    $points = parse_input($input);
    $rectangle_areas = get_areas($points);

    $max = array_reduce($rectangle_areas, function ($acc, $val) {
        return ($acc > $val ? $acc : $val);
    }, 0);

    return $max;
}

function solve_part2(string $input): string
{
    $points = parse_input($input);

    return "Value";
}
