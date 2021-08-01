# Configuration environment variables

## App configuration

### Access

* `SETTINGS__GITLAB_URL` - url of gitlab instance, ex: `https://gitlab.com` by default
* `SETTINGS__GITLAB_ACCESS_TOKEN` - [gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) personal access token with api scope
* `SETTINGS__GITHUB_ACCESS_TOKEN` - [github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) personal access token with repository read scope, without it you can run into rate limits when fetching changelog and release notes for all dependencies which code comes from github
* `SETTINGS__GITLAB_AUTH_TOKEN` - optional gitlab webhook token which can be configured under webhook settings in gitlab, if not present,
token set in gitlab webhook configuration will be ignored

### Webhooks

* `SETTINGS__DEPENDABOT_URL` - url application can be reached on, example: `https://dependabot-gitlab.com`. This url will be used to automatically
add necessary webhooks to project

### Configuration
* `SETTINGS__CONFIG_FILENAME` - custom configuration file location, default: `.gitlab/dependabot.yml`
* `SETTINGS__CONFIG_BRANCH` - custom branch to fetch `dependabot.yml`, project default branch if not configured

### Update jobs

* `SETTINGS__UPDATE_RETRY` - amount of retries for dependency update job or `false` to disable, default: 2. Applicable only to deployed mode

### Project registration

* `SETTINGS__PROJECT_REGISTRATION`
  * `manual` - default value which disables automated project registration
  * `system_hook` - enable `api/project/registration` endpoint for system webhook configuration
  * `automatic` - creates a cron job which automatically scans all projects where user associated with used gitlab access token has at least developer role and adds project if `dependabot.yml` configuration file is present
* `SETTINGS__PROJECT_REGISTRATION_CRON` - cron expression for project registration job in `automatic` mode, default: `0 5 * * *`
* `SETTINGS__PROJECT_REGISTRATION_NAMESPACE` - regex pattern of namespaces allowed to be registered automatically
