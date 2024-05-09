#!/usr/bin/env bash

MONARX_PHP_VERSION=$(echo "$PHP_VERSION" | awk '{split($0,i,".");print i[1] i[2]}')
LS_PHP_CONFIG=/usr/local/lsws/lsphp${MONARX_PHP_VERSION}/bin/php-config
PHP_INI_DIR=$(${LS_PHP_CONFIG} --ini-dir)
PHP_EXT_DIR=$(${LS_PHP_CONFIG} --extension-dir)

# Loop through the metadata service and select the node_id for the container we're running on.
# requires ComputeStacks controller v9.3.1+
NODE_ID=$(curl -H "Content-Type: application/json" -H "Authorization: Bearer ${METADATA_AUTH}" "$METADATA_URL" | jq '.services[].containers[] | select(.name == env.HOSTNAME) | .node_id')

if [ ! -f /usr/bin/monarx-agent ]; then
  echo >&2 "Monarx binary not found, disabling monarx service."
  touch /etc/service/monarx/down
  exit 0
fi

if [ ! -f "/usr/lib/monarx-protect/monarxprotect-php${MONARX_PHP_VERSION}.so" ]; then
  echo >&2 "PHP Version for Monarx not present, skipping."
   if [ ! -f /etc/service/monarx/down ]; then
    touch /etc/service/monarx/down
  fi
elif [ -z "$MONARX_ID" ] || [ -z "$MONARX_SECRET" ]; then
  echo >&2 "MONARX_ID or MONARX_SECRET not set, disabling monarx."
   if [ ! -f /etc/service/monarx/down ]; then
    touch /etc/service/monarx/down
  fi
else
  sed -i "s/SET_CLIENT_ID/${MONARX_ID}/g" /etc/monarx-agent.conf
  sed -i "s/SET_CLIENT_SECRET/${MONARX_SECRET}/g" /etc/monarx-agent.conf
  # Fallback to hostname if agent is not set.
  if [ -z "$MONARX_AGENT" ]; then
    sed -i "s/SET_SERVICE_NAME/${HOSTNAME}/g" /etc/monarx-agent.conf
  else
    sed -i "s/SET_SERVICE_NAME/${MONARX_AGENT}/g" /etc/monarx-agent.conf

    # MONARX_AGENT is set to the service name
    sed -i "s/SET_HOSTNAME/${MONARX_AGENT}/g" /etc/monarx-agent.conf
  fi
  # Include container node id if present
  if [[ -z "$NODE_ID" || "$NODE_ID" == "null" ]]; then
    echo "Missing NodeID, skipping monarx node tag..."
  else
    echo "tags = node-${NODE_ID}" >> /etc/monarx-agent.conf
  fi
  # grab latest file
  if [ -f "${PHP_EXT_DIR}monarxprotect-php${MONARX_PHP_VERSION}.so" ]; then
    rm "${PHP_EXT_DIR}monarxprotect-php${MONARX_PHP_VERSION}.so"
  fi
  cp "/usr/lib/monarx-protect/monarxprotect-php${MONARX_PHP_VERSION}.so" "$PHP_EXT_DIR"
  echo "extension=monarxprotect-php${MONARX_PHP_VERSION}.so" > "${PHP_INI_DIR}monarxprotect.ini"
  if [ -f /etc/service/monarx/down ]; then
    echo "Activating Monarx"
    rm /etc/service/monarx/down
  fi
fi
