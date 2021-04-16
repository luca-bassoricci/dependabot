# dependabot.yml configuration options

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

In standalone mode this feature is not guaranteed to work due to gitlab limitation of accepting merge request before pipeline has been triggered. If pipeline
started with delay after merge request was created, trying to accept and auto merge might fail with `Method Not Allowed` error.

In service mode, merge request is accepted based on event sent on pipeline completion asynchronously instead of relying on gitlab's `merge_when_pipeline_succeeds` option.
