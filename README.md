# Docker Container Name

This container allows to run ansible and ansible-lint.

## Build status

![Build Docker image](https://github.com/Rote-Beete/ansible-docker/workflows/Build%20Docker%20image/badge.svg?branch=main)

## Getting Started
### Prerequisities

In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Container Parameters

run playbook

```shell
docker run -v "${PWD}":/work:ro rotebeete/ansible playbook.yml
```

lint playbook

```shell
docker run --entrypoint ansible-lint -v "${PWD}":/work:ro rotebeete/ansible playbook.yml
```

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the
[tags on this repository](https://github.com/Rote-Beete/ansible-docker/tags).

## Authors

* **Michael Gerlach** - *Initial work* - [n3ph](https://github.com/n3ph)

See also the list of [contributors](https://github.com/Rote-Beete/ansible-docker/contributors) who
participated in this project.

## License

This project is licensed under the AGPL License - see the [LICENSE.md](LICENSE.md) file for details.
