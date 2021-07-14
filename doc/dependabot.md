# dependabot.yml configuration options

## registries

`dependabot-gitlab` supports registries just like the github native version: [configuring private registries](https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates#configuration-options-for-private-registries)

In order to pass sensitive credentials, `dependabot-gitlab` will fetch it from environment variables using pattern `${{ENV_VAR_NAME}}`.

```yml
registries:
  dockerhub:
    type: docker-registry
    url: https://registry.hub.docker.com
    username: ${{PRIVATE_DOCKER_USERNAME}}
    password: ${{PRIVATE_DOCKER_PASSWORD}}
```

In following example, environment variables `PRIVATE_DOCKER_USERNAME` and `PRIVATE_DOCKER_PASSWORD` will be used.

### Gitlab maven package registry

To [authenticate](https://docs.gitlab.com/ee/user/packages/maven_repository/#authenticate-with-a-personal-access-token-in-maven) to Gitlab Package Registry, `SETTINGS__GITLAB_ACCESS_TOKEN` is used automatically if the configured gitlab host matches the host of maven package registry. Only `type` and `url` needs to be present in registry configuration.

If it is required to use packages from different project package registries, make sure that gitlab access token has access to these projects as well.

## schedule

Unlike [github native](https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates#scheduleinterval), `schedule.interval` supports 2 different daily interval types:

* `daily` - runs every day
* `weekday` - runs on weekdays, Mon-Fri

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

* `Pipeline events` webhook is configured
* pipelines for merge requests must be enabled
* user must be able to merge
* merge request doesn't have mandatory approvals

```yml
auto-merge: true
```

In standalone mode this feature is not guaranteed to work due to gitlab limitation of accepting merge request before pipeline has been triggered. If pipeline
started with delay after merge request was created, trying to accept and auto merge might fail with `Method Not Allowed` error.

In service mode, merge request is accepted based on event sent on pipeline completion asynchronously instead of relying on gitlab's `merge_when_pipeline_succeeds` option.
