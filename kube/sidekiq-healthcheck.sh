#!/bin/bash

SIDEKIQ_HEALTHCHECK=true bundle exec rake "dependabot:check_sidekiq"
