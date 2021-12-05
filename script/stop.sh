#!/bin/bash

ymls="-f docker-compose.yml -f docker-compose-$1.yml"

docker-compose $ymls down
