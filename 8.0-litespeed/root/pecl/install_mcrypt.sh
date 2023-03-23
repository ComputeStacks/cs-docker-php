#!/usr/bin/expect
set timeout -1

spawn /usr/local/lsws/lsphp80/bin/pecl install channel://pecl.php.net/mcrypt-1.0.6

expect -re {autodetect}
send "\r"
expect -re {You should add}
