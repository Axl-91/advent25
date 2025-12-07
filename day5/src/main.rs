use std::{fs::File, io::Read};

fn main() {
    let file = File::open("input_test");
    let mut s = String::new();

    if let Ok(mut file) = file {
        _ = file.read_to_string(&mut s);
        println!("{}", s)
    }
    println!("Hello, world!");
}
