# Run rust-peer with docker-compose

This docker-compose file starts a local network of three rust-peers.

## Installing docker and docker-compose

Follow official instruction for
[docker](https://docs.docker.com/engine/install/) and
[docker-compose](https://docs.docker.com/compose/install/linux/#install-using-the-repository).

## Running local rust-peer network

1. Either `git clone` this repository locally and run `cd deploy/docker-compose`
   or download [`docker-compose.yml`](docker-compose.yml) directly.

2. Ensure you have the most up-to-date container images:

   ```bash
   docker-compose pull
   ```

3. Run the network:

   ```bash
   docker-compose up -d
   ```

## Accessing local rust-peer network

Using fluence-cli follow the
[example workflow](https://github.com/fluencelabs/fluence-cli/blob/main/docs/EXAMPLE.md#currently-supported-workflow-example)
appending `--relay <peer-multiaddr>` to `run` commands.

Local network multiaddresses:

| container | multiaddress                                                                        |
| --------- | ----------------------------------------------------------------------------------- |
| peer-1    | /ip4/127.0.0.1/tcp/9991/ws/p2p/12D3KooWBM3SdXWqGaawQDGQ6JprtwswEg3FWGvGhmgmMez1vRbR |
| peer-2    | /ip4/127.0.0.1/tcp/9992/ws/p2p/12D3KooWQdpukY3p2DhDfUfDgphAqsGu5ZUrmQ4mcHSGrRag6gQK |
| peer-3    | /ip4/127.0.0.1/tcp/9993/ws/p2p/12D3KooWRT8V5awYdEZm6aAV9HWweCEbhWd7df4wehqHZXAB7yMZ |
