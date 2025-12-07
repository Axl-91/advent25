use std::fs::read_to_string;

fn is_in_range(product: &str, ranges: &Vec<&str>) -> bool {
    let num_product: u64 = product.parse().unwrap();
    for range in ranges {
        let split_ranges: Vec<&str> = range.split("-").collect();
        let (min, max): (u64, u64) = (
            split_ranges[0].parse().unwrap(),
            split_ranges[1].parse().unwrap(),
        );

        if num_product >= min && num_product <= max {
            return true;
        }
    }
    return false;
}

fn part1() {
    let mut total_to_consume = 0;
    let input_data = read_to_string("input").expect("Failure at read");

    let split_data: Vec<&str> = input_data.split("\n\n").collect();
    let (ranges_str, products_str) = (split_data[0], split_data[1]);

    let ranges: Vec<&str> = ranges_str.lines().collect();
    let products: Vec<&str> = products_str.lines().collect();

    for product in products {
        if is_in_range(product, &ranges) {
            total_to_consume += 1;
        }
    }

    println!("{}", total_to_consume);
}

fn main() {
    part1();
}
