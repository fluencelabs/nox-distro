# [rust-peer distro](https://github.com/fluencelabs/node-distro)

The distributive and packaging of the
[rust-peer](https://github.com/fluencelabs/rust-peer).

## Installation and usage

```bash
docker run -d --name rust-peer -e RUST_LOG="info" -p 7777:7777 -p 9999:9999 fluencelabs/rust-peer:latest --local
```

To get a list of commands that can be passed to rust-peer run:

```bash
docker run --rm --name rust-peer fluencelabs/rust-peer:latest --help
```

See deployment instructions and tips at [deploy](deploy).

## Documentation

- rust-peer distro [image flavours](docs/flavours.md)
- [builtin services](docs/builtins.md)
