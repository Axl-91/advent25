<?php

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

function calculate_area(int $lenght, int $width): int
{
    return $lenght * $width;
}

function is_in_borders(array $pointA, array $pointB, array $borders): bool
{
    if (count($borders) == 0) return true;

    [$x, $y] = $pointA;
    [$z, $w] = $pointB;
    [$max_x, $min_x] = [max($x, $z), min($x, $z)];
    [$max_y, $min_y] = [max($y, $w), min($y, $w)];

    foreach (range($min_x, $max_x) as $pos_x) {
        $borders_on_x = array_filter($borders, fn($point) => $point[0] == $pos_x);
        foreach (range($min_y, $max_y) as $pos_y) {
            $point_bigger_y = array_find($borders_on_x, fn($point) => $pos_y >= $point[1]);
            $point_lower_y = array_find($borders_on_x, fn($point) => $pos_y <= $point[1]);

            if (empty($point_bigger_y) || empty($point_lower_y)) return false;
        }
    }
    return true;
}

function get_areas(array $points, array $borders = []): array
{
    $offset = 0;
    $rectangle_areas = [];

    foreach ($points as [$x, $y]) {
        $other_points = array_slice($points, $offset);

        foreach ($other_points as [$z, $w]) {
            $length = ($x >= $z) ? $x - $z + 1 : $z - $x + 1;
            $width = ($y >= $w) ? $y - $w + 1 : $w - $y + 1;
            if (is_in_borders([$x, $y], [$z, $w], $borders)) {
                $area = calculate_area($length, $width);
                array_push($rectangle_areas, $area);
            }
        }
        $offset++;
    }
    return $rectangle_areas;
}

function get_borders(array $points): array
{
    $offset = 0;
    $borders = $points;

    foreach ($points as [$x, $y]) {
        $other_points = array_slice($points, $offset);

        foreach ($other_points as [$z, $w]) {
            if ($x == $z && $y != $w) {
                $min_value = min($y, $w) + 1;
                $max_value =  max($y, $w) - 1;
                foreach (range($min_value, $max_value) as $v) {
                    if (empty(array_find($borders, fn($point) => $point[0] == $x && $point[1] == $v))) {
                        array_push($borders, [$x, $v]);
                    }
                }
            } elseif ($y == $w && $x != $z) {
                $min_value = min($x, $z) + 1;
                $max_value =  max($x, $z) - 1;
                foreach (range($min_value, $max_value) as $v) {
                    if (empty(array_find($borders, fn($point) => $point[0] == $v && $point[1] == $y))) {
                        array_push($borders, [$v, $y]);
                    }
                }
            }
        }
        $offset++;
    }
    return $borders;
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
    $borders = get_borders($points);
    echo "Finished Parsing Borders\n";

    $rectangle_areas = get_areas($points, $borders);

    $max = array_reduce($rectangle_areas, function ($acc, $val) {
        return ($acc > $val ? $acc : $val);
    }, 0);

    return $max;
}
