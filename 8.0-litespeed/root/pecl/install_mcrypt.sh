#!/usr/bin/expect
set timeout -1

spawn /usr/local/lsws/lsphp74/bin/pecl install channel://pecl.php.net/mcrypt-1.0.4

expect -re {autodetect}
send "\r"
expect -re {You should add}
