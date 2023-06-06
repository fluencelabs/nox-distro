# Builtin services

Nox distro comes with preconfigured builtin services.

## [registry](https://github.com/fluencelabs/registry)

Registry implements service discovery.

## [aqua-ipfs](https://github.com/fluencelabs/aqua-ipfs)

This is a native IPFS integration with
[Aqua](https://fluence.dev/docs/aqua-book/introduction) language. It is used to
orchestrate IPFS file transfer with Aqua scripts.

Image flavours [ipfs](flavours.md#ipfs) and [rich](flavours.md#rich) have an
IPFS daemon running as a sidecar and `aqua-ipfs` configured to use this sidecar
IPFS daemon. [minimal](flavours.md#minimal) connects to an IPFS daemon hosted by
[Fluence Labs](https://fluence.network).

In case you want to use a separately running IPFS daemon, you need to inject two
variables:

- `FLUENCE_ENV_AQUA_IPFS_EXTERNAL_API_MULTIADDR` - advertised to clients (e.g.,
  frontend apps) to use in uploading files (`ipfs.put`), managing pins
  (`ipfs.pin`) etc.
- `FLUENCE_ENV_AQUA_IPFS_LOCAL_API_MULTIADDR` - used by the `aqua-ipfs` builtin
  to connect to IPFS node

## [trust-graph](https://github.com/fluencelabs/trust-graph)

It can be used to create a trusted network, to manage service permissions with
TLS certificates and other security related things.

## [connector](https://github.com/fluencelabs/decider)

Used to pull contracts and deploy from blockchain.
