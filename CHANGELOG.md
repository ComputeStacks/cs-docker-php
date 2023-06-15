# ComputeStacks PHP OpenLiteSpeed Changelog

## 2023-June-15

* Added nginx versions of php 7.4

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