![dependabot](logo.png)

# dependabot-gitlab

[![pipeline status](https://gitlab.com/dependabot-gitlab/dependabot/badges/master/pipeline.svg)](https://gitlab.com/dependabot-gitlab/dependabot/-/commits/master)
[![coverage report](https://gitlab.com/dependabot-gitlab/dependabot/badges/master/coverage.svg)](https://gitlab.com/dependabot-gitlab/dependabot/-/commits/master)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/andrcuns/dependabot-gitlab?sort=semver)](https://hub.docker.com/r/andrcuns/dependabot-gitlab)
[![Docker Pulls](https://img.shields.io/docker/pulls/andrcuns/dependabot-gitlab)](https://hub.docker.com/r/andrcuns/dependabot-gitlab)

Application providing automated dependency updates based on [dependabot-core](https://github.com/dependabot/dependabot-core)

**The project is still considered to be in alpha stage so settings and setup might change**

## Deployment

Application is released as a [docker image](https://hub.docker.com/r/andrcuns/dependabot-gitlab). It is assumed there is possibility to
deploy the app as docker containers in order for it to start updating repository dependencies.\
Simple example deployment can be seen in [docker-compose-prod.yml](docker-compose-prod.yml). App will consist of minimum 2 containers, one
running web server and another running sidekiq process. Simple production like deployment using `docker-compose` can be done with following command:

```bash
docker-compose -f docker-compose.yml -f docker-compose-prod.yml up
```

### Environment configuration

Application requires few environment variables to work.

* `SETTINGS__GITLAB_URL` - url of gitlab instance, ex: `https://gitlab.com` by default
* `SETTINGS__GITLAB_ACCESS_TOKEN` - [gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) personal access token with api scope
* `SETTINGS__GITHUB_ACCESS_TOKEN` - [github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) personal access token with repository read scope
* `SETTINGS__GITLAB_AUTH_TOKEN` - optional gitlab webhook token which can be configured under webhook settings in gitlab, if not present,
token set in gitlab webhook configuration will be ignored

## Configuration

### Gitlab configuration

In order for gitlab to pick up repository configuration, a [webhook](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html) with url
`http://{dependabot_host}/api/hooks` and optional secret token needs to be created for repository with trigger for `push` events in the default repository
branch.

### Dependabot Configuration file

Repository must contain [.gitlab/dependabot.yml](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates)
configuration for dependabot updates to work.

Most of the options function same way as in original documentation. In addition it is possible to define following `allow` options:

Multiple global allow opts will be combined. Following option will result in updating only direct production dependencies:

```yml
allow:
  - dependency-type: direct
  - dependency-type: production
```

Currently not implemented options:

* [versioning-strategy](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates#versioning-strategy)
* [rebase-strategy](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates#rebase-strategy)

### Adding project manually

Endpoint `api/project` can receive POST request with json `{"project":"dependabot-gitlab/dependabot"}` to add project manually. Project must have a valid dependabot configuration file.

## Rake tasks

Additional rake tasks exist for manual interaction with dependency updates and configuration.

* `dependabot:register[project]` - manually register repository where `project` is repository name with namespace, ex: `dependabot-gitlab/dependabot`, repository must have valid dependabot config file
* `dependabot:update[project,package_manager]` - trigger dependency update where `project` is repository full name and `package_manager` is `package_ecosystem` parameter like `bundler`

### Job list

Index page of application, like `http://localhost:3000/` will display a table with jobs currently registered in the system

## Development

* Install dependencies with `bundle install`
* Setup precommit hooks with `bundle exec lefthook install -f`
* Make change and make sure tests pass with `bundle exec rspec`
* Submit merge request

Running up locally will require running redis instance. Redis in docker container can be started with `docker-compose up`
