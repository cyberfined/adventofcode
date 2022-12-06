use std::fs::File;
use std::io::{self, Read};

fn is_uniq(chars: &[char]) -> bool {
    for i in 0..chars.len() {
        for j in i+1..chars.len() {
            if chars[i] == chars[j] {
                return false;
            }
        }
    }
    true
}

fn generic_solution(window_size: usize) -> io::Result<usize> {
    let mut file = File::open("input")?;
    let mut content = String::new();
    file.read_to_string(&mut content)?;
    let mut current_char = window_size;

    for chars in content.chars().collect::<Vec<char>>().windows(window_size) {
        if is_uniq(chars) {
            return Ok(current_char);
        }
        current_char += 1;
    }
    Err(io::Error::new(io::ErrorKind::Other, "failed to find an answer"))
}

fn first() -> io::Result<usize> {
    generic_solution(4)
}

fn second() -> io::Result<usize> {
    generic_solution(14)
}

fn main() -> io::Result<()> {
    let first_answer = first()?;
    println!("{}", first_answer);

    let second_answer = second()?;
    println!("{}", second_answer);
    Ok(())
}
