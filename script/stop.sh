#!/bin/bash

[ "$1" == "prod" ] && env="prod" || env="test"

docker-compose -f docker-compose.yml -f docker-compose-$env.yml down
