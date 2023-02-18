# Builtin services

rust-peer distro comes with preconfigured builtin services.

## [registry](https://github.com/fluencelabs/registry)

Implements service discovery.

## [aqua-ipfs](https://github.com/fluencelabs/aqua-ipfs)

Native IPFS integration with Aqua language. Used to orchestrate IPFS file
transfer with Aqua scripts.

Image flavours [ipfs](flavours#ipfs) and [rich](flavours#rich) have IPFS daemon
running as a sidecar and aqua-ipfs configured to use this sidecar IPFS daemon.
[minimal](flavours#minimal) connects to IPFS daemon hosted by Fluence Labs.

In case you want to use a separately running IPFS daemon configure you need to
inject two variables:

- `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR` - advertised to clients (eg
  frontend apps) to use in uploading files (`ipfs.put`), managing pins
  (`ipfs.pin`) etc.
- `FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR` - used by aqua-ipfs builtin to
  connect to IPFS node

## [trust-graph](https://github.com/fluencelabs/trust-graph)

Can be used to create a trusted network, manage service permissions with TLS
certificates and other security related things.
