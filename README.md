**This project is not affiliated with, funded by, or associated with the Dependabot team or GitHub**

**This software is Work in Progress: features will appear and disappear, API will be changed, your feedback is always welcome!**

# Supported by

[![jetbrains](images/jetbrains.png)](https://www.jetbrains.com/?from=dependabot-gitlab)
[![gitlab foss](images/gitlab.png)](https://about.gitlab.com/solutions/open-source/)
[![DigitalOcean Referral Badge](https://web-platforms.sfo2.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=ad4b9edb881f&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

---

Application providing automated dependency updates based on [dependabot-core](https://github.com/dependabot/dependabot-core)

[[_TOC_]]

# Docker image

- [Release](https://hub.docker.com/r/andrcuns/dependabot-gitlab/tags) - `docker.io/andrcuns/dependabot-gitlab:latest`

# Usage

## Standalone

It is possible to use app in "standalone" mode without the need to deploy. Project [dependabot-standalone](https://gitlab.com/dependabot-gitlab/dependabot-standalone) contains pipeline configuration to run dependency updates via scheduled gitlab pipelines.

This mode can be used similarly to [dependabot-script](https://github.com/dependabot/dependabot-script), which inspired
creation of this project. Standalone mode is limited to following features:

- basic dependency updates
- limited ability of MR automerge

Features not supported:

- automatic closure of superseeded merge requests
- merge request commands
- webhooks
- UI with managed project list

## Service

dependabot-gitlab is packaged as docker container and it's possible to deploy it via various means described in [Deployment](#Deployment) section.

Deployed version is considered to be the primary and has priority on adding and maintaining features.

# Deployment

## Helm

Preferred way of deployment is via [helm](https://helm.sh/) package manager using [dependabot-gitlab](https://gitlab.com/dependabot-gitlab/chart) chart.

```bash
helm repo add dependabot https://dependabot-gitlab.gitlab.io/chart
helm install dependabot dependabot/dependabot-gitlab --set credentials.gitlab_access_token=$gitlab_access_token
```

## Docker Compose

Simple example deployment can be seen in [docker-compose.yml](docker-compose.yml). Deployment consists of 5 containers - web server, sidekiq
worker, migrations, mongodb and redis. Simple production like deployment using `docker-compose` can be done with following command:

```bash
docker compose up
```

# Configuration

## dependabot.yml

Repository must contain `.gitlab/dependabot.yml` configuration for dependabot updates to work.
`dependabot-gitlab` strives to achieve parity with all possible Github native options.
Some of the options can have slightly different behavior which is described in the documentation linked below.

- Github documentation: [configuration options](https://docs.github.com/en/github/administering-a-repository/configuration-options-for-dependency-updates)
- Additional `dependabot-gitlab` specific options: [configuration options](doc/dependabot.md)

Following configuration options are currently supported:

| option                             | dependabot         | dependabot-standalone |
| ---------------------------------- | ------------------ | --------------------- |
| `package-ecosystem`                | :white_check_mark: | :white_check_mark:    |
| `directory`                        | :white_check_mark: | :white_check_mark:    |
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
| `target-branch`                    | :white_check_mark: | :white_check_mark:    |
| `vendor`                           | :white_check_mark: | :white_check_mark:    |
| `versioning-strategy`              | :white_check_mark: | :white_check_mark:    |
| `registries`                       | :white_check_mark: | :white_check_mark:    |
| `fork`                             | :white_check_mark: | :white_check_mark:    |
| `schedule.interval`                | :white_check_mark: | :x:                   |
| `schedule.day`                     | :white_check_mark: | :x:                   |
| `schedule.time`                    | :white_check_mark: | :x:                   |
| `schedule.timezone`                | :white_check_mark: | :x:                   |

## Application

### Helm chart

For all configuration options, refer to [chart repository](https://gitlab.com/dependabot-gitlab/chart/-/blob/master/README.md)

### Manual

[environment.md](doc/environment.md) describes all possible environment variables for use with `docker-compose` or `standalone` mode.

## Webhooks

If `env.dependabotUrl` in helm values or `SETTINGS__DEPENDABOT_URL` is not set, following [webhooks](https://docs.gitlab.com/ee/user/project/integrations/webhooks.html) with url `http://{dependabot_host}/api/hooks` and optional secret token have to be created in project manually:

- `Push events` - default repository branch
- `Merge request events`
- `Comments`
- `Pipeline events`

It is possible to set up system hooks on Gitlab instance level as well. Make sure `SETTINGS__CREATE_PROJECT_HOOK` is set to `false` so project specific hooks are not created automatically.

# Adding projects

In order for application to start updating dependencies, projects have to be registered first which will create scheduled dependency update jobs.
Several ways of adding projects exist.

## Automatically

### Project registration job

It is possible to enable project registration job, which will periodically scan for projects to register. [Configuration options](doc/environment.md#project_registration)

The job will also update dependency update jobs if configuration in `dependabot.yml` has changed and remove dependency updates for projects that no longer have the configuration.

Since the job tries to register all of the projects where user associated with the access token used has at least developer access, it might be necessary to disable hook creation, because it requires maintainer level access. `SETTINGS_CREATE_PROJECT_HOOK` must be set to `false` in this case.

Additionally option `SETTINGS__PROJECT_REGISTRATION_NAMESPACE` can restrict namespaces allowed to automatically register projects.

### System hook

If [project registration option](doc/environment.md#project_registration) is set to `system_hook`, endpoint `api/project/registration` endpoint is enabled which listens for following [system hook](https://docs.gitlab.com/ee/system_hooks/system_hooks.html) events to automatically register projects:

- `project_create`
- `project_destroy`
- `project_rename`
- `project_transfer`

Additionally option `SETTINGS__PROJECT_REGISTRATION_NAMESPACE` can restrict namespaces allowed to automatically register projects.

## Manually

### Project webhook

If project webhook was added manually beforehand, project will be registered once `.dependabot.yml` configuration file is pushed to repository.

Project is removed from dependabot instance if dependabot.yml file is deleted from repository.

### API

[add project](#add-project)

### Rake task

[register](#register) rake task

# Api endpoints

## Gitlab webhooks

POST `/api/hooks`

Handle following gitlab event webhooks

- `Push events` - default repository branch
- `Merge request events`
- `Comments`
- `Pipeline events`

## List projects

GET `/api/projects`

Response:

```json
[
  {
    "id": 1,
    "name": "dependabot-gitlab/dependabot",
    "forked_from_id": null,
    "webhook_id": 1,
    "web_url": "https://gitlab.com/dependabot-gitlab/dependabot",
    "config": [
      {
        "package_manager": "bundler",
        "package_ecosystem": "bundler",
        "directory": "/",
        "milestone": "0.0.1",
        "assignees": ["john_doe"],
        "reviewers": ["john_smith"],
        "approvers": ["jane_smith"],
        "custom_labels": ["dependency"],
        "open_merge_requests_limit": 10,
        "cron": "00 02 * * sun Europe/Riga",
        "branch_name_separator": "-",
        "branch_name_prefix": "dependabot",
        "allow": [
          {
            "dependency_type": "direct"
          }
        ],
        "ignore": [
          {
            "dependency_name": "rspec",
            "versions": ["3.x", "4.x"]
          },
          {
            "dependency_name": "faker",
            "update_types": ["version-update:semver-major"]
          }
        ],
        "rebase_strategy": "auto",
        "auto_merge": true,
        "versioning_strategy": "lockfile_only",
        "reject_external_code": true,
        "commit_message_options": {
          "prefix": "dep",
          "prefix_development": "bundler-dev",
          "include_scope": "scope"
        },
        "registries": [
          {
            "type": "docker_registry",
            "registry": "https://registry.hub.docker.com",
            "username": "octocat"
          }
        ]
      }
    ]
  }
]
```

## Get project

GET `/api/projects/:id`

- `id` - URL escaped full path or id of the project

Response:

```json
{
  "id": 1,
  "name": "dependabot-gitlab/dependabot",
  "forked_from_id": null,
  "webhook_id": 1,
  "web_url": "https://gitlab.com/dependabot-gitlab/dependabot",
  "config": [
    {
      "package_manager": "bundler",
      "package_ecosystem": "bundler",
      "directory": "/",
      "milestone": "0.0.1",
      "assignees": ["john_doe"],
      "reviewers": ["john_smith"],
      "approvers": ["jane_smith"],
      "custom_labels": ["dependency"],
      "open_merge_requests_limit": 10,
      "cron": "00 02 * * sun Europe/Riga",
      "branch_name_separator": "-",
      "branch_name_prefix": "dependabot",
      "allow": [
        {
          "dependency_type": "direct"
        }
      ],
      "ignore": [
        {
          "dependency_name": "rspec",
          "versions": ["3.x", "4.x"]
        },
        {
          "dependency_name": "faker",
          "update_types": ["version-update:semver-major"]
        }
      ],
      "rebase_strategy": "auto",
      "auto_merge": true,
      "versioning_strategy": "lockfile_only",
      "reject_external_code": true,
      "commit_message_options": {
        "prefix": "dep",
        "prefix_development": "bundler-dev",
        "include_scope": "scope"
      },
      "registries": [
        {
          "type": "docker_registry",
          "registry": "https://registry.hub.docker.com",
          "username": "octocat"
        }
      ]
    }
  ]
}
```

## Add project

POST `/api/projects`

Add new project or update existing one and sync jobs

Request:

```json
{
  "project": "dependabot-gitlab/dependabot"
}
```

## Update project

PUT `/api/projects/:id`

Update project attributes

Request:

- `id` - URL escaped full path or id of the project
- `name` - full project path
- `forked_from_id` - id of upstream project
- `webhook_id` - webhook id
- `web_url` - project web url
- `config` - dependabot configuration array

```json
{
  "name":"name",
  "forked_from_id": 1,
  "webhook_id":1,
  "web_url": "new-url",
  "config": []
}
```

## Delete project

DELETE `/api/projects/:id`

- `id` - URL escaped full path or id of the project

## Notify release

POST `/api/notify_release`

Notifies Dependabot of dependency release. In response, Dependabot will check all projects and update the package.

- `name`: package name
- [`package-ecosystem`](https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates#package-ecosystem): value from supported ecosystem.

```json
{
  "name": "package-name",
  "package_ecosystem": "package-ecosystem"
}
```

## Healthcheck

GET `/healthcheck`

Check if application is running and responding

# Rake tasks

Several administrative [rake](https://github.com/ruby/rake) tasks exist which can be executed from app working directory.

## register

Manually register project for updates. Repository must have valid dependabot config file

```shell
/home/dependabot/app$ bundle exec rake 'dependabot:register[project]'
```

`project` - project full path, example: `dependabot-gitlab/dependabot`

## remove

Manually remove project.

```shell
/home/dependabot/app$ bundle exec rake 'dependabot:remove[project]'
```

`project` - project full path, example: `dependabot-gitlab/dependabot`

## update

Trigger dependency update for single project and single package managed

```shell
/home/dependabot/app$ bundle exec rake 'dependabot:update[project,package_ecosystem,directory]'
```

- `project` - project full path, example: `dependabot-gitlab/dependabot`
- `package_ecosystem` - `package-ecosystem` parameter like `bundler`
- `directory` - directory is path where dependency files are stored, usually `/`

This task is used to provide standalone use capability

## validate

Validate `dependabot.yml` configuration file

```shell
/home/dependabot/app$ bundle exec rake 'dependabot:validate[project]'
```

`project` - project full path, example: `dependabot-gitlab/dependabot`

# UI

Index page of application, like `http://localhost:3000/` will display a table with jobs currently configured to run dependency updates

# Development

- Install dependencies with `bundle install`
- Setup [pre-commit](https://pre-commit.com/) hooks with `pre-commit install`
- Make change and make sure tests pass with `bundle exec rspec` (some tests require instance of mongodb and redis which can be started via `docker-compose -f docker-compose.yml up` command)
- Submit merge request
