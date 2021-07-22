# Clever Tools Docker Image

[![Build](https://github.com/diodonfrost/docker-clever-tools/actions/workflows/build.yml/badge.svg)](https://github.com/diodonfrost/docker-clever-tools/actions/workflows/build.yml)
[![Push](https://github.com/diodonfrost/docker-clever-tools/actions/workflows/push.yml/badge.svg)](https://github.com/diodonfrost/docker-clever-tools/actions/workflows/push.yml)
[![Registry](https://img.shields.io/docker/v/diodonfrost/clever-tools.svg)](https://hub.docker.com/repository/docker/diodonfrost/clever-tools)

This is a lightweight Docker image intended to be used mostly in CI environment
with some extra packages installed

## Packages installed

* clever-cli
* curl
* git

## How to use

The WORKDIR is `/actions`. It's also available as a volume. You need to give your token and secret in order to authenticate.

Here's an example to test connectivity:

```
docker run  -e CLEVER_TOKEN=yourtoken -e CLEVER_SECRET=yoursecret -v ${pwd}:/actions clevercloud/clever-tools profile
```

## License

Apache 2
