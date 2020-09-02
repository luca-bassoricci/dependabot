#!/bin/bash

[ "$1" == "prod" ] && env="prod" || env="dev"

docker-compose -f docker-compose.yml -f docker-compose-$env.yml down
