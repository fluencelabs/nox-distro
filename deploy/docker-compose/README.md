# Run rust-peer with docker-compose

This guide explains how to use docker-compose to start a local network of three
[rust-peer](https://github.com/fluencelabs/rust-peer) nodes.

## Introduction

The rust-peer network is a set of peer nodes that can communicate with each
other to share data and execute code. By running a local rust-peer network, you
can test your applications in a controlled environment without relying on
external networks.

## Prerequisites

Before you can run the rust-peer network, you need to have Docker and
docker-compose installed on your system. You can follow the official
instructions for installing Docker and installing docker-compose on your
operating system:

- [docker](https://docs.docker.com/engine/install/)
- [docker-compose](https://docs.docker.com/compose/install/linux/#install-using-the-repository)

## Starting local rust-peer network

1. `git clone` this repository locally and run `cd deploy/docker-compose`.

2. Pull the latest container images by running the following command:

   ```bash
   docker-compose pull
   ```

3.Start the rust-peer network by running the following command:

```bash
docker-compose up -d
```

This will start three rust-peer nodes, each listening on a different port.

## Accessing local rust-peer network

To interact with the rust-peer network, you can use the
[fluence-cli](https://github.com/fluencelabs/fluence-cli) tool.

You can follow the example
[workflow](https://github.com/fluencelabs/fluence-cli/blob/main/docs/EXAMPLE.md)
provided by Fluence Labs making these changes after running first step of the
example instruction:

- appending `--relay <peer-multiaddr>` to the `run` commands.
- changing `hosts` key in `fluence.yaml` to:
  ```yml
  hosts:
    defaultWorker:
      peerIds:
        - 12D3KooWBM3SdXWqGaawQDGQ6JprtwswEg3FWGvGhmgmMez1vRbR
  ```
- changing `relays` key in `fluence.yaml` to:
  ```yml
  relays:
    - /ip4/127.0.0.1/tcp/9991/ws/p2p/12D3KooWBM3SdXWqGaawQDGQ6JprtwswEg3FWGvGhmgmMez1vRbR
    - /ip4/127.0.0.1/tcp/9992/ws/p2p/12D3KooWQdpukY3p2DhDfUfDgphAqsGu5ZUrmQ4mcHSGrRag6gQK
    - /ip4/127.0.0.1/tcp/9993/ws/p2p/12D3KooWRT8V5awYdEZm6aAV9HWweCEbhWd7df4wehqHZXAB7yMZ
  ```

You can use the following table to find the multiaddress for each node:

| container | multiaddress                                                                        |
| --------- | ----------------------------------------------------------------------------------- |
| peer-1    | /ip4/127.0.0.1/tcp/9991/ws/p2p/12D3KooWBM3SdXWqGaawQDGQ6JprtwswEg3FWGvGhmgmMez1vRbR |
| peer-2    | /ip4/127.0.0.1/tcp/9992/ws/p2p/12D3KooWQdpukY3p2DhDfUfDgphAqsGu5ZUrmQ4mcHSGrRag6gQK |
| peer-3    | /ip4/127.0.0.1/tcp/9993/ws/p2p/12D3KooWRT8V5awYdEZm6aAV9HWweCEbhWd7df4wehqHZXAB7yMZ |

## Running with observability stack

Stack consists of:

- [Prometheus](https://prometheus.io/) - TSDB that collects and stores metrics
- [Loki](https://grafana.com/logs/) - lightweight centralized logging solution
- [Promtail](https://grafana.com/docs/loki/latest/clients/promtail/) - log
  collection agent
- [Grafana](https://grafana.com/grafana/) - data visualization tool

To set it up run:

```bash
docker-compose -f docker-compose.yml -f docker-compose.observability.yml up -d
```

Grafana will have automatically preprovisioned dashboards:

- rust-peer stats - overview of rust-peer network
- Service metrics - detailed stats on deployed services

You can find Grafana at http://localhost:3000. To access rust-peer logs use
`Explore` tab and chose `Loki` datasource.
