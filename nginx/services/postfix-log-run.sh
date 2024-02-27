#!/bin/sh
if [ ! -f /var/log/mail.log ]; then
  touch /var/log/mail.log
  chown root:adm /var/log/mail.log
  chmod 640 /var/log/mail.log
fi
/usr/bin/tail -f /var/log/mail.log
