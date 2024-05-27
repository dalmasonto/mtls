use std::process::{Command, Child};

pub fn start_server() -> Child {
    Command::new("cargo")
        .arg("run")
        .arg("--")
        .arg("server")
        .spawn()
        .expect("Failed to start server")
}

pub fn stop_server(child: &mut Child) {
    child.kill().expect("Failed to kill server process");
}