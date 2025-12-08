use std::{cmp, fs::read_to_string};

fn get_min_max_range(range_str: &str) -> (u64, u64) {
    let split_ranges: Vec<&str> = range_str.split("-").collect();
    let (min, max): (u64, u64) = (
        split_ranges[0].parse().unwrap(),
        split_ranges[1].parse().unwrap(),
    );

    (min, max)
}

fn is_in_range(product: &str, ranges: &Vec<&str>) -> bool {
    let num_product: u64 = product.parse().unwrap();
    for range in ranges {
        let (min, max) = get_min_max_range(range);

        if num_product >= min && num_product <= max {
            return true;
        }
    }
    return false;
}

fn part1(ranges: Vec<&str>, products: Vec<&str>) {
    let mut total_to_consume = 0;

    for product in products {
        if is_in_range(product, &ranges) {
            total_to_consume += 1;
        }
    }

    println!("Part 1: {}", total_to_consume);
}

fn combine_ranges_and_count(mut ranges: Vec<(u64, u64)>) -> u64 {
    ranges.sort_by_key(|&(start, _end)| start);

    let mut total: u64 = 0;
    let mut current_range = ranges[0];

    for &(min, max) in &ranges[1..] {
        if min <= current_range.1 + 1 {
            current_range.1 = cmp::max(current_range.1, max);
        } else {
            total += current_range.1 - current_range.0 + 1;
            current_range = (min, max);
        }
    }

    total += current_range.1 - current_range.0 + 1;
    total
}

fn part2(ranges: Vec<&str>) {
    let ranges: Vec<(u64, u64)> = ranges
        .iter()
        .map(|range| get_min_max_range(range))
        .collect();

    let total_fresh = combine_ranges_and_count(ranges);

    println!("Part 2: {}", total_fresh);
}

fn main() {
    let input_data = read_to_string("input").expect("Failure at read");

    let split_data: Vec<&str> = input_data.split("\n\n").collect();
    let (ranges_str, products_str) = (split_data[0], split_data[1]);

    let ranges: Vec<&str> = ranges_str.lines().collect();
    let products: Vec<&str> = products_str.lines().collect();

    part1(ranges.clone(), products);
    part2(ranges);
}
