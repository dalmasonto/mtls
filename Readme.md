# Server - Client mMTLS Handshake

1. Give permissions to `generate_certs.sh`

```sh
chmod +x generate_certs.sh
```

2. Run the script to generate the certificates. Enter all prompted fields.

```sh
./generate_certs.sh
```

3. Run the server

```sh
cargo run -- server
```

4. Run the client;

```sh
cargo run -- client
```

On successful run, the client will send an aqua JSON object and the server will respond with the same and both will print the simple JSON object.


Sample output

```sh
# Server

Received JSON: AquaJson { data: "Hello, Aqua-Chains!" }

# Client

Received:
AquaJson { data: "Hello, Aqua-Chains!" }
```

To run tests;

```sh
cargo test
```

