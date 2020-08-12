# dependabot-gitlab

[![pipeline status](https://gitlab.com/andrcuns/dependabot-gitlab/badges/master/pipeline.svg)](https://gitlab.com/andrcuns/dependabot-gitlab/-/commits/master)
[![coverage report](https://gitlab.com/andrcuns/dependabot-gitlab/badges/master/coverage.svg)](https://gitlab.com/andrcuns/dependabot-gitlab/-/commits/master)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/andrcuns/dependabot-gitlab?sort=semver)](https://hub.docker.com/r/andrcuns/dependabot-gitlab)
[![Docker Pulls](https://img.shields.io/docker/pulls/andrcuns/dependabot-gitlab)](https://hub.docker.com/r/andrcuns/dependabot-gitlab)

*dependabot-gitlab* is rails application providing automated dependency updates based on [dependabot-core](https://github.com/dependabot/dependabot-core)

## Usage

### Deployment

Application is released as a [docker image](https://hub.docker.com/r/andrcuns/dependabot-gitlab). It is assumed there is possibility to
deploy the app as docker containers in order for it to start updating repository dependencies.\
Simple example deployment can be seen in [docker-compose-prod.yml](docker-compose-prod.yml). App will consist of minimum 2 containers, one
running web server and another running sidekiq process. Simple production like deployment using `docker-compose` can be done with following command:

```bash
docker-compose -f docker-compose.yml -f docker-compose-prod.yml up
```

In order for gitlab to pick up repository configuration, a [webhook](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html) with url
`http://{dependabot_host}/api/dependabot` and optional secret token needs to be created for repository with trigger for `push` events in the default repository
branch.

### Environment configuration

Application requires few environment variables to work.

* `SETTINGS__GITLAB_HOSTNAME` - hostname of gitlab instance, ex: `gitlab.com` by default
* `SETTINGS__GITLAB_ACCESS_TOKEN` - [gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) personal access token with api scope
* `SETTINGS__GITHUB_ACCESS_TOKEN` - [github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) personal access token with repository read scope
* `SETTINGS__GITLAB_AUTH_TOKEN` - optional gitlab webhook token which can be configured under webhook settings in gitlab, if not present,
token set in gitlab webhook configuration will be ignored

### Configuration file

Application will automatically read dependabot configuration file placed in `.gitlab/dependabot.yml`. Configuration file options are described
in [dependabot](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates) documentation. Example file
which manages this project's dependencies can be seen [.gitlab/dependabot.yml](.gitlab/dependabot.yml)

### Rake tasks

Additional rake tasks exist for manual interaction with dependency updates and configuration.

* `dependabot:register[repo]` - manually register repository where `repo` is repository name with namespace, ex: `andrcuns/dependabot-gitlab`, repository must have dependabot config file
* `dependabot:update[repo,package_manager]` - trigger dependency update where `repo` is repository full name and `package_manager` is `package_ecosystem` parameter like `bundler`

### Job list

Index page of application, like `http://localhost:3000/` will display a table with jobs currently registered in the system

## Development

* Install dependencies with `bundle install`
* Setup precommit hooks with `bundle exec lefthook install -f`
* Make change and make sure tests pass with `bundle exec rspec`
* Submit merge request

Running up locally will require running redis instance. Redis in docker container can be started with `docker-compose up`
