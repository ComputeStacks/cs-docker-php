#!/bin/bash

# Environmental variables:
#  * SMTP_USERNAME
#  * SMTP_PASSWORD
#  * SMTP_SERVER
#  * SMTP_PORT
#  * SMTP_FROM -- allow users to override the default from email. Can be overridden by the php mailer.
#  * SMTP_DEFAULT_FROM_FQDN -- Image admins can set a base domain (i.e. example.com) for crafting a valid from URL.
#                              If you choose 'example.com', then the from address will be: noreply@{container-HOSTNAME}.example.com
#                              This is overridden by a user setting `SMTP_FROM`, or by the php mailer setting the from address.
#  * PM_STREAM 

postfix_config() {
    cat<<EOF
smtpd_banner = \$myhostname ESMTP \$mail_name (Debian/GNU)
biff = no
append_dot_mydomain = no
readme_directory = no
compatibility_level = 2
smtpd_tls_CAfile=/etc/ssl/certs/ca-certificates.crt
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:\${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:\${data_directory}/smtp_scache
smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = ${HOSTNAME}
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination =
mynetworks = 127.0.0.0/8
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
inet_protocols = ipv4
smtp_always_send_ehlo = yes
smtp_helo_name = ${HOSTNAME}

smtp_sasl_auth_enable = yes 
smtp_sasl_password_maps = static:${SMTP_USERNAME}:${SMTP_PASSWORD}
smtp_sasl_security_options = noanonymous 
smtp_sasl_tls_security_options = noanonymous
smtp_tls_security_level = encrypt
smtp_tls_loglevel = 1
header_size_limit = 4096000
relayhost = [${SMTP_SERVER}]:${SMTP_PORT}
smtpd_recipient_restrictions=reject_non_fqdn_recipient,reject_unknown_recipient_domain

EOF
}

postmark_header() {
  cat<<EOF
/^From:/ PREPEND X-PM-Message-Stream: ${PM_STREAM}
EOF
}

default_from() {
  if [ -z ${SMTP_FROM} ]; then
    cat<<EOF
www-data@${HOSTNAME} noreply@${HOSTNAME}.${SMTP_DEFAULT_FROM_FQDN}
EOF
  else
    cat<<EOF
www-data@${HOSTNAME} ${SMTP_FROM}
EOF
  fi
}

config_postfix() {  
  postfix_config > /etc/postfix/main.cf
  if [ -z ${SMTP_DEFAULT_FROM_FQDN} ]; then
    echo "No default from fqdn, skipping..."
  else
    default_from > /etc/postfix/default_from
    postmap /etc/postfix/default_from
    echo "smtp_generic_maps = hash:/etc/postfix/default_from" >> /etc/postfix/main.cf
  fi  
  if [ -z ${PM_STREAM} ]; then
    echo "Skipping Postmark Message Stream configuration..."
  else
    postmark_header > /etc/postfix/postmark_header.pcre
    echo "smtp_header_checks = pcre:/etc/postfix/postmark_header.pcre" >> /etc/postfix/main.cf
  fi
  FILES="etc/localtime etc/services etc/resolv.conf etc/hosts etc/nsswitch.conf"
  echo $HOSTNAME > /etc/mailname
  for file in $FILES; do
    if [ -f /var/spool/postfix/${file} ]; then
      rm /var/spool/postfix/${file}
    fi
    cp /${file} /var/spool/postfix/${file}
    chmod a+rX /var/spool/postfix/${file}
  done
}

if [ -z ${SMTP_USERNAME} ] || [ -z ${SMTP_PASSWORD} ] || [ -z ${SMTP_SERVER} ] || [ -z ${SMTP_PORT} ]; then
  echo "SMTP Service not configured"
else
  echo "Configuring SMTP Service for ${SMTP_SERVER}..."
  config_postfix
  echo "Starting SMTP Service"
  rm /etc/service/postfix/down
  rm /etc/service/postfix-log/down
fi
