# Universal PHP image
This universal php image supports setting either PHP version 7.2, 7.3 or 7.4 through a environment variable. This allows for easy switching between versions and allows for easily adding versions in the future.

## Variable
Set the PHP version by specifying the following environment variable
```
PHP_VERSION=7.4
```
Allowed values:
```
7.4
7.3
7.2
```
If the variable is not specified or if it is invalid, the latest php version will be installed by default. That is 7.4 at the moment.
