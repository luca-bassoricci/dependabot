# dependabot.yml configuration options

[[_TOC_]]

## default values

Some of the options have default values. Other options without a default value simply do not add additional desired effect.

```yml
version: 2
registries: 'default: none'
vulnerability-alerts: 'default: { enabled: true }'
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
    updater-options: 'default: none'
    vulnerability-alerts: 'default: none'
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

```yml
maven-gitlab:
  type: maven-repository
  url: https://gitlab.com/api/v4/projects/:project_id/packages/maven
```

* `project_id` - id number of project

### Gitlab npm package registry

For npm gitlab registry to work, 2 entries have to be present in configuration

```yml
npm-gitlab:
  type: npm-registry
  url: https://gitlab.com/api/v4/projects/:project_id/packages/npm
  token: ${{GITLAB_NPM_REGISTRY_TOKEN}}
npm-gitlab-instance:
  type: npm-registry
  url: https://gitlab.com/api/v4/packages/npm
  token: ${{GITLAB_NPM_REGISTRY_TOKEN}}
```

* `project_id` - id number of project
* `GITLAB_NPM_REGISTRY_TOKEN` - environment variable name with token injected within `dependabot-gitlab` container

### Gitlab python package registry

```yml
python-gitlab:
  type: python-index
  url: https://gitlab.com/api/v4/projects/:project_id/packages/pypi/simple
  username: :token_name
  password: ${{GITLAB_PYPI_TOKEN}}
  replaces-base: false
```

* `project_id` - id number of project
* `token_name` - name of created private access token
* `GITLAB_PYPI_TOKEN` - environment variable name with token injected within `dependabot-gitlab` container

Additionally, dependency file of whatever python tool is used, will have to define url with credentials in order for native
helpers to be able to authenticate.

Example with pipfile:

```
[[source]]
name = "gitlab"
url = "https://token_name:${GITLAB_PYPI_TOKEN}@gitlab.com/api/v4/projects/:project_id/packages/pypi/simple"
verify_ssl = true
```

### Gitlab terraform registry

```yml
terraform-gitlab:
  type: terraform-registry
  url: https://gitlab.com
  token: ${{GITLAB_TF_REGISTRY_TOKEN}}
```

* `GITLAB_TF_REGISTRY_TOKEN` - environment variable name with token injected within `dependabot-gitlab` container

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

It is possible to trigger automatic rebase/recreate of merge request when it is approved. If `strategy` is omitted, it is set to `auto` by default.
Approval option is limited only to rebase, it will not recreate merge request if it has conflicts because it can lead to unwanted loss of local changes.

```yml
rebase-strategy:
  on-approval: true
```

### rebase with assignee

It is possible to configure auto rebase/recreate of merge request only when it has a specific assignee.

This allows to create a workflow where by default merge requests are assigned to a specific user
(for example owner of the gitlab access token used by the app) and as soon
as another user takes over ownership, dependabot stops updating merge request automatically.

```yml
rebase-strategy:
  with-assignee: dependabot
```

* `with-assignee` - assignee username

## auto-merge

Automatically accept merge request and set it to merge when pipeline succeeds. In order for this function to work, following criteria must be met:

* `Pipeline events` or `Merge request events` webhook is configured
* pipelines for merge requests must be enabled in case of merge based on successful pipeline status
* user must be able to merge
* merge request must be approved if approvals are required

```yml
auto-merge: true
```

### squash

Because gitlab does not automatically set squash option to `true` for merge requests when squashing is required in project settings, it has to be set manually in order to avoid error `This project requires squashing commits when merge requests are accepted. Try again.` when performing auto merging.

```yml
auto-merge:
  squash: true
```

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

## commit-message

It is possible to add custom git trailers to commit messages. For example to include commits in Gitlab built in [changelog](https://docs.gitlab.com/ee/api/repositories.html#add-changelog-data-to-a-changelog-file) generation functionality. Multiple git trailers can be added as array of key value pairs.

```yml
commit-message:
  trailers:
    - changelog: "dependency"
    - approved-by: "someone"
```

### security commit trailers

It is possible to pass different changelog trailers for security merge requests.

```yml
commit-message:
  trailers-security:
    - changelog: "security"
```

### development dependency commit trailers

Similar to development dependency commit message prefix, it is possible to pass different commit trailers to development dependencies.

```yml
commit-message:
  trailers-development:
    - changelog: "development-dependencies"
```

## updater-options

It is possible to pass custom options to internal `dependabot-core` classes. Hash defined under `updater-options` is passed to following classes:

* [file_parsers](https://github.com/dependabot/dependabot-core/tree/main/common/lib/dependabot/file_parsers)
* [file_updaters](https://github.com/dependabot/dependabot-core/tree/main/common/lib/dependabot/file_updaters)
* [update_checkers](https://github.com/dependabot/dependabot-core/tree/main/common/lib/dependabot/update_checkers)

This option require knowledge of inner workings of `dependabot-core`, use at your own risk as input is not validated and can lead to failures.

```yml
updater-options:
  goprivate: "custom-value"
```

## vulnerability alerts

Top level option allows to configure [vulnerability alerts](../README.md#vulnerability-alerts) for all configured package ecosystems.

```yml
version: 2
vulnerability-alerts:
  enabled: true
  assignees:
    - john_doe
updates:
  - package-ecosystem: ...
  - package-ecosystem: ...
```

Options under specific package ecosystem override global option.

```yml
version: 2
updates:
  - package-ecosystem: ...
    vulnerability-alerts:
      enabled: false
```
