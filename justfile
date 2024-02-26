# help
default:
    @just --list --justfile {{ justfile() }}

# build all images
build-all:
    just build-nginx
    just build-litespeed

# build all nginx images
build-nginx:
    just build-php74nginx
    just build-php80nginx
    just build-php81nginx
    just build-php82nginx

# build all litespeed images
build-litespeed:
    just build-php73
    just build-php74
    just build-php80
    just build-php81
    just build-php82

# build php 7.3
build-php73: 
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-focal
    @just --justfile {{ justfile() }} build-image "7.3-litespeed"

# build php 7.4
build-php74: 
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-focal
    @just --justfile {{ justfile() }} build-image "7.4-litespeed"

# build php 7.4 nginx
build-php74nginx: 
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-jammy
    @just --justfile {{ justfile() }} build-image "7.4-nginx"

# build php 8.0
build-php80: 
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-focal
    @just --justfile {{ justfile() }} build-image "8.0-litespeed"

# build php 8.0 nginx
build-php80nginx:
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-jammy
    @just --justfile {{ justfile() }} build-8-image "8.0"

# build php 8.1
build-php81: 
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-jammy
    @just --justfile {{ justfile() }} build-image "8.1-litespeed"

# build php 8.1 nginx
build-php81nginx:
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-jammy
    @just --justfile {{ justfile() }} build-8-image "8.1"

# build php 8.2
build-php82:
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-jammy
    @just --justfile {{ justfile() }} build-image "8.2-litespeed"

# build php 8.2 nginx
build-php82nginx:
    docker pull ghcr.io/computestacks/cs-docker-base:ubuntu-jammy
    @just --justfile {{ justfile() }} build-8-image "8.2"

build-image image:
    docker build -t ghcr.io/computestacks/cs-docker-php:{{ image }} {{ image }}/

build-8-image php_version:
    docker build --build-arg php_version={{ php_version }} -t ghcr.io/computestacks/cs-docker-php:{{ php_version }}-nginx 8-nginx/
