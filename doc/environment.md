# Configuration environment variables

## Main configuration

* `SETTINGS__GITLAB_URL` - url of gitlab instance, ex: `https://gitlab.com` by default
* `SETTINGS__GITLAB_ACCESS_TOKEN` - [gitlab](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html) personal access token with api scope
* `SETTINGS__GITHUB_ACCESS_TOKEN` - [github](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) personal access token with repository read scope, without it you can run into rate limits when fetching changelog and release notes for all dependencies which code comes from github
* `SETTINGS__GITLAB_AUTH_TOKEN` - optional gitlab webhook token which can be configured under webhook settings in gitlab, if not present,
token set in gitlab webhook configuration will be ignored
* `SETTINGS__DEPENDABOT_URL` - url application can be reached on, example: `https://dependabot-gitlab.com`. This url will be used to automatically
add necessary webhooks to project

## Private registry credentials

For dependabot to be able to resolve dependencies from private registries, credentials must be provided. Credentials are configured via
environment variables with following naming pattern:

* `SETTINGS__CREDENTIALS__{REGISTRY_TYPE}__{REGISTRY_NAME}__{REGISTRY_SPECIFIC_PARAM}`, where:
  * `REGISTRY_TYPE` - `MAVEN,DOCKER,NPM`
  * `REGISTRY_NAME` - some unique name identifying registry
  * `REGISTRY_SPECIFIC_PARAM` - parameters, like url, username, password depending on registry type

Please note the mandatory double underscores `__`\
Multiple registries of the same type can be configured at the same time

### Maven repositories

* `SETTINGS__CREDENTIALS__MAVEN__{REPOSITORY_NAME}__URL` - base url of the repository
* `SETTINGS__CREDENTIALS__MAVEN__{REPOSITORY_NAME}__USERNAME` - user with read access
* `SETTINGS__CREDENTIALS__MAVEN__{REPOSITORY_NAME}__PASSWORD` - password for the user

#### Gitlab package registry

To [authenticate](https://docs.gitlab.com/ee/user/packages/maven_repository/#authenticate-with-a-personal-access-token-in-maven) to Gitlab Package Registry, `SETTINGS__GITLAB_ACCESS_TOKEN` is used automatically if the configured gitlab host matches the host of maven package registry. Only `SETTINGS__CREDENTIALS__MAVEN__{REPOSITORY_NAME}__URL` variable needs to be configured in this case.

If it is required to use packages from different project package registries, make sure that gitlab access token has access to these projects as well.

### Docker registries

* `SETTINGS__CREDENTIALS__DOCKER__{REGISTRY_NAME}__REGISTRY` - registry hostname like `registry.hub.docker.com`
* `SETTINGS__CREDENTIALS__DOCKER__{REGISTRY_NAME}__USERNAME` - user with read access
* `SETTINGS__CREDENTIALS__DOCKER__{REGISTRY_NAME}__PASSWORD` - password for the user

### Npm registries

* `SETTINGS__CREDENTIALS__NPM__{REGISTRY_NAME}__REGISTRY` - registry url
* `SETTINGS__CREDENTIALS__NPM__{REGISTRY_NAME}__TOKEN` - authentication token

### Example

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
