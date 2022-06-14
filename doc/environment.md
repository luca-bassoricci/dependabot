# Configuration environment variables

## Databases

### MongoDb

**Not applicable for standalone mode**

Following environment variables are used for database connection configuration:

`MONGODB_URI` - all configuration options in a single uri parameter

or

`MONGODB_URL` - mongodb instance url
`MONGODB_USER` - mongodb username
`MONGODB_PASSWORD` - user password
`MONGODB_DATABASE` - database name
`MONGODB_RETRY_WRITES` - retry writes parameter, `true` by default

### Redis

**Not applicable for standalone mode**

`REDIS_URL` - redis instance url
`REDIS_PASSWORD` - redis password

## Application

* `SECRET_KEY_BASE` - custom key used for stored credentials encryption, [Rails documentation](https://apidock.com/rails/v6.0.0/Rails/Application/secret_key_base)
* `SETTINGS__LOG_LEVEL` - logging level, `[debug, info, warn, error]`. Default: `info`
* `SETTINGS__LOG_COLOR` - adds colorized log output. Default: `false`

### Access

* `SETTINGS__GITLAB_URL` - url of gitlab instance, ex: `https://gitlab.com` by default
* `SETTINGS__GITLAB_ACCESS_TOKEN` - [gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) personal access token with api scope
* `SETTINGS__GITHUB_ACCESS_TOKEN` - [github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) personal access token with repository read scope, without it you can run into rate limits when fetching changelog and release notes for all dependencies which code comes from github
* `SETTINGS__GITLAB_AUTH_TOKEN` - optional gitlab webhook token which can be configured under webhook settings in gitlab, if not present,
token set in gitlab webhook configuration will be ignored

### Webhooks

**Not applicable for standalone mode**

* `SETTINGS__DEPENDABOT_URL` - url application can be reached on, example: `https://dependabot-gitlab.com`. This url will be used to automatically
add necessary webhooks to project
* `SETTINGS__CREATE_PROJECT_HOOK` - enable or disable automated hook creation, default `true`. This can be useful if the user associated with used access token, does not have maintainer role
* `SETTINGS__COMMANDS_PREFIX` - bot name/prefix for comment commands in merge requests

### Configuration

* `SETTINGS__CONFIG_BASE_TEMPLATE` - base configuration that will be merged with project specific `dependabot.yml` configuration file
* `SETTINGS__CONFIG_FILENAME` - custom configuration file location, default: `.gitlab/dependabot.yml`
* `SETTINGS__CONFIG_BRANCH` - custom branch to fetch `dependabot.yml`. This option does not affect target branch where dependabot checks for manifest files and raises merge requests against. For that, [target-branch](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file#target-branch) option in configuration file itself must be used
* `SETTINGS__BRANCH_NAME_SEPARATOR` - override default value of branch name separator
* `SETTINGS__OPEN_PULL_REQUEST_LIMIT` - override default value of open pull requests

### Update jobs

**Not applicable for standalone mode**

* `SETTINGS__UPDATE_RETRY` - amount of retries for dependency update job or `false` to disable, default: 2. Applicable only to deployed mode

### Project registration

**Not applicable for standalone mode**

* `SETTINGS__PROJECT_REGISTRATION`
  * `manual` - default value which disables automated project registration
  * `system_hook` - enable `api/project/registration` endpoint for system webhook configuration
  * `automatic` - creates a cron job which automatically scans all projects where user associated with used gitlab access token has at least developer role and adds project if `dependabot.yml` configuration file is present
* `SETTINGS__PROJECT_REGISTRATION_CRON` - cron expression for project registration job in `automatic` mode, default: `0 5 * * *`
* `SETTINGS__PROJECT_REGISTRATION_NAMESPACE` - regex pattern of namespaces allowed to be registered automatically

### Metrics

**Not applicable for standalone mode**

* `SETTINGS__METRICS` - enable `/metrics` endpoint for prometheus compatible metrics

## Sentry

* `SENTRY_DSN` - [sentry dsn](https://docs.sentry.io/platforms/ruby/configuration/options/#environment-variables) value
* `SETTINGS__SENTRY_TRACES_SAMPLE_RATE` - [traces sample rate](https://docs.sentry.io/platforms/ruby/performance/#configure-the-sample-rate), default: 0.0
* `SETTINGS__SENTRY_IGNORED_ERRORS` - comma separated string of exceptions to exclude from reporting to sentry
