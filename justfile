# help
default:
    @just --list --justfile {{ justfile() }}

# build all images
build-all:
    just build-php73
    just build-php74
    just build-php80
    just build-php81
    just build-php82

# build php 7.3
build-php73: (build-image "7.3-litespeed")

# build php 7.4
build-php74: (build-image "7.4-litespeed")

# build php 8.0
build-php80: (build-image "8.0-litespeed")

# build php 8.1
build-php81: (build-image "8.1-litespeed")

# build php 8.2
build-php82: (build-image "8.2-litespeed")

build-image image:
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-jammy
    docker build -t ghcr.io/computestacks/cs-docker-php:{{ image }} {{ image }}/