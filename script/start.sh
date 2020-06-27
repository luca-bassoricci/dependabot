#!/bin/bash

if [ "$1" == "prod" ]; then
  env="prod"
  detached="-d"
else
  env="test"
  detached=""
fi

docker-compose -f docker-compose.yml -f docker-compose-$env.yml up --force-recreate --build $detached
