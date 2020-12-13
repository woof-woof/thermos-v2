use std::env;
use std::io::prelude::*;
use std::net::TcpStream;
use std::error::Error;
use std::fs::File;

fn send(stream: &mut TcpStream, file: &String) -> Result<usize, std::io::Error> {
    println!("sending deploy data...");
    let mut file = File::open(file)?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    let _ = stream.write(contents.len().to_string().as_bytes());
    stream.write(contents.as_bytes())
}

fn run(addr: &String, file: &String) -> Result<(), Box<dyn Error>> {
    println!("preparing for deploy...");
    let mut stream = TcpStream::connect(addr)?;
    let _ = send(&mut stream, file)?;
    println!("sent deploy data...");
    let mut buffer = [0; 512];
    stream.read(&mut buffer)?;
    println!("Received: {}", String::from_utf8_lossy(&buffer));
    Ok(())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    println!("{:?}", args);
    if let Err(e) = run(&args[1], &args[2]) {
        println!("Error: {:?}", e);
    }
}