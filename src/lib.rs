use warp::Filter;
use serde::{Deserialize, Serialize};
use tokio::fs::File;
use tokio::io::AsyncReadExt;
use reqwest::Identity;

#[derive(Deserialize, Serialize, Debug)]
pub struct AquaJson {
    // Define the structure of the JSON data here
    pub data: String,
}

pub async fn run_server() {
    let routes = warp::post()
        .and(warp::body::json())
        .map(|json: AquaJson| {
            println!("Received JSON: {:?}", json);
            warp::reply::json(&json)  // Echo back the received JSON
        });

    warp::serve(routes)
        .tls()
        .key_path("ca/localhost.key")
        .cert_path("ca/localhost.bundle.crt")
        .client_auth_required_path("ca/ca.crt")
        .run(([0, 0, 0, 0], 3031))
        .await;
}

pub async fn run_client() -> Result<(), reqwest::Error> {
    // Use this for successful result
    let server_ca_file_loc = "ca/ca.crt";
    // Use this for a failed result
    // let server_ca_file_loc = "ca/second_ca.crt";
    
    let mut buf = Vec::new();
    File::open(server_ca_file_loc)
        .await
        .unwrap()
        .read_to_end(&mut buf)
        .await
        .unwrap();
    let cert = reqwest::Certificate::from_pem(&buf)?;

    #[cfg(feature = "native-tls")]
    async fn get_identity() -> Identity {
        let client_p12_file_loc = "ca/second_client.p12";
        let mut buf = Vec::new();
        File::open(client_p12_file_loc)
            .await
            .unwrap()
            .read_to_end(&mut buf)
            .await
            .unwrap();
        reqwest::Identity::from_pkcs12_der(&buf, "1234").unwrap()
    }

    #[cfg(feature = "rustls-tls")]
    async fn get_identity() -> Identity {
        let client_pem_file_loc = "ca/second_client.pem";
        let mut buf = Vec::new();
        File::open(client_pem_file_loc)
            .await
            .unwrap()
            .read_to_end(&mut buf)
            .await
            .unwrap();
        reqwest::Identity::from_pem(&buf).unwrap()
    }

    let identity = get_identity().await;

    let client = reqwest::Client::builder()
        .add_root_certificate(cert)
        .identity(identity)
        .https_only(true)
        .build()?;

    let json = AquaJson {
        data: String::from("Hello, Aqua-Chains!"),
    };

    let res = client.post("https://localhost:3031")
        .json(&json)
        .send()
        .await?;

    println!("Received:");
    println!("{:?}", res.json::<AquaJson>().await?);

    Ok(())
}
