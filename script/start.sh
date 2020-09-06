#!/bin/bash

if [ "$1" == "prod" ]; then
  env="prod"
  detached="-d"
else
  env="dev"
  detached=""
fi

ymls="-f docker-compose.yml -f docker-compose-$env.yml"

docker-compose "$ymls" pull
docker-compose "$ymls" up --force-recreate --build "$detached" "$2"
