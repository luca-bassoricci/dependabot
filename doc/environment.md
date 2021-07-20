# Configuration environment variables

## Main configuration

* `SETTINGS__GITLAB_URL` - url of gitlab instance, ex: `https://gitlab.com` by default
* `SETTINGS__GITLAB_ACCESS_TOKEN` - [gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) personal access token with api scope
* `SETTINGS__GITHUB_ACCESS_TOKEN` - [github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) personal access token with repository read scope, without it you can run into rate limits when fetching changelog and release notes for all dependencies which code comes from github
* `SETTINGS__GITLAB_AUTH_TOKEN` - optional gitlab webhook token which can be configured under webhook settings in gitlab, if not present,
token set in gitlab webhook configuration will be ignored
* `SETTINGS__DEPENDABOT_URL` - url application can be reached on, example: `https://dependabot-gitlab.com`. This url will be used to automatically
add necessary webhooks to project
* `SETTINGS__CONFIG_FILENAME` - custom configuration file location, default: `.gitlab/dependabot.yml`
* `SETTINGS__CONFIG_BRANCH` - custom branch to fetch `dependabot.yml`, project default branch if not configured
* `SETTINGS__UPDATE_RETRY` - amount of retries for dependency update job or `false` to disable, default: 2. Applicable only to deployed mode
