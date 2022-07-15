# node-distro

The distributive and packaging of the Fluence node.

Currently provides Network Dashboard as a side-car.

## Image tags

| Container flavor | IPFS daemon | binaries                                   |
| ---------------- | ----------- | ------------------------------------------ |
| minimal          | ❌           | curl                                       |
| ipfs             | ✅           | curl, ipfs                                 |
| rich             | ✅           | curl, ipfs, ceramic, bitcoin cli, geth cli |

### minimal

Contains Fluence Node itself and some builtin services:

- [aqua-ipfs](https://github.com/fluencelabs/aqua-ipfs)
- aqua-dht
- [trust-graph](https://github.com/fluencelabs/trust-graph)
- [registry](https://github.com/fluencelabs/registry)

For those who want to run IPFS node separately. Serves as a base image for all
other image flavours.

### ipfs

Fluence Node packaged with
[IPFS node](https://docs.ipfs.io/how-to/command-line-quick-start/#take-your-node-online)
running inside container.

### rich

Fluence Node packaged with IPFS node,
[Ceramic](https://developers.ceramic.network/learn/welcome/) CLI and some other
binaries like bitcoin-cli or
[geth](https://geth.ethereum.org/docs/interface/command-line-options).

## Configuration

### Environmental variables

| variable                                         | default           | description                                 |
| ------------------------------------------------ | ----------------- | ------------------------------------------- |
| `CERAMIC_HOST`                                   |                   | ceramic daemon address                      |
| `IPFS_PATH`                                      | `/config/ipfs`    | IPFS node data directory                    |
| `IPFS_LOG_PATH`                                  | `$IPFS_PATH/logs` | directory where IPFS will store its logs    |
| `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR`   |                   | IPFS node address used by aqua-ipfs builtin |
| `FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR`      |                   | IPFS node address used by aqua-ipfs builtin |
| `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_SWARM_MULTIADDR` |                   | IPFS node address used by aqua-ipfs builtin |

## How to run

Copy `docker-compose.yml` locally and run

```bash
docker-compose up -d
```

That will run 2 containers: local Fluence node and Network Dashboard connected
to it.

## How to open dashboard

Open [http://localhost:8080](http://localhost:8080) in your browser
