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
    just build-php74ls
    just build-php80ls
    just build-php81ls
    just build-php82ls


build-php74ls:
    docker build -t ghcr.io/computestacks/cs-docker-php:7.4-litespeed litespeed/7.4

build-php80ls:
    docker build -t ghcr.io/computestacks/cs-docker-php:8.0-litespeed litespeed/8.0

build-php81ls:
    @just --justfile {{ justfile() }} build-ls-image "8.1"

build-php82ls:
    @just --justfile {{ justfile() }} build-ls-image "8.2"

build-php74nginx:
    @just --justfile {{ justfile() }} build-nginx-image "7.4"

build-php80nginx:
    @just --justfile {{ justfile() }} build-nginx-image "8.0"

build-php81nginx:
    @just --justfile {{ justfile() }} build-nginx-image "8.1"

build-php82nginx:
    @just --justfile {{ justfile() }} build-nginx-image "8.2"

build-ls-image php_version:
    docker build --build-arg php_version={{ php_version }} -t ghcr.io/computestacks/cs-docker-php:{{ php_version }}-litespeed litespeed/8

build-nginx-image php_version:
    docker build --build-arg php_version={{ php_version }} -t ghcr.io/computestacks/cs-docker-php:{{ php_version }}-nginx nginx/


