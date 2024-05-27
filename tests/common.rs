use std::process::{Command, Child};

pub fn start_server(port: u16) -> Child {
    Command::new("cargo")
        .arg("run")
        .arg("--")
        .arg("server")
        .arg(port.to_string())
        .spawn()
        .expect("Failed to start server")
}

pub fn stop_server(child: &mut Child) {
    child.kill().expect("Failed to kill server process");
}