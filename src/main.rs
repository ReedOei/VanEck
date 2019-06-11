use std::env;

fn gen_seq(max: usize) {
    let mut pos = vec![0; max];

    let mut prev = 0;
    let mut cur = 0;

    println!("{}", cur);

    for i in 1..max {
        if pos[cur] == 0 {
            cur = 0;
        } else {
            cur = i - pos[cur];
        }

        pos[prev] = i;
        prev = cur;

        println!("{}", cur);
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();

    gen_seq(args[1].parse::<usize>().unwrap());
}

