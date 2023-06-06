# Running nox

Currently there is only one way to try out the Rust peer. It is by running it
with [docker-compose](docker-compose/). An example configuration for popular
orchestration platforms like [HasiCorp Nomad](https://www.nomadproject.io/) and
K8S are coming soon! Meanwhile, you can adapt
[this docker-compose file](docker-compose/docker-compose.yml) for the platform
of your choice.

## Configuring nox distro image

Checkout [this doc](../docs/flavours.md) to learn more about nox image flavours
and environment variables used to configure the images.
