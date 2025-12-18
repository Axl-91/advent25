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
        foreach ([$min_y, $max_y] as $pos_y) {
            $point_bigger_y = array_find($borders_on_x, fn($point) => $pos_y >= $point[1]);
            $point_lower_y = array_find($borders_on_x, fn($point) => $pos_y <= $point[1]);

            if (empty($point_bigger_y) || empty($point_lower_y)) return false;
        }
    }

    foreach (range($min_y, $max_y) as $pos_y) {
        $borders_on_y = array_filter($borders, fn($point) => $point[1] == $pos_y);
        foreach ([$min_x, $max_x] as $pos_x) {
            $point_bigger_y = array_find($borders_on_y, fn($point) => $pos_x >= $point[0]);
            $point_lower_y = array_find($borders_on_y, fn($point) => $pos_x <= $point[0]);

            if (empty($point_bigger_y) || empty($point_lower_y)) return false;
        }
    }
    return true;
}

function get_max_area(array $points, array $borders = []): array
{
    $max_area = -1;
    $max_points = [];
    $offset = 0;

    foreach ($points as [$x, $y]) {
        $other_points = array_slice($points, $offset);

        foreach ($other_points as [$z, $w]) {
            $length = ($x >= $z) ? $x - $z + 1 : $z - $x + 1;
            $width = ($y >= $w) ? $y - $w + 1 : $w - $y + 1;
            if (is_in_borders([$x, $y], [$z, $w], $borders)) {
                $area = calculate_area($length, $width);
                if ($area > $max_area) {
                    $max_points = [[$x, $y], [$z, $w]];
                    $max_area = $area;
                }
            }
        }
        $offset++;
    }
    return [$max_area, $max_points];
}

function array_contains(array $array, array $point)
{
    return !empty(array_find(
        $array,
        fn($p) => $p[0] == $point[0] && $p[1] == $point[1]
    ));
}

function add_borders(array &$borders, array $pointA, array $pointB)
{
    [$x, $y] = $pointA;
    [$z, $w] = $pointB;

    if ($x == $z && $y != $w) {
        $min_value = min($y, $w);
        $max_value =  max($y, $w);
        foreach (range($min_value, $max_value) as $v) {
            if (!array_contains($borders, [$x, $v])) {
                array_push($borders, [$x, $v]);
            }
        }
    }

    if ($y == $w && $x != $z) {
        $min_value = min($x, $z);
        $max_value =  max($x, $z);
        foreach (range($min_value, $max_value) as $v) {
            if (!array_contains($borders, [$v, $y])) {
                array_push($borders, [$v, $y]);
            }
        }
    }
}

function get_borders(array $points): array
{
    $offset = 1;
    $borders = [];

    foreach ($points as [$x, $y]) {
        if ($offset == count($points)) $offset = 0;

        [$z, $w] = $points[$offset];

        add_borders($borders, [$x, $y], [$z, $w]);

        $offset++;
    }
    return $borders;
}

function decompress_points(array $points, array $compress_point): array
{

    $xValues = array_unique(array_column($points, 0));
    $yValues = array_unique(array_column($points, 1));
    sort($xValues);
    sort($yValues);
    $xMap = array_flip(array_values($xValues));
    $yMap = array_flip(array_values($yValues));

    return [
        [
            array_search($compress_point[0][0], $xMap),
            array_search($compress_point[0][1], $yMap)
        ],
        [
            array_search($compress_point[1][0], $xMap),
            array_search($compress_point[1][1], $yMap)
        ],
    ];
}

function compress_points(array $points): array
{
    $points_compressed = [];

    $xValues = array_unique(array_column($points, 0));
    $yValues = array_unique(array_column($points, 1));
    sort($xValues);
    sort($yValues);
    $xMap = array_flip(array_values($xValues));
    $yMap = array_flip(array_values($yValues));

    foreach ($points as [$x, $y]) {
        array_push($points_compressed, [$xMap[$x], $yMap[$y]]);
    }

    return $points_compressed;
}

function solve_part1(string $input): string
{
    $points = parse_input($input);
    [$max_area, $max_point] = get_max_area($points);

    echo "Max Point: " . json_encode($max_point) . PHP_EOL;

    return $max_area;
}

function solve_part2(string $input): string
{
    $points = parse_input($input);

    $compressed_points = compress_points($points);

    $borders = get_borders($compressed_points);

    [$max_area, $max_point] = get_max_area($compressed_points, $borders);

    $max_point = decompress_points($points, $max_point);

    [[$x, $y], [$z, $w]] = $max_point;

    $length = ($x >= $z) ? $x - $z + 1 : $z - $x + 1;
    $width = ($y >= $w) ? $y - $w + 1 : $w - $y + 1;
    $max_area = calculate_area($length, $width);

    echo "Max Point: " . json_encode($max_point) . PHP_EOL;

    return $max_area;
}
