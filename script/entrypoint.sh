#!/bin/sh

bundle install
supervisord -c config/supervisor/supervisord.conf
