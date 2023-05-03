# Changelog
## 22.04-3.1.4.2 - 2023-05-03

### Added
- image tag `latest` for docker image

### Changed
- s6-overlay migrate to version ([v3.1.4.2](https://github.com/just-containers/s6-overlay/releases))
- `hook/push.sh` push docker image with tag `latest`

### Removed
- Dockerfile for s6-overlay version 2.x
- GitHub pipeline for s6-overlay version 2.x
