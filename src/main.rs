use std::env;
use std::io::BufReader;
use std::io::BufRead;
use std::fs::File;

use std::collections::HashMap;

fn gen_seq() {
    let mut pos: HashMap<usize, usize> = HashMap::new();

    let mut prev = 0;
    let mut cur = 0;

    println!("{}", cur);

    let mut i = 1;
    loop {
        if pos[&cur] == 0 {
            cur = 0;
        } else {
            cur = i - pos[&cur];
        }

        pos.insert(prev, i);
        prev = cur;

        println!("{}", cur);

        i += 1;
    }
}

fn search(filename: String) {
    let mut i = 0;
    let mut tn = 0;

    let mut known: HashMap<usize, usize> = HashMap::new();

    let f = File::open(filename).unwrap();
    let file = BufReader::new(&f);

    for line in file.lines() {
        let l = line.unwrap();

        let x = l.parse::<usize>().unwrap();

        if x >= i && !known.contains_key(&x) {
            known.insert(x, tn);
        }

        if known.contains_key(&i) {
            println!("\rFound {} at term {}                 ", i, known[&i]);
            known.remove(&i);
            i += 1;
        } else {
            print!("\rSearching for {} at term {}", i, tn);
        }

        tn += 1;
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() > 1 && args[1] == "search" {
        search(args[2].clone());
    } else {
        gen_seq();
    }
}

