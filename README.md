# Rust Peer Distro

The distributive and packaging of the
[Rust peer](https://github.com/fluencelabs/rust-peer).

## Installation and usage

```bash
docker run -d --name rust-peer -e RUST_LOG="info" -p 7777:7777 -p 9999:9999 fluencelabs/rust-peer:latest --local
```

To get a list of commands that can be passed to rust-peer run:

```bash
docker run --rm --name rust-peer fluencelabs/rust-peer:latest --help
```

See deployment instructions and tips at
[deploy](https://github.com/fluencelabs/rust-peer-distro/tree/master/deploy).

## Documentation

- Rust peer distro
  [image flavours](https://github.com/fluencelabs/rust-peer-distro/tree/master/docs/flavours.md)
- [Builtin services](https://github.com/fluencelabs/rust-peer-distro/tree/master/docs/builtins.md)

Comprehensive documentation on everything related to Fluence can be found
[here](https://fluence.dev/). Check also our
[YouTube channel](https://www.youtube.com/@fluencelabs).

## Support

Please, file an [issue](https://github.com/fluencelabs/rust-peer-distro/issues)
if you find a bug. You can also contact us at
[Discord](https://discord.com/invite/5qSnPZKh7u) or
[Telegram](https://t.me/fluence_project). We will do our best to resolve the
issue ASAP.

## Contributing

Any interested person is welcome to contribute to the project. Please, make sure
you read and follow some basic
[rules](https://github.com/fluencelabs/rust-peer-distro/tree/master/CONTRIBUTING.md).
The Contributor License Agreement can be found
[here](https://github.com/fluencelabs/rust-peer-distro/tree/master/FluenceCLA).

## License

All software code is copyright (c) Fluence Labs, Inc. under the
[Apache-2.0](https://github.com/fluencelabs/rust-peer-distro/tree/master/LICENSE)
license.
