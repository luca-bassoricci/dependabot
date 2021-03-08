<p align="center">
  <img src="logo.png" alt="dependabot-gitlab" width="100" height="100">
</p>

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

For all configuration options, refer to [chart repository](https://github.com/andrcuns/charts/blob/master/charts/dependabot-gitlab/README.md)

## Docker Compose

Simple example deployment can be seen in [docker-compose-prod.yml](docker-compose-prod.yml). Deployment consists of 3 containers - web server, sidekiq
worker and redis. Simple production like deployment using `docker-compose` can be done with following command:

```bash
docker-compose -f docker-compose.yml -f docker-compose-prod.yml up
```

<details>
<summary><b>Manual configuration options via environment variables</b></summary>

### Configuration environment variables

Application requires few environment variables to work.

* `SETTINGS__GITLAB_URL` - url of gitlab instance, ex: `https://gitlab.com` by default
* `SETTINGS__GITLAB_ACCESS_TOKEN` - [gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) personal access token with api scope
* `SETTINGS__GITHUB_ACCESS_TOKEN` - [github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) personal access token with repository read scope, without it you can run into rate limits when fetching changelog and release notes for all dependencies which code comes from github
* `SETTINGS__GITLAB_AUTH_TOKEN` - optional gitlab webhook token which can be configured under webhook settings in gitlab, if not present,
token set in gitlab webhook configuration will be ignored
* `SETTINGS__DEPENDABOT_URL` - url application can be reached on, example: `https://dependabot-gitlab.com`. This url will be used to automatically
add necessary webhooks to project

### Private registry credentials

For dependabot to be able to resolve dependencies from private registries, credentials must be provided. Credentials are configured via
environment variables with following naming pattern:

* `SETTINGS__CREDENTIALS__{REGISTRY_TYPE}__{REGISTRY_NAME}__{REGISTRY_SPECIFIC_PARAM}`, where:
  * `REGISTRY_TYPE` - `MAVEN,DOCKER,NPM`
  * `REGISTRY_NAME` - some unique name identifying registry
  * `REGISTRY_SPECIFIC_PARAM` - parameters, like url, username, password depending on registry type

Please note the mandatory double underscores `__`\
Multiple registries of the same type can be configured at the same time

#### Maven repositories

* `SETTINGS__CREDENTIALS__MAVEN__{REPOSITORY_NAME}__URL` - base url of the repository
* `SETTINGS__CREDENTIALS__MAVEN__{REPOSITORY_NAME}__USERNAME` - user with read access
* `SETTINGS__CREDENTIALS__MAVEN__{REPOSITORY_NAME}__PASSWORD` - password for the user

#### Docker registries

* `SETTINGS__CREDENTIALS__DOCKER__{REGISTRY_NAME}__REGISTRY` - registry hostname like `registry.hub.docker.com`
* `SETTINGS__CREDENTIALS__DOCKER__{REGISTRY_NAME}__USERNAME` - user with read access
* `SETTINGS__CREDENTIALS__DOCKER__{REGISTRY_NAME}__PASSWORD` - password for the user

#### Npm registries

* `SETTINGS__CREDENTIALS__NPM__{REGISTRY_NAME}__REGISTRY` - registry url
* `SETTINGS__CREDENTIALS__NPM__{REGISTRY_NAME}__TOKEN` - authentication token

#### Example

```bash
SETTINGS__CREDENTIALS__MAVEN__REPO1__URL=maven_url
SETTINGS__CREDENTIALS__MAVEN__REPO1__USERNAME=maven_username
SETTINGS__CREDENTIALS__MAVEN__REPO1__PASSWORD=maven_password
SETTINGS__CREDENTIALS__DOCKER__REGISTRY1__REGISTRY=docker_registry
SETTINGS__CREDENTIALS__DOCKER__REGISTRY1__USERNAME=docker_username
SETTINGS__CREDENTIALS__DOCKER__REGISTRY1__PASSWORD=docker_password
SETTINGS__CREDENTIALS__NPM__REGISTRY1__REGISTRY=npm_registry
SETTINGS__CREDENTIALS__NPM__REGISTRY1__TOKEN=npm_token
```

</details>

# Configuration

## Webhooks

If `env.dependabotUrl` in helm values or `SETTINGS__DEPENDABOT_URL` is not set, following [webhooks](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html) with url `http://{dependabot_host}/api/hooks` and optional secret token have to be created in project manually:

* `Push events` - default repository branch
* `Merge request events`

It is possible to set up system hooks on Gitlab instance level as well.
Make sure `dependabot url` property is not set, so same project doesn't end up with 2 identical webhooks configured.

## dependabot.yml

Repository must contain [.gitlab/dependabot.yml](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates)
configuration for dependabot updates to work.

Most of the options function same way as in original documentation.

<details>
<summary><b>Additional options and/or different behavior</b></summary>

## allow/ignore

Multiple global allow options will be combined. Following options will result in updating only direct production dependencies:

```yml
allow:
  - dependency-type: direct
  - dependency-type: production
```

`dependency-name` accepts regex expression for matching name in allow and ignore configuration

```yml
allow:
  - dependency-name: "^react\w+"
```

## rebase-strategy

Because gitlab doesn't emit webhook when repository can no longer be merged due to conflict, this option will only have any
effect when scheduled jobs run. The rebase will not happen as soon as repository got conflicts.

```yml
rebase-strategy: auto
```

## auto-merge

Automatically accept merge request and set it to merge when pipeline succeeds. In order for this function to work, following criteria must be met:

* pipelines for merge requests must be enabled
* user must be able to merge
* merge request doesn't have mandatory approvals

```yml
auto-merge: true
```

This feature is not guaranteed to work due to gitlab limitation of accepting merge request before pipeline has been triggered. If pipeline
started with delay after merge request was created, trying to accept and auto merge might fail with `Method Not Allowed` error.
</details>

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
* Make change and make sure tests pass with `bundle exec rspec` (some tests require instance of mongodb and redis which can be started via `docker-compose up` command)
* Submit merge request

# Supported by

[![jetbrains](jetbrains.png)](https://www.jetbrains.com/?from=dependabot-gitlab)
