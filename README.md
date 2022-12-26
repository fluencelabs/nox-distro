# [rust-peer distro](https://github.com/fluencelabs/node-distro)

The distributive and packaging of the
[rust-peer](https://github.com/fluencelabs/rust-peer).

Currently provides Network Dashboard as a side-car.

## Image tags

| Container flavour | IPFS daemon | services                         | binaries                                   |
| ----------------- | ----------- | -------------------------------- | ------------------------------------------ |
| minimal           | ❌          | aqua-ipfs, trust-graph, registry | curl, ipfs                                 |
| ipfs              | ✅          | aqua-ipfs, trust-graph, registry | curl, ipfs                                 |
| rich              | ✅          | aqua-ipfs, trust-graph, registry | curl, ipfs, ceramic, bitcoin cli, geth cli |

`latest` points to the latest version of `ipfs` flavour

### minimal

Contains rust-peer itself and some builtin services:

- [aqua-ipfs](https://github.com/fluencelabs/aqua-ipfs)
- [trust-graph](https://github.com/fluencelabs/trust-graph)
- [registry](https://github.com/fluencelabs/registry)

For those who want to run IPFS node separately. Serves as a base image for all
other image flavours.

`FLUENCE_ENV_AQUA_IPFS_*` variables must be defined and point to externally
running IPFS daemon in order for aqua-ipfs to work. If not defined aqua-ipfs
builtin will be removed.

| variable                                       | default                           | description                                                                                                     |
| ---------------------------------------------- | --------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR` | `/dns4/ipfs.fluence.dev/tcp/5001` | advertised to clients (eg frontend apps) to use in uploading files (`ipfs.put`), managing pins (`ipfs.pin`) etc |
| `FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR`    | `/dns4/ipfs.fluence.dev/tcp/5001` | used by aqua-ipfs builtin to connect to IPFS node                                                               |

### ipfs

rust-peer packaged with
[IPFS node](https://docs.ipfs.io/how-to/command-line-quick-start/#take-your-node-online)
running inside container.

| variable                                       | default                                              | description                                                                                                     |
| ---------------------------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `IPFS_PATH`                                    | `/config/ipfs`                                       | IPFS node data directory                                                                                        |
| `IPFS_LOG_PATH`                                | `/log/ipfs`                                          | directory where IPFS will store its logs                                                                        |
| `IPFS_MIGRATE_FS`                              | `false`                                              | automatically run [fs-repo-migrations](https://github.com/ipfs/fs-repo-migrations) on start                     |
| `IPFS_ADDRESSES_SWARM`                         | `/ip4/0.0.0.0/tcp/4001,/ip4/0.0.0.0/tcp/4001/ws`     | IPFS swarm multiaddr                                                                                            |
| `IPFS_ADDRESSES_API`                           | `/ip4/0.0.0.0/tcp/5001`                              | IPFS API multiaddr                                                                                              |
| `IPFS_ADDRESSES_GATEWAY`                       | `/ip4/0.0.0.0/tcp/8080`                              | IPFS gateway multiaddr                                                                                          |
| `IPFS_ADDRESSES_ANNOUNCE`                      | `/ip4/127.0.0.1/tcp/4001,/ip4/127.0.0.1/tcp/4001/ws` | IPFS p2p multiaddr of the IPFS swarm protocol                                                                   |
| `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR` | `/ip4/127.0.0.1/tcp/5001`                            | advertised to clients (eg frontend apps) to use in uploading files (`ipfs.put`), managing pins (`ipfs.pin`) etc |
| `FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR`    | `/ip4/127.0.0.1/tcp/5001`                            | used by aqua-ipfs builtin to connect to IPFS node                                                               |

### rich

rust-peer packaged with IPFS node,
[Ceramic](https://developers.ceramic.network/learn/welcome/) CLI and some other
binaries like bitcoin-cli or
[geth](https://geth.ethereum.org/docs/interface/command-line-options).

| variable                                       | default                                              | description                                                                                                     |
| ---------------------------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `CERAMIC_HOST`                                 |                                                      | ceramic daemon address                                                                                          |
| `IPFS_PATH`                                    | `/config/ipfs`                                       | IPFS node data directory                                                                                        |
| `IPFS_LOG_PATH`                                | `/log/ipfs`                                          | directory where IPFS will store its logs                                                                        |
| `IPFS_MIGRATE_FS`                              | `false`                                              | automatically run [fs-repo-migrations](https://github.com/ipfs/fs-repo-migrations) on start                     |
| `IPFS_ADDRESSES_SWARM`                         | `/ip4/0.0.0.0/tcp/4001,/ip4/0.0.0.0/tcp/4001/ws`     | IPFS swarm multiaddr                                                                                            |
| `IPFS_ADDRESSES_API`                           | `/ip4/0.0.0.0/tcp/5001`                              | IPFS API multiaddr                                                                                              |
| `IPFS_ADDRESSES_GATEWAY`                       | `/ip4/0.0.0.0/tcp/8080`                              | IPFS gateway multiaddr                                                                                          |
| `IPFS_ADDRESSES_ANNOUNCE`                      | `/ip4/127.0.0.1/tcp/4001,/ip4/127.0.0.1/tcp/4001/ws` | IPFS announce multiaddr                                                                                         |
| `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR` | `/ip4/127.0.0.1/tcp/5001`                            | advertised to clients (eg frontend apps) to use in uploading files (`ipfs.put`), managing pins (`ipfs.pin`) etc |
| `FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR`    | `/ip4/127.0.0.1/tcp/5001`                            | used by aqua-ipfs builtin to connect to IPFS node                                                               |

## How to run

Copy [`docker-compose.yml`](https://github.com/fluencelabs/node-distro/blob/main/docker-compose.yml) locally and run

```bash
docker-compose up -d
```

That will run 2 containers: local rust-peer and Network Dashboard connected to
it.

## How to open dashboard

Open [http://localhost:8080](http://localhost:8080) in your browser
