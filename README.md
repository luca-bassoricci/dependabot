**This project is not affiliated with, funded by, or associated with the Dependabot team or GitHub**

# dependabot-gitlab

**This software is Work in Progress: features will appear and disappear, API will be changed, your feedback is always welcome!**

Application providing automated dependency updates based on [dependabot-core](https://github.com/dependabot/dependabot-core)

* [Usage](#usage)
* [Deployment](#deployment)
* [Configuration](#configuration)
* [Adding projects](#adding-projects)
* [Rake tasks](#rake-tasks)
* [UI](#ui)
* [Development](#development)

# Docker image variants

* Release version - `docker.io/andrcuns/dependabot-gitlab:latest`
* Latest master - `registry.gitlab.com/dependabot-gitlab/dependabot:master-latest`

# Usage

## Standalone

It is possible to use app in "standalone" mode without the need to deploy. Project [dependabot-standalone](https://gitlab.com/dependabot-gitlab/dependabot-standalone) contains pipeline configuration to run dependency updates via scheduled gitlab pipelines.

This variation exists similar use as [dependabot-script](https://github.com/dependabot/dependabot-script), which inspired
creation of this project. The features and further development and support for standalone mode is very limited.

## Service

dependabot-gitlab is packaged as docker container and it's possible to deploy them via various means described in [Deployment](#Deployment) section.

# Deployment

## Kubernetes

Preferred way of deployment is via [helm](https://helm.sh/) package manager.

```bash
helm repo add dependabot https://andrcuns.github.io/charts
helm install dependabot dependabot/dependabot-gitlab --set credentials.gitlab_access_token=$gitlab_access_token
```

## Docker Compose

Simple example deployment can be seen in [docker-compose-prod.yml](docker-compose-prod.yml). Deployment consists of 3 containers - web server, sidekiq
worker and redis. Simple production like deployment using `docker-compose` can be done with following command:

```bash
docker-compose -f docker-compose.yml -f docker-compose-prod.yml up
```

# Configuration

## APP

* `kubernetes` - for all configuration options, refer to [chart repository](https://github.com/andrcuns/charts/blob/master/charts/dependabot-gitlab/README.md)
* `docker-compose` / `standalone` - for manual configuration via environment variables, refer to [environment](doc/environment.md) doc

## Webhooks

If `env.dependabotUrl` in helm values or `SETTINGS__DEPENDABOT_URL` is not set, following [webhooks](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html) with url `http://{dependabot_host}/api/hooks` and optional secret token have to be created in project manually:

* `Push events` - default repository branch
* `Merge request events`
* `Comments`
* `Pipeline events`

It is possible to set up system hooks on Gitlab instance level as well.
Make sure `dependabot url` property is not set, so same project doesn't end up with 2 identical webhooks configured.

## dependabot.yml

Repository must contain `.gitlab/dependabot.yml` configuration for dependabot updates to work.
Most of the options are ported and function the same way as in [Github](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates) documentation.

For additional `dependabot-gitlab` specific options, refer to [dependabot.yml config](doc/dependabot.md) doc

# Adding projects

## Automatically

If gitlab webhook is configured, project will be added automatically once dependabot.yml configuration file is created or updates in the repository's default branch.
Project is removed from dependabot instance if dependabot.yml file is deleted from repository.

## Manually

If webhooks are not configured, projects have to be added manually.

### API

Endpoint `api/project` can receive POST request with json `{"project":"dependabot-gitlab/dependabot"}` to add update jobs for project manually. Project must have a valid dependabot configuration file.

### Rake task

`dependabot:register[project]` - manually register repository where `project` is repository name with namespace, ex: `dependabot-gitlab/dependabot`, repository must have valid dependabot config file

# Rake tasks

Additional rake tasks exist for manual interaction with dependency updates

`dependabot:update[project,package_manager,directory]` - trigger dependency update where `project` is repository full name and `package_manager` is `package_ecosystem` parameter like `bundler` and directory is path where dependency files are stored, usually `/`

This task is used to provide standalone use capability

# UI

Index page of application, like `http://localhost:3000/` will display a table with jobs currently configured to run dependency updates

# Development

* Install dependencies with `bundle install`
* Setup [pre-commit](https://pre-commit.com/) hooks with `pre-commit install`
* Make change and make sure tests pass with `bundle exec rspec` (some tests require instance of mongodb and redis which can be started via `docker-compose -f docker-compose.yml up` command)
* Submit merge request

# Supported by

[![jetbrains](images/jetbrains.png)](https://www.jetbrains.com/?from=dependabot-gitlab)
