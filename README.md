# nasvcs

NAS hosted version control system container.

## Docker Image

nasvcs uses GitHub Actions to build and publish a Docker image to the GitHub Container Registry, using design, automation, and tests based on [nasmail](https://github.com/jabenninghoff/nasmail). The included `compose.yaml` file can be adapted to deploy the container using `docker compose`.

New images are published for each new release only; there are no development images (`edge` or `main`). All pull requests and merges to main build and load to test and validate the image. Images are built for Intel (`amd64`), 64-bit ARM (`arm64`: Apple, Raspberry Pi) and 32-bit ARM (`arm/v6`, `arm/v7`: older Raspberry Pi hardware).

Pull the latest (stable) image using:

```sh
docker pull ghcr.io/jabenninghoff/nasvcs
```

## CVS

## Git

## lighttpd

## OpenSSH

## runit
