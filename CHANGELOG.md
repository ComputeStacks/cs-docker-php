# ComputeStacks PHP OpenLiteSpeed Changelog

## 2023-Apr-13

* Ensure older sites running our containers have the updated log configuration within the vhost.
* Ensure the open litespeed password has the correct ownership.
* Capture postfix logs to stdout.
* New ability to set a default from FQDN for postfix. This solves the issue of mail not working out of the box when relaying.

***

## 2023-Mar-10

* Added PHP 8.2 (without ioncube support; not yet available.)
* Changed the automatic OLS updated to store snapshot in a volume. This way it's possible to manually recover from a failed upgrade process.