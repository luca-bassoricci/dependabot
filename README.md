**This project is not affiliated with, funded by, or associated with the Dependabot team or GitHub**

**This software is Work in Progress: features will appear and disappear, API will be changed, your feedback is always welcome!**

---

Application providing automated dependency updates based on [dependabot-core](https://github.com/dependabot/dependabot-core)

[[_TOC_]]

# Docker image variants

* Release version - `docker.io/andrcuns/dependabot-gitlab:latest`
* Latest master - `registry.gitlab.com/dependabot-gitlab/dependabot:master-latest`

# Usage

## Standalone

It is possible to use app in "standalone" mode without the need to deploy. Project [dependabot-standalone](https://gitlab.com/dependabot-gitlab/dependabot-standalone) contains pipeline configuration to run dependency updates via scheduled gitlab pipelines.

This mode can be used similarly to [dependabot-script](https://github.com/dependabot/dependabot-script), which inspired
creation of this project. Standalone mode is limited to following features:

* basic dependency updates
* limited ability of MR automerge

Features not supported:

* automatic closure of superseeded merge requests
* merge request commands
* webhooks
* UI with managed project list

## Service

dependabot-gitlab is packaged as docker container and it's possible to deploy it via various means described in [Deployment](#Deployment) section.

# Deployment

## Helm

Preferred way of deployment is via [helm](https://helm.sh/) package manager.

```bash
helm repo add dependabot https://andrcuns.github.io/charts
helm install dependabot dependabot/dependabot-gitlab --set credentials.gitlab_access_token=$gitlab_access_token
```

## Docker Compose

Simple example deployment can be seen in [docker-compose-prod.yml](docker-compose-prod.yml). Deployment consists of 4 containers - web server, sidekiq
worker, mongodb and redis. Simple production like deployment using `docker-compose` can be done with following command:

```bash
docker-compose -f docker-compose.yml -f docker-compose-prod.yml up
```

# Configuration

Following configuration options are supported:

| option                             | dependabot         | dependabot-standalone |
|------------------------------------|--------------------|-----------------------|
| `package-ecosystem`                | :white_check_mark: | :white_check_mark:    |
| `directory`                        | :white_check_mark: | :white_check_mark:    |
| `schedule.interval`                | :white_check_mark: | :x:                   |
| `schedule.day`                     | :white_check_mark: | :x:                   |
| `schedule.time`                    | :white_check_mark: | :x:                   |
| `schedule.timezone`                | :white_check_mark: | :x:                   |
| `allow`                            | :white_check_mark: | :white_check_mark:    |
| `ignore`                           | :white_check_mark: | :white_check_mark:    |
| `assignees`                        | :white_check_mark: | :white_check_mark:    |
| `reviewers`                        | :white_check_mark: | :white_check_mark:    |
| `commit-message`                   | :white_check_mark: | :white_check_mark:    |
| `insecure-external-code-execution` | :white_check_mark: | :white_check_mark:    |
| `labels`                           | :white_check_mark: | :white_check_mark:    |
| `milestone`                        | :white_check_mark: | :white_check_mark:    |
| `open-pull-requests-limit`         | :white_check_mark: | :white_check_mark:    |
| `pull-request-branch-name`         | :white_check_mark: | :white_check_mark:    |
| `rebase-strategy`                  | :white_check_mark: | :white_check_mark:    |
| `registries`                       | :white_check_mark: | :white_check_mark:    |
| `reviewers`                        | :white_check_mark: | :white_check_mark:    |
| `target-branch`                    | :white_check_mark: | :white_check_mark:    |
| `vendor`                           | :white_check_mark: | :white_check_mark:    |
| `versioning-strategy`              | :white_check_mark: | :white_check_mark:    |

## Application

### Helm chart

For all configuration options, refer to [chart repository](https://github.com/andrcuns/charts/blob/master/charts/dependabot-gitlab/README.md)

### Manual

[environment.md](doc/environment.md) describes all possible environment variables for use with `docker-compose` or `standalone` mode

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
`dependabot-gitlab` strives to achieve parity with all possible Github native options.
Some of the options can have slightly different behavior which is described in the documentation linked below.

* Github documentation: [configuration options](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates)
* Additional `dependabot-gitlab` specific options: [configuration options](doc/dependabot.md)

# Adding projects

## Automatically

If gitlab webhook is configured, project will be added automatically once dependabot.yml configuration file is created or updates in the repository's default branch.
Project is removed from dependabot instance if dependabot.yml file is deleted from repository.

## Manually

If webhooks are not configured, projects have to be added manually.

### API

Endpoint `api/project` can receive POST request with json `{"project":"dependabot-gitlab/dependabot"}` to add update jobs for project manually. Project must have a valid dependabot configuration file.

### Rake task

[register](#register) rake task

# Rake tasks

## register

Manually register project for updates. Repository must have valid dependabot config file

```shell
bundle exec rake 'dependabot:register[project]'
```

`project` - project full path, example: `dependabot-gitlab/dependabot`

## update

Trigger dependency update for single project and single package managed

  ```shell
  bundle exec rake 'dependabot:update[project,package_ecosystem,directory]'
  ```

* `project` - project full path, example: `dependabot-gitlab/dependabot`
* `package_ecosystem` - `package-ecosystem` parameter like `bundler`
* `directory` - directory is path where dependency files are stored, usually `/`

This task is used to provide standalone use capability

## validate

Validate `dependabot.yml` configuration file

```shell
bundle exec rake 'dependabot:validate[project]'
```

`project` - project full path, example: `dependabot-gitlab/dependabot`

# UI

Index page of application, like `http://localhost:3000/` will display a table with jobs currently configured to run dependency updates

# Development

* Install dependencies with `bundle install`
* Setup [pre-commit](https://pre-commit.com/) hooks with `pre-commit install`
* Make change and make sure tests pass with `bundle exec rspec` (some tests require instance of mongodb and redis which can be started via `docker-compose -f docker-compose.yml up` command)
* Submit merge request

# Supported by

[![jetbrains](images/jetbrains.png)](https://www.jetbrains.com/?from=dependabot-gitlab)
