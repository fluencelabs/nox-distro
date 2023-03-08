# Rust Peer Distro Flavours

Each flavour is represented by a docker image tag. See the
[docker hub](https://hub.docker.com/r/fluencelabs/rust-peer) and the
[releases](https://github.com/fluencelabs/rust-peer-distro/releases) page.

Each flavour builds upon its previous flavour. In particular, `ipfs` has
everything that `minimal` has, and `rich` has everything that `minimal` and
`ipfs` have.

| flavour | IPFS daemon | services                         | binaries                                   |
| ------- | ----------- | -------------------------------- | ------------------------------------------ |
| minimal | ❌          | aqua-ipfs, trust-graph, registry | curl, ipfs                                 |
| ipfs    | ✅          | aqua-ipfs, trust-graph, registry | curl, ipfs                                 |
| rich    | ✅          | aqua-ipfs, trust-graph, registry | curl, ipfs, ceramic, bitcoin cli, geth cli |

Tag `latest` points to the latest version of `ipfs` flavour.

## minimal

It contains Rust peer itself and some [builtin services](builtins.md). It serves
as a base image for all other image flavours and is intended for those who want
to run an IPFS node separately.

`FLUENCE_ENV_AQUA_IPFS_*` variables must be defined and point to externally
running IPFS daemon in order for `aqua-ipfs` to work. If not defined,
**aqua-ipfs builtin will be removed**.

| variable                                       | default                           | description                                                                                                     |
| ---------------------------------------------- | --------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR` | `/dns4/ipfs.fluence.dev/tcp/5001` | advertised to clients (eg frontend apps) to use in uploading files (`ipfs.put`), managing pins (`ipfs.pin`) etc |
| `FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR`    | `/dns4/ipfs.fluence.dev/tcp/5001` | used by aqua-ipfs builtin to connect to IPFS node                                                               |
| `FLUENCE_DEPLOY_CONNECTOR`                     | `false`                           | switch to deploy connector builtin                                                                              |

## ipfs

This is a Rust peer packaged with an
[IPFS node](https://docs.ipfs.io/how-to/command-line-quick-start/#take-your-node-online)
running inside a container.

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
| `FLUENCE_DEPLOY_CONNECTOR`                     | `false`                                              | switch to deploy connector builtin                                                                              |

## rich

This is a Rust peer packaged with an IPFS node,
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
| `FLUENCE_DEPLOY_CONNECTOR`                     | `false`                                              | switch to deploy connector builtin                                                                              |
