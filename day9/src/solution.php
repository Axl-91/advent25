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

function calculate_area(array $pointA, array $pointB): int
{
    [$x, $y] = $pointA;
    [$z, $w] = $pointB;

    $length = ($x >= $z) ? $x - $z + 1 : $z - $x + 1;
    $width = ($y >= $w) ? $y - $w + 1 : $w - $y + 1;

    return $length * $width;
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
            if (is_in_borders([$x, $y], [$z, $w], $borders)) {
                $area = calculate_area([$x, $y], [$z, $w]);
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


function solve_part1(string $input): string
{
    $points = parse_input($input);
    [$max_area, $max_point] = get_max_area($points);

    echo "Max Point: " . json_encode($max_point) . PHP_EOL;

    return $max_area;
}

# Create the HashMap of X & Y for compress and decompress values
function create_compress_map(array $points): array
{
    $xValues = array_unique(array_column($points, 0));
    $yValues = array_unique(array_column($points, 1));
    sort($xValues);
    sort($yValues);
    $xMap = array_flip(array_values($xValues));
    $yMap = array_flip(array_values($yValues));

    return [$xMap, $yMap];
}

# Take array of 2d points and compress them to the min value posisble
# starting by 0 in base of the order of X and Y
function compress_points(array $points): array
{
    $new_points = [];

    [$xMap, $yMap] = create_compress_map($points);

    foreach ($points as [$x, $y]) {
        array_push($new_points, [$xMap[$x], $yMap[$y]]);
    }

    return [$new_points, [$xMap, $yMap]];
}


# Decompress the two 2d values in $compressed_points in base of their $decompress_map
function decompress_points(array $decompress_map, array $compressed_points): array
{
    [$xMap, $yMap] = $decompress_map;
    [[$x, $y], [$z, $w]] = $compressed_points;

    return [
        [
            array_search($x, $xMap),
            array_search($y, $yMap)
        ],
        [
            array_search($z, $xMap),
            array_search($w, $yMap)
        ],
    ];
}

function solve_part2(string $input): string
{
    # Parse input to store array of 2D values
    # Compress this values to minimize the distances
    # Create borders array to check validity of area
    $points = parse_input($input);
    [$new_points, $points_map] = compress_points($points);
    $borders = get_borders($new_points);

    # Get the values that generate the max area
    # Decompress the values to find the "real" max area
    [$max_area, $max_point] = get_max_area($new_points, $borders);
    $max_point = decompress_points($points_map, $max_point);
    [$pointA, $pointB] = $max_point;

    $max_area = calculate_area($pointA, $pointB);

    echo "Max Point: " . json_encode($max_point) . PHP_EOL;

    return $max_area;
}
