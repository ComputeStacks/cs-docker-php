# ComputeStacks PHP Changelog

## 2024-may-9

* Update monarx configuration to set the host_id to match the service name rather than the container hostname, and add node_id tag.
* Add in a rate limiter for postfix.

***

## 2024-feb-26

### PHP 8-nginx images
* Consolidated php8-nginx images into a single directory and dockerfile.
* Added a test to the github actions build
* Build arm images

***

## 2024-feb-22

* Added metadata env variables to php7.4+ images.
* nginx images have better config file management to allow users to keep their configurations up to date more easily.
* fixed broken monarx installation on nginx 8.2.

## 2023-June-15

* Added nginx versions of php 7.4
* Set generous default file upload limits to 100MB for nginx images.

## 2023-June-11

* Added nginx versions of php 8.0 and 8.2.

## 2023-June-10

* Added nginx version of php 8.1 with php-fpm.

## 2023-May-5

* Tweak lsphp defaults.

## 2023-May-4

* Fix postfix alias.

***

## 2023-May-1

* PHP 8.{0,1,2}: Updated support for New Relic to include all recent php versions.
* PHP 8.{1,2}: Added [Relay](https://relay.so) support. _([@douwezijlstra-frl](https://github.com/douwezijlstra-frl))_

***

## 2023-Apr-25

* PHP 8.1: PHP Redis now compiled with additional compression algorithms.
* PHP 8.1: Initial support for new relic

***

## 2023-Apr-13

* Ensure older sites running our containers have the updated log configuration within the vhost.
* Ensure the open litespeed password has the correct ownership.
* Capture postfix logs to stdout.
* New ability to set a default from FQDN for postfix. This solves the issue of mail not working out of the box when relaying.

***

## 2023-Mar-10

* Added PHP 8.2 (without ioncube support; not yet available.)
* Changed the automatic OLS updated to store snapshot in a volume. This way it's possible to manually recover from a failed upgrade process.
