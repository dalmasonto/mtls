use mtls::{run_server, run_client};


#[tokio::main]
async fn main() {
    let args: Vec<String> = std::env::args().collect();

    if args.len() < 2 {
        eprintln!("Usage: cargo run -- (server [port] | client)");
        return;
    }
    if args[1] == "server" {
        let port: u16 = if args.len() > 2 {
            args[2].parse().unwrap_or(3031)
        } else {
            3031
        };
        run_server(port).await;
    } else if args[1] == "client" {
        let client = run_client();
        client.await.unwrap();
    } else {
        panic!("Invalid argument: Use 'server or client' to run the server");
    }
    
}
