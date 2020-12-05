#!/bin/bash

if [ "$1" == "prod" ] || [ "$1" == "test" ]; then
  ymls="-f docker-compose.yml -f docker-compose-$1.yml"

  docker-compose $ymls pull
  docker-compose $ymls up --force-recreate --build
else
  # build gitlab mock
  docker build --target development -t gitlab-dev spec/fixture/gitlab
  # build app
  docker build --target development -t dependabot_dependabot:latest .
  # start app for development
  docker run --rm -it -v dependabot_gems:/vendor/bundle -v $PWD:/code dependabot_dependabot bash
fi
