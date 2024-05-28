mod common;

use tokio::process::Command;
use reqwest::{Client, Certificate, Identity};
use std::fs;
use serde_json::json;
use mtls::AquaJson; // Import the AquaJson struct

#[tokio::test]
async fn test_server_starts() {
    // Start the server on a different port
    let port = 3032; // Use a different port for testing
    let mut server = common::start_server(port);

    // Add some delay to ensure server starts
    tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;

    // Set up client with mTLS
    let ca_cert = fs::read("ca/ca.crt").unwrap();
    let ca_cert = Certificate::from_pem(&ca_cert).unwrap();

    // Read the PKCS#12 file for the client identity
    let client_p12 = fs::read("ca/client_0.p12").unwrap();
    let identity = Identity::from_pkcs12_der(&client_p12, "1234").unwrap();

    let client = Client::builder()
        .add_root_certificate(ca_cert)
        .identity(identity)
        .https_only(true)
        .build()
        .unwrap();

    // Make a request to the server to verify it's running
    let res = client.get(&format!("https://localhost:{}", port))
        .send()
        .await;

    assert!(res.is_ok());

    // Stop the server
    common::stop_server(&mut server);
}

#[tokio::test]
async fn test_server_receives_json() {
    // Start the server on a different port
    let port = 3032; // Use a different port for testing
    let mut server = common::start_server(port);

    // Add some delay to ensure server starts
    tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;

    // Set up client with mTLS
    let ca_cert = fs::read("ca/ca.crt").unwrap();
    let ca_cert = Certificate::from_pem(&ca_cert).unwrap();

    // Read the PKCS#12 file for the client identity
    let client_p12 = fs::read("ca/client_0.p12").unwrap();
    let identity = Identity::from_pkcs12_der(&client_p12, "1234").unwrap();

    let client = Client::builder()
        .add_root_certificate(ca_cert)
        .identity(identity)
        .https_only(true)
        .build()
        .unwrap();

    // Create JSON data to send
    let json = json!({
        "data": "Hello, Aqua-Chains!"
    });

    // Send JSON data to the server
    let res = client.post(&format!("https://localhost:{}", port))
        .json(&json)
        .send()
        .await
        .unwrap();

    assert!(res.status().is_success());

    let response_json: serde_json::Value = res.json().await.unwrap();
    assert_eq!(response_json, json);

    // Stop the server
    common::stop_server(&mut server);
}
