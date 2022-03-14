# dependabot.yml configuration options

[[_TOC_]]

## default values

Some of the options have default values. Other options without a default value simply do not add additional desired effect.

```yml
version: 2
registries: 'default: none'
updates:
  - package-ecosystem: 'required'
    directory: 'required'
    schedule:
      interval: 'required'
      day: 'default: "random day"' # for weekly updates
      time: 'default: "random time"'
      timezone: 'default: "server timezone"'
      hours: 'default: "00-24"' # for random time
    pull-request-branch-name:
      separator: 'default: "-"'
      prefix: 'default: "dependabot"'
    allow:
      - dependency-type: 'default: "direct"'
    open-pull-requests-limit: 'default: 5'
    versioning-strategy: 'default: "auto"'
    rebase-strategy: 'default: "auto"'
    auto-merge: 'default: false'
    fork: 'default: false'
    vendor: 'default: false'
    insecure-external-code-execution: 'default: false'
    registries: 'default: "*"'
    labels: 'default: none'
    commit-message: 'default: none'
    milestone: 'default: none'
    ignore: 'default: none'
    assignees: 'default: none'
    reviewers: 'default: none'
    approvers: 'default: none'
```

## fork

It is possible to update dependencies from a forked project and create merge requests back to target project in order to not expose CI environment variables to updated dependencies right away.

For this option to work, project must be a fork and option must be present on top level of configuration file:

```yml
fork: true
```

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

### Random schedule

If `time` value is not provided, random time value will be set. \
If `day` value is not provided for `weekly` interval, random day of the week will be set.

Additionally it is possible to provide `hours` interval that will set fixed hour range for random time setting:

```yml
schedule:
  interval: daily
  hours: "9-17"
```

will set random hour between hours 9 and 17.

### Interval types

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

## rebase-strategy

Rebase strategy supports 3 options:

* `auto` - automatically recreate MR's with conflicts. Any manual changes will be overridden
* `all` - automatically rebase all existing outdated MR's or recreate MR's with conflicts
* `none` - do not perform automatic rebase or recreate

```yml
rebase-strategy: auto
```

or if approval option is used:

```yml
rebase-strategy:
  strategy: auto
  on-approval: false
```

If webhooks for deployed version are configured, when dependency update MR is merged, update of other open MR's of same package ecosystem is triggered

### rebase on mr approval

It is possible to trigger automatic rebase of merge request when it is approved. If `strategy` is omitted, it is set to `auto` by default.
Approval option is limited only to rebase, it will not recreate merge request if it has conflicts because it can lead to unwanted loss of local changes.

```yml
rebase-strategy:
  on-approval: true
```

## auto-merge

Automatically accept merge request and set it to merge when pipeline succeeds. In order for this function to work, following criteria must be met:

* `Pipeline events` or `Merge request events` webhook is configured
* pipelines for merge requests must be enabled in case of merge based on successful pipeline status
* user must be able to merge
* merge request must be approved if approvals are required

### allow/ignore

`auto-merge` key can be configured with optional `allow` or `ignore` rules that function same way as global [ignore](https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates#ignore). Both `allow` and `ignore` support `dependency-name`, `versions` and `update-types` parameters.\
If only `ignore` parameter is set, it is implied that all other dependencies are allowed to be automatically merged.

```yml
auto-merge:
  allow:
    # automatically merge only minor version lodash updates
    - dependency-name: "lodash"
      update-types: ["version-update:semver-minor"]
  ignore:
    # do not merge automatically all aws-sdk major version updates
    - dependency-name: aws-sdk
      update-types: ["version-update:semver-major"]
```

### on-approval

If mandatory approvals are set for merge requests, it is possible to set auto merging based on approval event rather than successful pipeline event:

```yml
auto-merge:
  on-approval: true
```

### Standalone

In standalone mode this feature is not guaranteed to work due to gitlab limitation of accepting merge request before pipeline has been triggered. If pipeline
started with delay after merge request was created, trying to accept and auto merge might fail with `Method Not Allowed` error.

In service mode, merge request is accepted based on event sent on pipeline completion asynchronously instead of relying on gitlab's `merge_when_pipeline_succeeds` option.

## approvers

In addition to setting merge request [reviewer](https://docs.gitlab.com/ee/user/project/merge_requests/getting_started.html#reviewer) via `reviewers` keyword, `approvers` keyword also exists.

This creates optional [approval rule](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/) with users from the list.

```yml
approvers:
  - dependabot-gitlab
```

## git trailers

It is possible to add custom git trailers to commit messages. For example to include commits in Gitlab built in [changelog](https://docs.gitlab.com/ee/api/repositories.html#add-changelog-data-to-a-changelog-file) generation functionality. Multiple git trailers can be added as array of key value pairs.

```yml
commit-message:
  trailers:
    - changelog: "dependency"
    - approved-by: "someone"
```
