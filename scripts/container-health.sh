#!/usr/bin/env sh

i=0

container_name=$1

if [ $container_name = "" ]; then
  echo "Missing container name"
  exit 2
fi

echo "Warming up..."
sleep 2

while [ $i -le 20 ]
do

  status=$(docker inspect --format='{{json .State.Health.Status}}' "${container_name}" | tr -d '"')

  if [ "$status" = 'healthy' ]; then    
    echo "${container_name} is ${status}"
    exit 0
  elif [ "$status" = 'unhealthy' ]; then
    echo "$(docker logs -n 100 ${container_name})"
    echo "${container_name} is ${status}"
    exit 1
  fi
  echo "${container_name} is ${status}..."
  sleep 5
  i=$((i+1))

done
