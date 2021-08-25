# CHANGELOG

## [v0.9.7 - 2021-08-25](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🐞 Bug Fixes

- do not count closed mrs towards configured limit. See merge request dependabot-gitlab/dependabot!967 - (andrejs)
- Revert "Merge branch 'dependabot-bundler-sidekiq-6.2.2' into 'master'". See merge request dependabot-gitlab/dependabot!963 - (andrejs)

### 📦 Dependency updates

- bump sidekiq from 6.2.1 to 6.2.2. See merge request dependabot-gitlab/dependabot!961 - (andrejs)

### 📦🛠️ Development dependency updates

- bump faker from 2.18.0 to 2.19.0. See merge request dependabot-gitlab/dependabot!962 - (andrejs)

### 👀 Links

[Commits since v0.9.6](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.9.6...v0.9.7)

## [v0.9.6 - 2021-08-23](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- allow configuring mongodb connection with uri parameter. See merge request dependabot-gitlab/dependabot!953 - (andrejs)

### 🛠️ Chore

- remove code-quality job from CI. See merge request dependabot-gitlab/dependabot!959 - (andrejs)
- move deployed app to mongodb atlas. See merge request dependabot-gitlab/dependabot!958 - (andrejs)
- cleanup .dockerignore. See merge request dependabot-gitlab/dependabot!956 - (andrejs)
- use mongodb uri for production only. See merge request dependabot-gitlab/dependabot!955 - (andrejs)
- add succesful log message to db and redis check. See merge request dependabot-gitlab/dependabot!951 - (andrejs)

### 📄 Documentation updates

- document env variables used for db connections. See merge request dependabot-gitlab/dependabot!957 - (andrejs)

### 👀 Links

[Commits since v0.9.5](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.9.5...v0.9.6)

## [v0.9.5 - 2021-08-22](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🛠️ Chore

- add tasks to check mongodb and redis connections. See merge request dependabot-gitlab/dependabot!950 - (andrejs)

### 👀 Links

[Commits since v0.9.4](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.9.4...v0.9.5)

## [v0.9.4 - 2021-08-22](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🐞 Bug Fixes

- add db folder to final image. See merge request dependabot-gitlab/dependabot!948 - (andrejs)

### 🛠️ Chore

- add migration service to docker-compose. See merge request dependabot-gitlab/dependabot!949 - (andrejs)

### 👀 Links

[Commits since v0.9.3](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.9.3...v0.9.4)

## [v0.9.3 - 2021-08-21](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New features

- Generate random cron if not provided. See merge request dependabot-gitlab/dependabot!944 - (andrejs)

### 🐞 Bug Fixes

- generate random cron based on full dependency update entry. See merge request dependabot-gitlab/dependabot!945 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.159.2 to 0.160.0. See merge request dependabot-gitlab/dependabot!937 - (andrejs)
- bump rails from 6.1.4 to 6.1.4.1. See merge request dependabot-gitlab/dependabot!938 - (andrejs)
- bump dependabot-omnibus from 0.159.1 to 0.159.2. See merge request dependabot-gitlab/dependabot!933 - (andrejs)
- bump dependabot-omnibus from 0.159.0 to 0.159.1. See merge request dependabot-gitlab/dependabot!931 - (andrejs)

### 📦🛠️ Development dependency updates

- bump allure-rspec from 2.14.3 to 2.14.5. See merge request dependabot-gitlab/dependabot!940 - (andrejs)
- bump rubocop from 1.19.0 to 1.19.1. See merge request dependabot-gitlab/dependabot!939 - (andrejs)
- bump rubocop-performance from 1.11.4 to 1.11.5. See merge request dependabot-gitlab/dependabot!934 - (andrejs)
- bump debian from 10.10-slim to 11.0-slim in /.gitlab/ci. See merge request dependabot-gitlab/dependabot!932 - (andrejs)

### 🛠️ Chore

- add mongoid migrations. See merge request dependabot-gitlab/dependabot!946 - (andrejs)
- generate allure test reports for master branch only. See merge request dependabot-gitlab/dependabot!942 - (andrejs)

### 👀 Links

[Commits since v0.9.2](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.9.2...v0.9.3)

## [v0.9.2 - 2021-08-16](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- add an easy way to execute a job. See merge request dependabot-gitlab/dependabot!929 - (@jerbob92)
- add support for forked mrs for standalone mode. See merge request dependabot-gitlab/dependabot!923 - (andrejs)

### 🐞 Bug Fixes

- do not run auto-merge immediately for deployed version. See merge request dependabot-gitlab/dependabot!924 - (andrejs)

### 📦🛠️ Development dependency updates

- bump rspec-rails from 5.0.1 to 5.0.2. See merge request dependabot-gitlab/dependabot!925 - (andrejs)

### 🛠️ Chore

- skip allure report generation for forks. See merge request dependabot-gitlab/dependabot!928 - (andrejs)
- fix rspec random failure. See merge request dependabot-gitlab/dependabot!927 - (andrejs)
- local development improvements. See merge request dependabot-gitlab/dependabot!926 - (andrejs)

### 👀 Links

[Commits since v0.9.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.9.1...v0.9.2)

## [v0.9.1 - 2021-08-14](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- add rescue for BadRequest responses from gitlab when registering projects. See merge request dependabot-gitlab/dependabot!921 - (@rapgru)

### 📦 Dependency updates

- bump sentry-sidekiq from 4.6.4 to 4.6.5. See merge request dependabot-gitlab/dependabot!918 - (andrejs)
- bump sentry-ruby from 4.6.4 to 4.6.5. See merge request dependabot-gitlab/dependabot!917 - (andrejs)
- bump sentry-rails from 4.6.4 to 4.6.5. See merge request dependabot-gitlab/dependabot!916 - (andrejs)

### 📦🛠️ Development dependency updates

- bump reek from 6.0.5 to 6.0.6. See merge request dependabot-gitlab/dependabot!919 - (andrejs)
- bump rubocop from 1.18.4 to 1.19.0. See merge request dependabot-gitlab/dependabot!920 - (andrejs)

### 🛠️ Chore

- simplify configuration loading. See merge request dependabot-gitlab/dependabot!922 - (andrejs)

### 👀 Links

[Commits since v0.9.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.9.0...v0.9.1)

## [v0.9.0 - 2021-08-12](https://gitlab.com/dependabot-gitlab/dependabot/-/releases) *BREAKING*

### 🔬 Improvements

- [BREAKING] allow passing reviewers and approvers separately. See merge request dependabot-gitlab/dependabot!915 - (andrejs)
- move ignore conditions to update checker. Closes #88. See merge request dependabot-gitlab/dependabot!912 - (andrejs)
- add rake task for project removal. See merge request dependabot-gitlab/dependabot!901 - (andrejs)

### 🐞 Bug Fixes

- do not set required approvals by default. See merge request dependabot-gitlab/dependabot!910 - (andrejs)
- correctly pass keyword args for rule handler. See merge request dependabot-gitlab/dependabot!909 - (andrejs)
- update setting reviewers. See merge request dependabot-gitlab/dependabot!905 - (andrejs)
- pass correct project id for forked mrs. See merge request dependabot-gitlab/dependabot!903 - (andrejs)
- correctly fetch id of forked_from project. See merge request dependabot-gitlab/dependabot!900 - (andrejs)

### 🛠️ Chore

- use dependabot wildcard matcher to compare dependency-name. See merge request dependabot-gitlab/dependabot!914 - (andrejs)
- remove semantic_range gem. See merge request dependabot-gitlab/dependabot!913 - (andrejs)
- add ignored dependency to e2e test. See merge request dependabot-gitlab/dependabot!911 - (andrejs)
- update gitlab mock with approval rules endpoint. See merge request dependabot-gitlab/dependabot!906 - (andrejs)
- update e2e tests with proper mocked responses. See merge request dependabot-gitlab/dependabot!904 - (andrejs)

### 📄 Documentation updates

- remove duplicate option from table. See merge request dependabot-gitlab/dependabot!908 - (andrejs)
- document option for fork workflow. See merge request dependabot-gitlab/dependabot!902 - (andrejs)

### 👀 Links

[Commits since v0.8.2](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.8.2...v0.9.0)

## [v0.8.2 - 2021-08-07](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New features

- allow MR creation from forked project. See merge request dependabot-gitlab/dependabot!890 - (andrejs)

### 🔬 Improvements

- check for cron updates on project sync. See merge request dependabot-gitlab/dependabot!898 - (andrejs)
- allow global overrides for branch name seperator and open pull request limit. Closes #107. See merge request dependabot-gitlab/dependabot!896 - (andrejs)

### 🐞 Bug Fixes

- paginate response when fetching projects for registration. See merge request dependabot-gitlab/dependabot!895 - (andrejs)
- convert ObjectifiedHash to Hash to avoid warnings. See merge request dependabot-gitlab/dependabot!892 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.158.0 to 0.159.0. See merge request dependabot-gitlab/dependabot!888 - (andrejs)

### 📦🛠️ Development dependency updates

- bump webmock from 3.13.0 to 3.14.0. See merge request dependabot-gitlab/dependabot!889 - (andrejs)

### 🛠️ Chore

- add full config path to log. See merge request dependabot-gitlab/dependabot!899 - (andrejs)
- improve project registration spec and logging. See merge request dependabot-gitlab/dependabot!894 - (andrejs)
- check gitlab project exists when registering. See merge request dependabot-gitlab/dependabot!893 - (andrejs)

### 👀 Links

[Commits since v0.8.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.8.1...v0.8.2)

## [v0.8.1 - 2021-08-05](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- add support for update-types parameter in ignore rule. See merge request dependabot-gitlab/dependabot!885 - (andrejs)

### 👀 Links

[Commits since v0.8.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.8.0...v0.8.1)

## [v0.8.0 - 2021-08-05](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New features

- project registration via system hooks. See merge request dependabot-gitlab/dependabot!869 - (andrejs)
- cron job to automatically scan projects to register. See merge request dependabot-gitlab/dependabot!854 - (andrejs)
- rebase/recreate other open mrs after merging dependency updates. Closes #52. See merge request dependabot-gitlab/dependabot!841 - (andrejs)

### 🔬 Improvements

- add create project hook config option. See merge request dependabot-gitlab/dependabot!886 - (andrejs)
- make metrics server configurable. See merge request dependabot-gitlab/dependabot!865 - (andrejs)

### 🐞 Bug Fixes

- rescue forbidden error on hook creation. See merge request dependabot-gitlab/dependabot!887 - (andrejs)
- always recreate mr on recreate command. See merge request dependabot-gitlab/dependabot!873 - (andrejs)
- set sidekiq initialization to be first. See merge request dependabot-gitlab/dependabot!864 - (andrejs)
- fix 'recreate' command. See merge request dependabot-gitlab/dependabot!863 - (andrejs)
- correctly pass arguments to MergeRequestService. See merge request dependabot-gitlab/dependabot!851 - (andrejs)
- log auto-rebase triggered only if mrs exist. See merge request dependabot-gitlab/dependabot!850 - (andrejs)
- do not trigger updates for merged mr if auto-rebase is disabled. See merge request dependabot-gitlab/dependabot!846 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.157.1 to 0.158.0. See merge request dependabot-gitlab/dependabot!882 - (andrejs)
- bump mongoid from 7.3.1 to 7.3.2. See merge request dependabot-gitlab/dependabot!883 - (andrejs)
- bump bootsnap from 1.7.6 to 1.7.7. See merge request dependabot-gitlab/dependabot!879 - (andrejs)
- bump sentry-rails from 4.6.3 to 4.6.4. See merge request dependabot-gitlab/dependabot!857 - (andrejs)
- bump sentry-ruby from 4.6.3 to 4.6.4. See merge request dependabot-gitlab/dependabot!858 - (andrejs)
- bump sentry-sidekiq from 4.6.3 to 4.6.4. See merge request dependabot-gitlab/dependabot!859 - (andrejs)
- bump puma from 5.3.2 to 5.4.0. See merge request dependabot-gitlab/dependabot!856 - (andrejs)
- bump bootsnap from 1.7.5 to 1.7.6. See merge request dependabot-gitlab/dependabot!847 - (andrejs)
- bump dependabot-omnibus from 0.156.9 to 0.157.1. See merge request dependabot-gitlab/dependabot!848 - (andrejs)
- bump sentry-rails from 4.6.1 to 4.6.3. See merge request dependabot-gitlab/dependabot!842 - (andrejs)
- bump sentry-ruby from 4.6.1 to 4.6.3. See merge request dependabot-gitlab/dependabot!843 - (andrejs)
- bump sentry-sidekiq from 4.6.1 to 4.6.3. See merge request dependabot-gitlab/dependabot!844 - (andrejs)

### 📦🛠️ Development dependency updates

- update helmfile version. See merge request dependabot-gitlab/dependabot!878 - (andrejs)
- bump reek from 6.0.4 to 6.0.5. See merge request dependabot-gitlab/dependabot!875 - (andrejs)
- bump dependabot-gitlab/dependabot/ruby from 2.7.3-buster-latest to 2.7.4-buster-latest in /spec/fixture/gitlab. See merge request dependabot-gitlab/dependabot!853 - (andrejs)
- bump solargraph from 0.42.4 to 0.43.0. See merge request dependabot-gitlab/dependabot!845 - (andrejs)

### 🛠️ Chore

- set different default cron value for registration job. See merge request dependabot-gitlab/dependabot!881 - (andrejs)
- start brakeman and bundle-autid right away. See merge request dependabot-gitlab/dependabot!876 - (andrejs)
- log healthcheck job to debug level. See merge request dependabot-gitlab/dependabot!872 - (andrejs)
- revert sampler changes for sentry. See merge request dependabot-gitlab/dependabot!871 - (andrejs)
- sentry configuration improvements. See merge request dependabot-gitlab/dependabot!870 - (andrejs)
- use different gitlab token for dev environment deploy. See merge request dependabot-gitlab/dependabot!868 - (andrejs)
- include app version in docker image. See merge request dependabot-gitlab/dependabot!867 - (andrejs)
- update deployment chart. See merge request dependabot-gitlab/dependabot!866 - (andrejs)
- refactor and simplify code. See merge request dependabot-gitlab/dependabot!862 - (andrejs)
- fix local Dockerfile stage. See merge request dependabot-gitlab/dependabot!852 - (andrejs)
- move logging statement for config fetching inside cache block. See merge request dependabot-gitlab/dependabot!840 - (andrejs)
- extract docker runner definition. See merge request dependabot-gitlab/dependabot!839 - (andrejs)

### 👀 Links

[Commits since v0.7.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.7.0...v0.8.0)

## [v0.7.0 - 2021-07-25](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- remove superseeded mr branches. See merge request dependabot-gitlab/dependabot!820 - (andrejs)
- add update job retry configuration. See merge request dependabot-gitlab/dependabot!812 - (andrejs)
- save dependency update run errors. See merge request dependabot-gitlab/dependabot!808 - (andrejs)
- configuration validation rake task. See merge request dependabot-gitlab/dependabot!807 - (andrejs)
- retry on 'method not allowed' gitlab errors. See merge request dependabot-gitlab/dependabot!803 - (andrejs)

### 🐞 Bug Fixes

- do not cache registries configuration. See merge request dependabot-gitlab/dependabot!836 - (andrejs)
- use tagged logger for logging errors. See merge request dependabot-gitlab/dependabot!833 - (andrejs)
- correctly handle errors on mr creation. See merge request dependabot-gitlab/dependabot!831 - (andrejs)
- correctly fetch last run errors. See merge request dependabot-gitlab/dependabot!823 - (andrejs)
- properly raise error on github api rate limit exceeded. See merge request dependabot-gitlab/dependabot!821 - (andrejs)
- persist mrs if it was created but gitlab request failed. See merge request dependabot-gitlab/dependabot!818 - (andrejs)
- properly wrap error message in mr recreate response. See merge request dependabot-gitlab/dependabot!810 - (andrejs)

### 📦 Dependency updates

- bump yabeda-prometheus-mmap from 0.1.2 to 0.2.0. See merge request dependabot-gitlab/dependabot!822 - (andrejs)
- bump dependabot-omnibus from 0.156.8 to 0.156.9. See merge request dependabot-gitlab/dependabot!813 - (andrejs)
- bump mongoid from 7.3.0 to 7.3.1. See merge request dependabot-gitlab/dependabot!806 - (andrejs)

### 📦🛠️ Development dependency updates

- bump allure-rspec from 2.14.2 to 2.14.3. See merge request dependabot-gitlab/dependabot!835 - (andrejs)
- bump rubocop from 1.18.3 to 1.18.4. See merge request dependabot-gitlab/dependabot!830 - (andrejs)
- bump ruby version for CI runners. See merge request dependabot-gitlab/dependabot!817 - (andrejs)
- bump buildkit version. See merge request dependabot-gitlab/dependabot!809 - (andrejs)

### 🛠️ Chore

- simplify error handling for mr create. See merge request dependabot-gitlab/dependabot!826 - (andrejs)
- refactor merge request service. See merge request dependabot-gitlab/dependabot!824 - (andrejs)
- update dev redis container version. See merge request dependabot-gitlab/dependabot!825 - (andrejs)
- update ruby version in CI image. See merge request dependabot-gitlab/dependabot!816 - (andrejs)
- update redis values in helm chart. See merge request dependabot-gitlab/dependabot!804 - (andrejs)
- bump chart version. See merge request dependabot-gitlab/dependabot!802 - (andrejs)

### 📄 Documentation updates

- add supported configuration options table. See merge request dependabot-gitlab/dependabot!832 - (andrejs)

### 👀 Links

[Commits since v0.6.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.6.0...v0.7.0)

## [v0.6.0 - 2021-07-15](https://gitlab.com/dependabot-gitlab/dependabot/-/releases) *BREAKING*

## BREAKING CHANGES

Registries configuration is moved to dependabot.yml. [documentation](doc/dependabot.md#registries) file.
If registries configuration is present, option [insecure-external-code-execution](https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates#insecure-external-code-execution) has to be explicitly set to `allow` in order to allow for external code execution for certain package managers.

### 🚀 New features

- [BREAKING] implement registry configuration via dependabot.yml file. Closes #96 and #89. See merge request dependabot-gitlab/dependabot!783 - (andrejs)

### 🔬 Improvements

- add custom error message for unexpected external code error. See merge request dependabot-gitlab/dependabot!798 - (andrejs)
- add weekday option to schedule configuration. Closes #97. See merge request dependabot-gitlab/dependabot!794 - (andrejs)

### 🐞 Bug Fixes

- pass registries to file_parser. See merge request dependabot-gitlab/dependabot!797 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.156.5 to 0.156.8. See merge request dependabot-gitlab/dependabot!799 - (andrejs)

### 📦🛠️ Development dependency updates

- bump allure-rspec from 2.14.1 to 2.14.2. See merge request dependabot-gitlab/dependabot!800 - (andrejs)

### 🛠️ Chore

- bump helm chart version. See merge request dependabot-gitlab/dependabot!795 - (andrejs)

### 👀 Links

[Commits since v0.5.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.5.1...v0.6.0)

## [v0.5.1 - 2021-07-13](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🐞 Bug Fixes

- remove duplicate error message. See merge request dependabot-gitlab/dependabot!793 - (andrejs)
- update incorrect error message reply when trying to recreate up to date mr. See merge request dependabot-gitlab/dependabot!791 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.156.4 to 0.156.5. See merge request dependabot-gitlab/dependabot!784 - (andrejs)

### 📦🛠️ Development dependency updates

- bump solargraph from 0.42.3 to 0.42.4. See merge request dependabot-gitlab/dependabot!785 - (andrejs)
- bump rubocop-rails from 2.11.2 to 2.11.3. See merge request dependabot-gitlab/dependabot!782 - (andrejs)

### 🛠️ Chore

- add code quality job. See merge request dependabot-gitlab/dependabot!789 - (andrejs)
- improve ci cache. See merge request dependabot-gitlab/dependabot!787 - (andrejs)
- simplify ci ruby image. See merge request dependabot-gitlab/dependabot!788 - (andrejs)

### 👀 Links

[Commits since v0.5.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.5.0...v0.5.1)

## [v0.5.0 - 2021-07-11](https://gitlab.com/dependabot-gitlab/dependabot/-/releases) *BREAKING*

### 🔬 Improvements

- [BREAKING] check for unsupported keys in dependabot.yml. Closes #82. See merge request dependabot-gitlab/dependabot!781 - (andrejs)

### 🐞 Bug Fixes

- update handling of missing dependabot.yml config file. See merge request dependabot-gitlab/dependabot!780 - (andrejs)

### 👀 Links

[Commits since v0.4.5](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.4.5...v0.5.0)

## [v0.4.5 - 2021-07-09](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- option to override branch of dependabot.yml configuration file. See merge request dependabot-gitlab/dependabot!777 - (andrejs)
- use memory cache for standalone mode. See merge request dependabot-gitlab/dependabot!776 - (andrejs)
- remove schedule validation in dependabot.yml for standalone mode. See merge request dependabot-gitlab/dependabot!775 - (andrejs)

### 🐞 Bug Fixes

- Properly handle missing schedule key in dependabot.yml. See merge request dependabot-gitlab/dependabot!778 - (andrejs)
- deprecation warning fixes. See merge request dependabot-gitlab/dependabot!773 - (andrejs)

### 📦 Dependency updates

- bump sentry-sidekiq from 4.6.0 to 4.6.1. See merge request dependabot-gitlab/dependabot!772 - (andrejs)
- bump sentry-ruby from 4.6.0 to 4.6.1. See merge request dependabot-gitlab/dependabot!771 - (andrejs)
- bump sentry-rails from 4.6.0 to 4.6.1. See merge request dependabot-gitlab/dependabot!770 - (andrejs)
- bump sentry-sidekiq, sentry-rails and sentry-ruby. See merge request dependabot-gitlab/dependabot!761 - (andrejs)

### 📦🛠️ Development dependency updates

- bump rubocop-performance from 1.11.3 to 1.11.4. See merge request dependabot-gitlab/dependabot!765 - (andrejs)
- bump git from 1.8.1 to 1.9.1. See merge request dependabot-gitlab/dependabot!766 - (andrejs)
- update ci helm, buildkit and ruby images. See merge request dependabot-gitlab/dependabot!768 - (andrejs)
- bump rubocop from 1.18.2 to 1.18.3. See merge request dependabot-gitlab/dependabot!764 - (andrejs)
- bump rubocop-rails from 2.11.0 to 2.11.2. See merge request dependabot-gitlab/dependabot!763 - (andrejs)
- bump rubocop from 1.17.0 to 1.18.2. See merge request dependabot-gitlab/dependabot!762 - (andrejs)

### 🛠️ Chore

- tag dependabot-standalone version updates. See merge request dependabot-gitlab/dependabot!779 - (andrejs)
- Update gitlab mock ruby base image. See merge request dependabot-gitlab/dependabot!774 - (andrejs)
- add fallback to master-cache for docker builds. See merge request dependabot-gitlab/dependabot!769 - (andrejs)
- remove private infrastructure usage. See merge request dependabot-gitlab/dependabot!767 - (andrejs)

### 👀 Links

[Commits since v0.4.4](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.4.4...v0.4.5)

## [v0.4.4 - 2021-07-02](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- add env MONGODB_RETRY_WRITES to allow disable retryWrites. See merge request dependabot-gitlab/dependabot!754 - (dgropelo)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.154.1 to 0.154.3. See merge request dependabot-gitlab/dependabot!736 - (andrejs)
- bump dependabot-omnibus from 0.154.0 to 0.154.1. See merge request dependabot-gitlab/dependabot!732 - (andrejs)
- bump dependabot-omnibus from 0.152.1 to 0.154.0. See merge request dependabot-gitlab/dependabot!729 - (andrejs)
- bump dependabot-omnibus from 0.152.0 to 0.152.1. See merge request dependabot-gitlab/dependabot!720 - (andrejs)

### 📦🛠️ Development dependency updates

- bump debian from 10.9-slim to 10.10-slim in /.gitlab/ci. See merge request dependabot-gitlab/dependabot!741 - (andrejs)
- bump rubocop-rails from 2.10.1 to 2.11.0. See merge request dependabot-gitlab/dependabot!737 - (andrejs)
- bump rubocop from 1.16.1 to 1.17.0. See merge request dependabot-gitlab/dependabot!730 - (andrejs)
- bump solargraph from 0.42.1 to 0.42.3. See merge request dependabot-gitlab/dependabot!727 - (andrejs)
- bump allure-rspec from 2.14.0 to 2.14.1. See merge request dependabot-gitlab/dependabot!721 - (andrejs)
- bump solargraph from 0.41.2 to 0.42.1. See merge request dependabot-gitlab/dependabot!722 - (andrejs)

### 👀 Links

[Commits since v0.4.3](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.4.3...v0.4.4)

## [v0.4.3 - 2021-06-10](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🐞 Bug Fixes

- explicitly indicate closed mr existance. Closes #94. See merge request dependabot-gitlab/dependabot!704 - (andrejs)
- (docker) Redis container volume. Closes #91. See merge request dependabot-gitlab/dependabot!700 - (marek.moscichowski1)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.151.1 to 0.152.0. See merge request dependabot-gitlab/dependabot!717 - (andrejs)
- bump dependabot-omnibus from 0.150.0 to 0.151.1. See merge request dependabot-gitlab/dependabot!713 - (andrejs)
- bump dependabot-omnibus from 0.149.5 to 0.150.0. See merge request dependabot-gitlab/dependabot!711 - (andrejs)
- bump sentry-sidekiq from 4.5.0 to 4.5.1. See merge request dependabot-gitlab/dependabot!710 - (andrejs)
- bump sentry-ruby from 4.5.0 to 4.5.1. See merge request dependabot-gitlab/dependabot!709 - (andrejs)
- bump sentry-rails from 4.5.0 to 4.5.1. See merge request dependabot-gitlab/dependabot!708 - (andrejs)
- bump dependabot-omnibus from 0.149.4 to 0.149.5. See merge request dependabot-gitlab/dependabot!706 - (andrejs)
- bump dependabot-omnibus from 0.149.3 to 0.149.4. See merge request dependabot-gitlab/dependabot!701 - (andrejs)
- bump dependabot-omnibus from 0.149.2 to 0.149.3. See merge request dependabot-gitlab/dependabot!697 - (andrejs)

### 📦🛠️ Development dependency updates

- bump rubocop-rspec from 2.3.0 to 2.4.0. See merge request dependabot-gitlab/dependabot!718 - (andrejs)
- bump rubocop from 1.16.0 to 1.16.1. See merge request dependabot-gitlab/dependabot!715 - (andrejs)
- bump solargraph from 0.41.1 to 0.41.2. See merge request dependabot-gitlab/dependabot!716 - (andrejs)
- bump codacy-coverage-reporter to 12.1.7. See merge request dependabot-gitlab/dependabot!705 - (andrejs)
- bump rubocop from 1.15.0 to 1.16.0. See merge request dependabot-gitlab/dependabot!702 - (andrejs)
- bump solargraph from 0.40.4 to 0.41.1. See merge request dependabot-gitlab/dependabot!699 - (andrejs)

### 👀 Links

[Commits since v0.4.2](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.4.2...v0.4.3)

## [v0.4.2 - 2021-05-27](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 📦 Dependency updates

- bump bundler version and deps. See merge request dependabot-gitlab/dependabot!695 - (andrejs)
- bump dependabot-omnibus from 0.148.10 to 0.149.2. See merge request dependabot-gitlab/dependabot!690 - (andrejs)
- bump sentry-ruby, sentry-rails and sentry-sidekiq. See merge request dependabot-gitlab/dependabot!692 - (andrejs)
- bump dependabot-omnibus from 0.148.6 to 0.148.10. See merge request dependabot-gitlab/dependabot!686 - (andrejs)
- bump puma from 5.3.1 to 5.3.2. See merge request dependabot-gitlab/dependabot!683 - (andrejs)

### 📦🛠️ Development dependency updates

- update allure-report-publisher. See merge request dependabot-gitlab/dependabot!689 - (andrejs)
- bump allure-rspec from 2.13.10 to 2.14.0. See merge request dependabot-gitlab/dependabot!687 - (andrejs)

### 👀 Links

[Commits since v0.4.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.4.1...v0.4.2)

## [v0.4.1 - 2021-05-21](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🐞 Bug Fixes

- Additionally filter gitlab user search results. Closes #86. See merge request dependabot-gitlab/dependabot!682 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.148.3 to 0.148.6. See merge request dependabot-gitlab/dependabot!679 - (andrejs)
- bump dependabot-omnibus from 0.148.2 to 0.148.3. See merge request dependabot-gitlab/dependabot!677 - (andrejs)
- bump dependabot-omnibus from 0.147.0 to 0.148.2. See merge request dependabot-gitlab/dependabot!673 - (andrejs)

### 📦🛠️ Development dependency updates

- Bump allure-report-publisher to 0.2.1. See merge request dependabot-gitlab/dependabot!681 - (andrejs)
- bump allure-rspec from 2.13.9 to 2.13.10. See merge request dependabot-gitlab/dependabot!674 - (andrejs)

### 🛠️ Chore

- Update allure report publisher. See merge request dependabot-gitlab/dependabot!676 - (andrejs)

### 👀 Links

[Commits since v0.4.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.4.0...v0.4.1)

## [v0.4.0 - 2021-05-18](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- log error stacktrace to debug level. See merge request dependabot-gitlab/dependabot!670 - (andrejs)
- Add configurable commands prefix. Closes #81. See merge request dependabot-gitlab/dependabot!646 - (andrejs)

### 📦 Dependency updates

- bump rails-healthcheck from 1.3.0 to 1.4.0. See merge request dependabot-gitlab/dependabot!671 - (andrejs)
- bump dependabot-omnibus from 0.146.1 to 0.147.0. See merge request dependabot-gitlab/dependabot!665 - (andrejs)
- bump dependabot-omnibus from 0.146.0 to 0.146.1. See merge request dependabot-gitlab/dependabot!661 - (andrejs)
- bump yabeda-sidekiq from 0.7.0 to 0.8.0. See merge request dependabot-gitlab/dependabot!659 - (andrejs)
- bump puma from 5.3.0 to 5.3.1. See merge request dependabot-gitlab/dependabot!656 - (andrejs)
- bump sentry-ruby from 4.4.1 to 4.4.2. See merge request dependabot-gitlab/dependabot!657 - (andrejs)
- bump dependabot-omnibus from 0.145.3 to 0.146.0. See merge request dependabot-gitlab/dependabot!655 - (andrejs)
- bump mongoid from 7.2.2 to 7.3.0. See merge request dependabot-gitlab/dependabot!653 - (andrejs)
- bump dependabot-omnibus from 0.145.2 to 0.145.3. See merge request dependabot-gitlab/dependabot!651 - (andrejs)
- bump dependabot-omnibus from 0.145.1 to 0.145.2. See merge request dependabot-gitlab/dependabot!647 - (andrejs)
- bump puma from 5.2.2 to 5.3.0. See merge request dependabot-gitlab/dependabot!648 - (andrejs)
- bump dependabot-omnibus from 0.144.0 to 0.145.1. See merge request dependabot-gitlab/dependabot!642 - (andrejs)
- bump rails from 6.1.3.1 to 6.1.3.2. See merge request dependabot-gitlab/dependabot!636 - (andrejs)
- bump dependabot-omnibus from 0.143.6 to 0.144.0. See merge request dependabot-gitlab/dependabot!635 - (andrejs)
- bump sentry-ruby from 4.4.0 to 4.4.1. See merge request dependabot-gitlab/dependabot!637 - (andrejs)
- bump bootsnap from 1.7.4 to 1.7.5. See merge request dependabot-gitlab/dependabot!631 - (andrejs)
- bump sentry-sidekiq, sentry-rails and sentry-ruby. See merge request dependabot-gitlab/dependabot!634 - (andrejs)
- bump dependabot-omnibus from 0.143.5 to 0.143.6. See merge request dependabot-gitlab/dependabot!626 - (andrejs)
- bump dependabot-omnibus from 0.143.4 to 0.143.5. See merge request dependabot-gitlab/dependabot!624 - (andrejs)
- bump dependabot-omnibus from 0.143.3 to 0.143.4. See merge request dependabot-gitlab/dependabot!621 - (andrejs)

### 📦🛠️ Development dependency updates

- bump rubocop from 1.14.0 to 1.15.0. See merge request dependabot-gitlab/dependabot!672 - (andrejs)
- bump webmock from 3.12.2 to 3.13.0. See merge request dependabot-gitlab/dependabot!666 - (andrejs)
- bump faker from 2.17.0 to 2.18.0. See merge request dependabot-gitlab/dependabot!668 - (andrejs)
- bump rubocop-performance from 1.11.2 to 1.11.3. See merge request dependabot-gitlab/dependabot!643 - (andrejs)
- bump rubocop-rails from 2.9.1 to 2.10.1. See merge request dependabot-gitlab/dependabot!644 - (andrejs)
- bump rubocop-performance from 1.11.1 to 1.11.2. See merge request dependabot-gitlab/dependabot!639 - (andrejs)
- bump rubocop from 1.13.0 to 1.14.0. See merge request dependabot-gitlab/dependabot!638 - (andrejs)
- bump rubocop-performance from 1.11.0 to 1.11.1. See merge request dependabot-gitlab/dependabot!627 - (andrejs)
- bump reek from 6.0.3 to 6.0.4. See merge request dependabot-gitlab/dependabot!622 - (andrejs)
- bump rubocop-rspec from 2.2.0 to 2.3.0. See merge request dependabot-gitlab/dependabot!623 - (andrejs)

### 🛠️ Chore

- upload reports to gcs. See merge request dependabot-gitlab/dependabot!664 - (andrejs)
- Update chart version and commands prefix. See merge request dependabot-gitlab/dependabot!650 - (andrejs)
- keep latest allure report for specific branch pipeline. See merge request dependabot-gitlab/dependabot!640 - (andrejs)
- add allure links to mr descriptions. See merge request dependabot-gitlab/dependabot!630 - (andrejs)
- add allure report publisher job. See merge request dependabot-gitlab/dependabot!629 - (andrejs)
- fix regex for current version detection in dependabot-standalone. See merge request dependabot-gitlab/dependabot!619 - (andrejs)

### 📄 Documentation updates

- add explicit links to dependabot.yml configuration options. See merge request dependabot-gitlab/dependabot!663 - (andrejs)
- add table of contents and improve docs. See merge request dependabot-gitlab/dependabot!660 - (andrejs)

### 👀 Links

[Commits since v0.3.10](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.10...v0.4.0)

## [v0.3.10 - 2021-04-24](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- trigger automerge based on pipeline events. Closes #76. See merge request dependabot-gitlab/dependabot!600 - (andrejs)

### 🐞 Bug Fixes

- skip update when merge request has no conflict. Closes #79. See merge request dependabot-gitlab/dependabot!616 - (@manandre)
- forked project pipeline fix. See merge request dependabot-gitlab/dependabot!618 - (andrejs)
- skip automerge when merge_status is explicitly cannot_be_merged. See merge request dependabot-gitlab/dependabot!607 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.143.1 to 0.143.3. See merge request dependabot-gitlab/dependabot!614 - (andrejs)
- bump dependabot-omnibus from 0.142.1 to 0.143.1. See merge request dependabot-gitlab/dependabot!610 - (andrejs)
- bump bootsnap from 1.7.3 to 1.7.4. See merge request dependabot-gitlab/dependabot!609 - (andrejs)
- bump dependabot-omnibus from 0.142.0 to 0.142.1. See merge request dependabot-gitlab/dependabot!603 - (andrejs)
- bump dependabot-omnibus from 0.141.1 to 0.142.0. See merge request dependabot-gitlab/dependabot!597 - (andrejs)
- bump dependabot-omnibus from 0.141.0 to 0.141.1. See merge request dependabot-gitlab/dependabot!593 - (andrejs)
- bump mongoid from 7.2.1 to 7.2.2. See merge request dependabot-gitlab/dependabot!594 - (andrejs)

### 📦🛠️ Development dependency updates

- bump rubocop-performance from 1.10.2 to 1.11.0. See merge request dependabot-gitlab/dependabot!611 - (andrejs)
- bump rubocop from 1.12.1 to 1.13.0. See merge request dependabot-gitlab/dependabot!608 - (andrejs)
- bump allure-rspec from 2.13.8.5 to 2.13.9. See merge request dependabot-gitlab/dependabot!598 - (andrejs)

### 🛠️ Chore

- remove Config class and Configuration module. See merge request dependabot-gitlab/dependabot!613 - (andrejs)
- remove version from initial log message on dependency info fetching. See merge request dependabot-gitlab/dependabot!604 - (andrejs)
- rename development improvements to more general chore. See merge request dependabot-gitlab/dependabot!602 - (andrejs)
- Improve project queries. See merge request dependabot-gitlab/dependabot!601 - (andrejs)
- update dependabot-standalone gitlab-ci.yml with explicit image version on release. See merge request dependabot-gitlab/dependabot!596 - (andrejs)

### 👀 Links

[Commits since v0.3.9](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.9...v0.3.10)

## [v0.3.9 - 2021-04-14](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🐞 Bug Fixes

- Allow maven repo configuration with just the url. Closes #69. See merge request dependabot-gitlab/dependabot!592 - (andrejs)

### 🛠️ Development improvements

- bump chart version. See merge request dependabot-gitlab/dependabot!589 - (andrejs)

### 📄 Documentation updates

- extract documentation for manual configuration and specific dependabot.yml config options. See merge request dependabot-gitlab/dependabot!591 - (andrejs)
- add description for using gitlab package registries for maven repositories. See merge request dependabot-gitlab/dependabot!590 - (andrejs)

### 👀 Links

[Commits since v0.3.8](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.8...v0.3.9)

## [v0.3.8 - 2021-04-13](https://gitlab.com/dependabot-gitlab/dependabot/-/releases) *BREAKING*

### 🔬 Improvements

- [BREAKING] change application user and application path in docker image. See merge request dependabot-gitlab/dependabot!588 - (andrejs)
- save webhook id if project has been removed in local database but not on Gitlab. See merge request dependabot-gitlab/dependabot!587 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.140.3 to 0.141.0. See merge request dependabot-gitlab/dependabot!585 - (andrejs)
- bump dependabot-omnibus from 0.140.2 to 0.140.3. See merge request dependabot-gitlab/dependabot!583 - (andrejs)

### 🛠️ Development improvements

- bump chart version. See merge request dependabot-gitlab/dependabot!589 - (andrejs)

### 👀 Links

[Commits since v0.3.7](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.7...v0.3.8)

## [v0.3.7 - 2021-04-11](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New features

- add status notifications of recreate action. See merge request dependabot-gitlab/dependabot!579 - (andrejs)
- add rebase action progress reply. See merge request dependabot-gitlab/dependabot!578 - (andrejs)

### 🐞 Bug Fixes

- add sidekiq hooks queue. See merge request dependabot-gitlab/dependabot!580 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.140.1 to 0.140.2. See merge request dependabot-gitlab/dependabot!575 - (andrejs)

### 📦 Development dependency updates

- bump chart version. See merge request dependabot-gitlab/dependabot!577 - (andrejs)

### 🛠️ Development improvements

- add manual prod deploy option when triggering from web. See merge request dependabot-gitlab/dependabot!582 - (andrejs)
- add stricter rules for master pipeline trigger. See merge request dependabot-gitlab/dependabot!581 - (andrejs)
- deploy app on tag push. See merge request dependabot-gitlab/dependabot!574 - (andrejs)

### 👀 Links

[Commits since v0.3.6](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.6...v0.3.7)

## [v0.3.6 - 2021-04-09](https://gitlab.com/dependabot-gitlab/dependabot/-/releases) *BREAKING*

### 🚀 New features

- add support for vendor option. See merge request dependabot-gitlab/dependabot!539 - (andrejs)

### 🔬 Improvements

- [BREAKING] validate arguments passed to update service. See merge request dependabot-gitlab/dependabot!561 - (andrejs)
- clean cloned repo once updates ha finished. See merge request dependabot-gitlab/dependabot!550 - (andrejs)

### 🐞 Bug Fixes

- synchronize fetching files and updating dependencies on mr recreation. See merge request dependabot-gitlab/dependabot!551 - (andrejs)
- create unique repo content path. See merge request dependabot-gitlab/dependabot!546 - (andrejs)
- pass repo_contents_path to file updater. See merge request dependabot-gitlab/dependabot!544 - (andrejs)
- remove unnecessary components from repo path. See merge request dependabot-gitlab/dependabot!540 - (andrejs)

### 📦 Dependency updates

- bump sidekiq from 6.2.0 to 6.2.1. See merge request dependabot-gitlab/dependabot!568 - (andrejs)
- bump dependabot-omnibus from 0.139.2 to 0.140.1. See merge request dependabot-gitlab/dependabot!567 - (andrejs)
- bump sentry-ruby from 4.3.1 to 4.3.2. See merge request dependabot-gitlab/dependabot!559 - (andrejs)
- bump dependabot-omnibus from 0.139.1 to 0.139.2. See merge request dependabot-gitlab/dependabot!555 - (andrejs)
- bump sentry-rails from 4.3.3 to 4.3.4. See merge request dependabot-gitlab/dependabot!556 - (andrejs)
- bump dependabot-omnibus from 0.139.0 to 0.139.1. See merge request dependabot-gitlab/dependabot!547 - (andrejs)
- bump rails-healthcheck from 1.2.0 to 1.3.0. See merge request dependabot-gitlab/dependabot!548 - (andrejs)
- bump dependabot-omnibus from 0.138.6 to 0.139.0. See merge request dependabot-gitlab/dependabot!541 - (andrejs)
- bump dependabot-omnibus from 0.138.5 to 0.138.6. See merge request dependabot-gitlab/dependabot!537 - (andrejs)
- bump rails from 6.1.3 to 6.1.3.1. See merge request dependabot-gitlab/dependabot!530 - (andrejs)

### 📦 Development dependency updates

- update ruby to 2.6.7 and bundler to 2.2.15. See merge request dependabot-gitlab/dependabot!562 - (andrejs)
- bump andrcuns/ruby from 2.6.6-slim-10.8.6 to 2.6.6-slim-10.9 in /spec/fixture/gitlab. See merge request dependabot-gitlab/dependabot!554 - (andrejs)
- bump rubocop from 1.12.0 to 1.12.1. See merge request dependabot-gitlab/dependabot!553 - (andrejs)
- bump andrcuns/ruby from 2.6.6-slim-10.8.5 to 2.6.6-slim-10.8.6 in /spec/fixture/gitlab. See merge request dependabot-gitlab/dependabot!536 - (andrejs)
- bump andrcuns/ruby from 2.6.6-slim-10.8.1 to 2.6.6-slim-10.8.5 in /spec/fixture/gitlab. See merge request dependabot-gitlab/dependabot!529 - (andrejs)

### 🛠️ Development improvements

- add autoupdates for ruby base image. See merge request dependabot-gitlab/dependabot!573 - (andrejs)
- use ruby base built in dependabot repo. See merge request dependabot-gitlab/dependabot!571 - (andrejs)
- pin package versions. See merge request dependabot-gitlab/dependabot!572 - (andrejs)
- fix tag name for ruby image. See merge request dependabot-gitlab/dependabot!569 - (andrejs)
- build ruby base image for ci and mock. See merge request dependabot-gitlab/dependabot!565 - (andrejs)
- update base ci ruby image. See merge request dependabot-gitlab/dependabot!563 - (andrejs)
- move services to Dependabot module. See merge request dependabot-gitlab/dependabot!560 - (andrejs)
- replace sentry-raven with sentry-ruby. Closes #72. See merge request dependabot-gitlab/dependabot!552 - (andrejs)
- remove custom cs major version. See merge request dependabot-gitlab/dependabot!545 - (andrejs)
- format log messages for better readability. See merge request dependabot-gitlab/dependabot!535 - (andrejs)
- remove unused brakeman.ignore. See merge request dependabot-gitlab/dependabot!534 - (andrejs)
- add specific file list for production deployments. See merge request dependabot-gitlab/dependabot!533 - (andrejs)
- organize similar function classes in to modules. See merge request dependabot-gitlab/dependabot!532 - (andrejs)
- add default expiry for redis cache. See merge request dependabot-gitlab/dependabot!531 - (andrejs)
- update ci ruby image. See merge request dependabot-gitlab/dependabot!528 - (andrejs)

### 👀 Links

[Commits since v0.3.5](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.5...v0.3.6)

## [v0.3.5 - 2021-03-27](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### ⚠️ Security updates

- bump kramdown from 2.3.0 to 2.3.1. Closes #70. See merge request dependabot-gitlab/dependabot!526 - (andrejs)

### 🛠️ Development improvements

- changelog improvements. See merge request dependabot-gitlab/dependabot!527 - (andrejs)
- add security updates changelog entry. See merge request dependabot-gitlab/dependabot!525 - (andrejs)
- fix container scanner. See merge request dependabot-gitlab/dependabot!524 - (andrejs)

### 👀 Links

[Commits since v0.3.4](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.4...v0.3.5)

## [v0.3.4 - 2021-03-26](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New features

- add merge request recreate command. Closes #39. See merge request dependabot-gitlab/dependabot!507 - (andrejs)

### 🔬 Improvements

- report cache errors, adjust cache expiry. See merge request dependabot-gitlab/dependabot!512 - (andrejs)
- add recreate command description to merge requests. See merge request dependabot-gitlab/dependabot!510 - (andrejs)

### 🐞 Bug Fixes

- do not perform recreate command synchronously. See merge request dependabot-gitlab/dependabot!517 - (andrejs)
- add missing redis password for cache store. Closes #58. See merge request dependabot-gitlab/dependabot!513 - (andrejs)
- correctly handle dependency updates. See merge request dependabot-gitlab/dependabot!499 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.138.3 to 0.138.5. See merge request dependabot-gitlab/dependabot!520 - (andrejs)
- bump mimemagic to 0.3.10. See merge request dependabot-gitlab/dependabot!522 - (andrejs)
- bump dependabot-omnibus from 0.138.2 to 0.138.3. See merge request dependabot-gitlab/dependabot!515 - (andrejs)
- bump dependabot-omnibus from 0.138.1 to 0.138.2. See merge request dependabot-gitlab/dependabot!508 - (andrejs)
- bump bootsnap from 1.7.2 to 1.7.3. See merge request dependabot-gitlab/dependabot!505 - (andrejs)

### 📦 Development dependency updates

- bump webmock from 3.12.1 to 3.12.2. See merge request dependabot-gitlab/dependabot!521 - (andrejs)
- bump rubocop from 1.11.0 to 1.12.0. See merge request dependabot-gitlab/dependabot!516 - (andrejs)
- bump rubocop-performance from 1.10.1 to 1.10.2. See merge request dependabot-gitlab/dependabot!506 - (andrejs)
- update base ruby image. See merge request dependabot-gitlab/dependabot!502 - (andrejs)
- bump rspec-rails from 5.0.0 to 5.0.1. See merge request dependabot-gitlab/dependabot!494 - (andrejs)

### 🛠️ Development improvements

- prevent parallel deployments to production. See merge request dependabot-gitlab/dependabot!511 - (andrejs)
- add directory to merge request model. See merge request dependabot-gitlab/dependabot!504 - (andrejs)
- refactor dependency updater. See merge request dependabot-gitlab/dependabot!503 - (andrejs)
- testing improvements. See merge request dependabot-gitlab/dependabot!501 - (andrejs)
- move compose files back to root. See merge request dependabot-gitlab/dependabot!500 - (andrejs)
- split dependency update logic, add main dependecy name to mr db entry. See merge request dependabot-gitlab/dependabot!498 - (andrejs)
- add development environment deployment. See merge request dependabot-gitlab/dependabot!497 - (andrejs)
- update favicon. See merge request dependabot-gitlab/dependabot!496 - (andrejs)
- update load balancer settings. See merge request dependabot-gitlab/dependabot!495 - (andrejs)
- digital-ocean deployment. See merge request dependabot-gitlab/dependabot!493 - (andrejs)

### 👀 Links

[Commits since v0.3.3](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.3...v0.3.4)

## [v0.3.3 - 2021-03-17](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- change no content response to accepted for requests not performing any action. See merge request dependabot-gitlab/dependabot!490 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.137.2 to 0.138.1. See merge request dependabot-gitlab/dependabot!492 - (andrejs)
- bump sidekiq from 6.1.3 to 6.2.0. See merge request dependabot-gitlab/dependabot!489 - (andrejs)
- bump dependabot-omnibus from 0.137.1 to 0.137.2. See merge request dependabot-gitlab/dependabot!488 - (andrejs)

### 👀 Links

[Commits since v0.3.2](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.2...v0.3.3)

## [v0.3.2 - 2021-03-15](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.136.0 to 0.137.1. See merge request dependabot-gitlab/dependabot!485 - (andrejs)

### 📦 Development dependency updates

- bump faker from 2.16.0 to 2.17.0. See merge request dependabot-gitlab/dependabot!484 - (andrejs)

### 📄 Documentation updates

- document adding 'Comments' webhook. See merge request dependabot-gitlab/dependabot!486 - (andrejs)
- remove dependabot logo, add disclaimer. See merge request dependabot-gitlab/dependabot!483 - (andrejs)

### 👀 Links

[Commits since v0.3.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.1...v0.3.2)

## [v0.3.1 - 2021-03-09](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🛠️ Development improvements

- fix docker release runner. See merge request dependabot-gitlab/dependabot!482 - (andrejs)

### 👀 Links

[Commits since v0.3.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.3.0...v0.3.1)

## [v0.3.0 - 2021-03-09](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New features

- rebase merge request command. Closes #5. See merge request dependabot-gitlab/dependabot!476 - (andrejs)

### 🔬 Improvements

- dont add mr footer for standalone app. See merge request dependabot-gitlab/dependabot!481 - (andrejs)
- add proper spacing to pr message footer. See merge request dependabot-gitlab/dependabot!478 - (andrejs)
- dependabot command description in mr footer. See merge request dependabot-gitlab/dependabot!477 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.135.0 to 0.136.0. See merge request dependabot-gitlab/dependabot!475 - (andrejs)
- bump dependabot-omnibus from 0.134.1 to 0.135.0. See merge request dependabot-gitlab/dependabot!469 - (andrejs)
- bump semantic_range from 2.3.1 to 3.0.0. See merge request dependabot-gitlab/dependabot!467 - (andrejs)
- bump dependabot-omnibus from 0.134.1 to 0.134.2. See merge request dependabot-gitlab/dependabot!462 - (andrejs)
- bump puma from 5.2.1 to 5.2.2. See merge request dependabot-gitlab/dependabot!459 - (andrejs)
- bump dependabot-omnibus from 0.133.6 to 0.134.1. See merge request dependabot-gitlab/dependabot!458 - (andrejs)

### 📦 Development dependency updates

- bump rspec-rails from 4.1.0 to 5.0.0. See merge request dependabot-gitlab/dependabot!480 - (andrejs)
- bump buildkit and docker ci runner versions. See merge request dependabot-gitlab/dependabot!472 - (andrejs)
- bump rspec-rails from 4.0.2 to 4.1.0. See merge request dependabot-gitlab/dependabot!470 - (andrejs)
- bump webmock from 3.12.0 to 3.12.1. See merge request dependabot-gitlab/dependabot!471 - (andrejs)
- bump solargraph from 0.40.3 to 0.40.4. See merge request dependabot-gitlab/dependabot!463 - (andrejs)
- bump rubocop-performance from 1.10.0 to 1.10.1. See merge request dependabot-gitlab/dependabot!460 - (andrejs)
- bump rubocop-performance from 1.9.2 to 1.10.0. See merge request dependabot-gitlab/dependabot!456 - (andrejs)
- bump rubocop from 1.10.0 to 1.11.0. See merge request dependabot-gitlab/dependabot!455 - (andrejs)

### 🛠️ Development improvements

- properly bump minor and major version. See merge request dependabot-gitlab/dependabot!479 - (andrejs)
- Remove plain exec git operations. Closes #62. See merge request dependabot-gitlab/dependabot!461 - (andrejs)
- automatically update helm chart on release. Closes #61. See merge request dependabot-gitlab/dependabot!454 - (andrejs)

### 📄 Documentation updates

- improve readme structure. See merge request dependabot-gitlab/dependabot!473 - (andrejs)
- documentation improvements. See merge request dependabot-gitlab/dependabot!465 - (andrejs)

### 👀 Links

[Commits since v0.2.16](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.16...v0.3.0)

## [v0.2.16 - 2021-02-28](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- Retry gitlab requests for certain errors. See merge request dependabot-gitlab/dependabot!438 - (Andrejs)
- retry auto-merge requests. See merge request dependabot-gitlab/dependabot!440 - (Andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.133.3 to 0.133.5. See merge request dependabot-gitlab/dependabot!439 - (Andrejs)
- bump dependabot-omnibus from 0.133.5 to 0.133.6. See merge request dependabot-gitlab/dependabot!444 - (Andrejs)
- bump rails and mongoid. See merge request dependabot-gitlab/dependabot!447 - (Andrejs)

### 📦 Development dependency updates

- bump webmock from 3.11.2 to 3.11.3. See merge request dependabot-gitlab/dependabot!451 - (Andrejs)
- bump webmock from 3.11.3 to 3.12.0. See merge request dependabot-gitlab/dependabot!452 - (Andrejs)

### 🛠️ Development improvements

- updated mocked responses for e2e tests. See merge request dependabot-gitlab/dependabot!442 - (Andrejs)
- Add dependency scanning. See merge request dependabot-gitlab/dependabot!445 - (Andrejs)
- Replace brakeman with gitlab brakeman-sast job. See merge request dependabot-gitlab/dependabot!448 - (Andrejs)
- Add container scanner. See merge request dependabot-gitlab/dependabot!449 - (Andrejs)
- Adjust scanner job rules, rename jobs. See merge request dependabot-gitlab/dependabot!450 - (Andrejs)
- Add prepare-message git hook. See merge request dependabot-gitlab/dependabot!453 - (Andrejs)

### 👀 Links

[Commits since v0.2.15](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.15...v0.2.16)

## [v0.2.15 - 2021-02-16](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- synchronize operations on package ecosystem level. See merge request dependabot-gitlab/dependabot!434 - (Andrejs)

### 🐞 Bug Fixes

- remove potential nil values from existing mr list. Closes #55. See merge request dependabot-gitlab/dependabot!433 - (Andrejs)
- Handle missing has_conflicts field. Closes #53. See merge request dependabot-gitlab/dependabot!401 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.133.2 to 0.133.3. See merge request dependabot-gitlab/dependabot!436 - (Andrejs)
- bump rubocop from 1.9.1 to 1.10.0. See merge request dependabot-gitlab/dependabot!435 - (Andrejs)
- bump dependabot-omnibus from 0.132.0 to 0.133.2. See merge request dependabot-gitlab/dependabot!431 - (Andrejs)
- bump rails from 6.0.3.4 to 6.0.3.5. See merge request dependabot-gitlab/dependabot!432 - (Andrejs)
- bump faker from 2.15.1 to 2.16.0. See merge request dependabot-gitlab/dependabot!429 - (Andrejs)
- update base ruby image for mock and ci. See merge request dependabot-gitlab/dependabot!426 - (Andrejs)
- bump bootsnap from 1.7.1 to 1.7.2. See merge request dependabot-gitlab/dependabot!424 - (Andrejs)
- bump dependabot-omnibus from 0.131.2 to 0.132.0. See merge request dependabot-gitlab/dependabot!425 - (Andrejs)
- bump yabeda-puma-plugin from 0.5.0 to 0.6.0. See merge request dependabot-gitlab/dependabot!420 - (Andrejs)
- bump puma from 5.2.0 to 5.2.1. See merge request dependabot-gitlab/dependabot!421 - (Andrejs)
- bump solargraph from 0.40.2 to 0.40.3. See merge request dependabot-gitlab/dependabot!422 - (Andrejs)
- bump dependabot-omnibus from 0.131.0 to 0.131.2. See merge request dependabot-gitlab/dependabot!419 - (Andrejs)
- bump dependabot-omnibus from 0.130.3 to 0.131.0. See merge request dependabot-gitlab/dependabot!417 - (Andrejs)
- bump bootsnap from 1.7.0 to 1.7.1. See merge request dependabot-gitlab/dependabot!416 - (Andrejs)
- bump rubocop-rspec from 2.1.0 to 2.2.0. See merge request dependabot-gitlab/dependabot!413 - (andrejs)
- bump webmock from 3.11.1 to 3.11.2. See merge request dependabot-gitlab/dependabot!412 - (andrejs)
- bump simplecov-console from 0.8.0 to 0.9.1. See merge request dependabot-gitlab/dependabot!411 - (andrejs)
- bump rubocop from 1.9.0 to 1.9.1. See merge request dependabot-gitlab/dependabot!409 - (andrejs)
- bump brakeman from 4.10.1 to 5.0.0. See merge request dependabot-gitlab/dependabot!410 - (andrejs)
- bump bootsnap from 1.6.0 to 1.7.0. See merge request dependabot-gitlab/dependabot!408 - (andrejs)
- bump sidekiq from 6.1.2 to 6.1.3. See merge request dependabot-gitlab/dependabot!406 - (andrejs)
- bump bootsnap from 1.5.1 to 1.6.0. See merge request dependabot-gitlab/dependabot!403 - (andrejs)
- bump puma from 5.1.1 to 5.2.0. See merge request dependabot-gitlab/dependabot!405 - (andrejs)
- bump reek, rubocop, solargraph and dependabot-omnibus. See merge request dependabot-gitlab/dependabot!407 - (andrejs)
- bump dependabot-omnibus from 0.130.0 to 0.130.1. See merge request dependabot-gitlab/dependabot!400 - (andrejs)
- bump dependabot-omnibus from 0.129.5 to 0.130.0. See merge request dependabot-gitlab/dependabot!397 - (andrejs)
- bump webmock from 3.11.0 to 3.11.1. See merge request dependabot-gitlab/dependabot!398 - (andrejs)
- bump simplecov from 0.21.1 to 0.21.2. See merge request dependabot-gitlab/dependabot!395 - (andrejs)
- bump dependabot-omnibus from 0.129.3 to 0.129.5. See merge request dependabot-gitlab/dependabot!394 - (andrejs)
- bump dependabot-omnibus from 0.129.2 to 0.129.3. See merge request dependabot-gitlab/dependabot!391 - (andrejs)
- bump simplecov from 0.21.0 to 0.21.1. See merge request dependabot-gitlab/dependabot!392 - (andrejs)

### 👀 Links

[Commits since v0.2.14](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.14...v0.2.15)

## [v0.2.14 - 2021-01-05](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- handle incorrect usernames. See merge request dependabot-gitlab/dependabot!389 - (andrejs)

### 🐞 Bug Fixes

- don't pass approvers if not defined in .dependabot.yml configuration. Closes #51. See merge request dependabot-gitlab/dependabot!386 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.129.1 to 0.129.2. See merge request dependabot-gitlab/dependabot!388 - (andrejs)

### 👀 Links

[Commits since v0.2.13](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.13...v0.2.14)

## [v0.2.13 - 2021-01-04](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New Features

- prometheus metrics. Closes #43. See merge request dependabot-gitlab/dependabot!375 - (andrejs)

### 🐞 Bug Fixes

- fix incorrect variable name in error message. Closes #50. See merge request dependabot-gitlab/dependabot!385 - (andrejs)

### 📦 Dependency updates

- bump simplecov from 0.20.0 to 0.21.0. See merge request dependabot-gitlab/dependabot!384 - (andrejs)
- bump rubocop-performance from 1.9.1 to 1.9.2. See merge request dependabot-gitlab/dependabot!383 - (andrejs)
- bump anyway_config from 2.0.6 to 2.1.0. See merge request dependabot-gitlab/dependabot!382 - (andrejs)
- bump solargraph from 0.40.0 to 0.40.1. See merge request dependabot-gitlab/dependabot!381 - (andrejs)
- bump rspec-rails from 4.0.1 to 4.0.2. See merge request dependabot-gitlab/dependabot!380 - (andrejs)
- bump brakeman from 4.10.0 to 4.10.1. See merge request dependabot-gitlab/dependabot!379 - (andrejs)
- bump rubocop from 1.6.1 to 1.7.0. See merge request dependabot-gitlab/dependabot!378 - (andrejs)
- bump dependabot-omnibus from 0.129.0 to 0.129.1. See merge request dependabot-gitlab/dependabot!377 - (andrejs)
- bump webmock from 3.10.0 to 3.11.0. See merge request dependabot-gitlab/dependabot!374 - (andrejs)
- bump rubocop-rspec from 2.0.1 to 2.1.0. See merge request dependabot-gitlab/dependabot!373 - (andrejs)

### 👀 Links

[Commits since v0.2.12](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.12...v0.2.13)

## [v0.2.12 - 2020-12-17](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- logging improvements follow up. See merge request dependabot-gitlab/dependabot!371 - (andrejs)
- add tagged logger messages. See merge request dependabot-gitlab/dependabot!368 - (andrejs)

### 🐞 Bug Fixes

- do not try to close previous mr if new one was not created. See merge request dependabot-gitlab/dependabot!370 - (andrejs)

### 📦 Dependency updates

- bump rubocop and rubocop-rspec. See merge request dependabot-gitlab/dependabot!366 - (andrejs)
- bump rubocop-rails from 2.9.0 to 2.9.1. See merge request dependabot-gitlab/dependabot!369 - (andrejs)
- bump dependabot-omnibus from 0.126.1 to 0.129.0. See merge request dependabot-gitlab/dependabot!365 - (andrejs)
- bump solargraph from 0.39.17 to 0.40.0. See merge request dependabot-gitlab/dependabot!363 - (andrejs)

### 👀 Links

[Commits since v0.2.11](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.11...v0.2.12)

## [v0.2.11 - 2020-12-14](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🐞 Bug Fixes

- do not pass invalid versioning strategy option to update checker. See merge request dependabot-gitlab/dependabot!358 - (andrejs)

### 👀 Links

[Commits since v0.2.10](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.10...v0.2.11)

## [v0.2.10 - 2020-12-13](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New Features

- Implement versioning strategy option. Closes #47. See merge request dependabot-gitlab/dependabot!355 - (andrejs)

### 🔬 Improvements

- logging improvements. See merge request dependabot-gitlab/dependabot!347 - (andrejs)

### 🐞 Bug Fixes

- check for existing hooks before creating new one. Closes #49. See merge request dependabot-gitlab/dependabot!356 - (andrejs)
- sanitize mentions on merge request descriptions. Closes #48. See merge request dependabot-gitlab/dependabot!350 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.126.0 to 0.126.1. See merge request dependabot-gitlab/dependabot!354 - (andrejs)
- bump dependabot/dependabot-core from 0.126.0 to 0.126.1. See merge request dependabot-gitlab/dependabot!353 - (andrejs)
- bump puma from 5.1.0 to 5.1.1. See merge request dependabot-gitlab/dependabot!349 - (andrejs)

### 👀 Links

[Commits since v0.2.9](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.9...v0.2.10)

## [v0.2.9 - 2020-12-09](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🚀 New Features

- allow registering multiple projects at once. See merge request dependabot-gitlab/dependabot!344 - (andrejs)

### 📦 Dependency updates

- bump dependabot-omnibus from 0.125.7 to 0.126.0. See merge request dependabot-gitlab/dependabot!342 - (andrejs)
- bump rubocop-rails from 2.8.1 to 2.9.0. See merge request dependabot-gitlab/dependabot!343 - (andrejs)

### 👀 Links

[Commits since v0.2.8](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.8...v0.2.9)

## [v0.2.8 - 2020-12-08](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- do not enque all jobs when adding project. See merge request dependabot-gitlab/dependabot!339 - (andrejs)
- testing improvements. See merge request dependabot-gitlab/dependabot!337 - (andrejs)

### 🐞 Bug Fixes

- allow registering projects without configuration file. Closes #44. See merge request dependabot-gitlab/dependabot!340 - (andrejs)

### 📦 Dependency updates

- bump dry-validation from 1.5.6 to 1.6.0. See merge request dependabot-gitlab/dependabot!338 - (andrejs)

### 👀 Links

[Commits since v0.2.7](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.7...v0.2.8)

## [v0.2.7 - 2020-12-04](https://gitlab.com/dependabot-gitlab/dependabot/-/releases)

### 🔬 Improvements

- Override default config folder via environment variable. See merge request dependabot-gitlab/dependabot!335 - (andrejs)
- Reduce verbosity of starting sidekiq jobs. See merge request dependabot-gitlab/dependabot!334 - (andrejs)
- Use anyway_config gem for configuration. See merge request dependabot-gitlab/dependabot!332 - (andrejs)
- changelog visual improvements. See merge request dependabot-gitlab/dependabot!331 - (andrejs)

### 📦 Dependency updates

- bump semantic_range from 2.3.0 to 2.3.1. See merge request dependabot-gitlab/dependabot!333 - (andrejs)
- bump mongoid from 7.1.5 to 7.2.0. See merge request dependabot-gitlab/dependabot!330 - (andrejs)

### 👀 Links

[Commits since v0.2.6](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.6...v0.2.7)

## [v0.2.6](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.5...v0.2.6)

- dependencies: bump dependabot-omnibus from 0.125.6 to 0.125.7. See merge request dependabot-gitlab/dependabot!326
- dependencies: bump simplecov from 0.19.1 to 0.20.0. See merge request dependabot-gitlab/dependabot!328
- dependencies: bump puma from 5.0.4 to 5.1.0. See merge request dependabot-gitlab/dependabot!329
- chore: Generate change log and add release utilities. See merge request dependabot-gitlab/dependabot!325
- Update chart version. See merge request dependabot-gitlab/dependabot!324

## [v0.2.5](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.4...v0.2.5)

- Healthcheck improvements. See merge request dependabot-gitlab/dependabot!322
- Bump rubocop-performance from 1.9.0 to 1.9.1. See merge request dependabot-gitlab/dependabot!323

## [v0.2.4](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.3...v0.2.4)

- Sidekiq graceful shutdown. See merge request dependabot-gitlab/dependabot!321
- Update chart version. See merge request dependabot-gitlab/dependabot!320
- Redis cache in production. See merge request dependabot-gitlab/dependabot!319
- Bump dependabot-omnibus from 0.125.5 to 0.125.6. See merge request dependabot-gitlab/dependabot!318
- Remove changed hook condition. See merge request dependabot-gitlab/dependabot!316
- Remove undercover gem. See merge request dependabot-gitlab/dependabot!315

## [v0.2.3](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.2...v0.2.3)

- Update chart version and add dependabot url. See merge request dependabot-gitlab/dependabot!314
- Automatically create and update webhooks. Closes #41. See merge request dependabot-gitlab/dependabot!310
- Bump faker from 2.14.0 to 2.15.1. See merge request dependabot-gitlab/dependabot!313
- Bump dependabot-omnibus from 0.125.4 to 0.125.5. See merge request dependabot-gitlab/dependabot!312

## [v0.2.2](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.1...v0.2.2)

- Use github access token for standalone test. See merge request dependabot-gitlab/dependabot!307
- Move github api limit rescue statement. See merge request dependabot-gitlab/dependabot!306
- Run internal pipelines on personal runners. See merge request dependabot-gitlab/dependabot!305
- Logging improvements. See merge request dependabot-gitlab/dependabot!304
- Add rubocop-rspec. See merge request dependabot-gitlab/dependabot!303
- API response improvements. See merge request dependabot-gitlab/dependabot!302
- Bump simplecov-cobertura from 1.4.1 to 1.4.2. See merge request dependabot-gitlab/dependabot!301
- Close persisted MRs when merged or closed in gitlab. Closes #40. See merge request dependabot-gitlab/dependabot!300
- Bump chart version. See merge request dependabot-gitlab/dependabot!299

## [v0.2.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.2.0...v0.2.1)

- Revert path change in image. See merge request dependabot-gitlab/dependabot!298

## [v0.2.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.1.3...v0.2.0)

- Remove non root user to optimise for image size. Closes #36. See merge request dependabot-gitlab/dependabot!289

## [v0.1.3](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.1.2...v0.1.3)

- Update chart version. See merge request dependabot-gitlab/dependabot!297
- Leave a comment to new mr on closed one. See merge request dependabot-gitlab/dependabot!296
- Bump dependabot-omnibus from 0.125.3 to 0.125.4. See merge request dependabot-gitlab/dependabot!295
- Simplify custom errors. Closes #38. See merge request dependabot-gitlab/dependabot!293
- Bump dependabot-omnibus from 0.125.2 to 0.125.3. See merge request dependabot-gitlab/dependabot!291
- Bump rubocop-performance from 1.8.1 to 1.9.0. See merge request dependabot-gitlab/dependabot!292

## [v0.1.2](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.1.1...v0.1.2)

- Simplify merge request service. See merge request dependabot-gitlab/dependabot!288
- Automatically close superseeded merge requests. Closes #4. See merge request dependabot-gitlab/dependabot!287
- Save merge requests info in db. Closes #35. See merge request dependabot-gitlab/dependabot!286
- Split merge request service. See merge request dependabot-gitlab/dependabot!285
- Fix deployment. See merge request dependabot-gitlab/dependabot!284
- Deploy dependabot from pipeline. See merge request dependabot-gitlab/dependabot!283
- Move badges to project settings. See merge request dependabot-gitlab/dependabot!282
- Update coverage output. See merge request dependabot-gitlab/dependabot!281
- Bump webmock from 3.9.5 to 3.10.0. See merge request dependabot-gitlab/dependabot!280
- Bump simplecov-console from 0.7.2 to 0.8.0. See merge request dependabot-gitlab/dependabot!279
- Bump dependabot-omnibus from 0.125.1 to 0.125.2. See merge request dependabot-gitlab/dependabot!278
- Bump bootsnap from 1.5.0 to 1.5.1. See merge request dependabot-gitlab/dependabot!276

## [v0.1.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.1.0...v0.1.1)

- Fix typo in mongo user variable name. See merge request dependabot-gitlab/dependabot!275
- Bump webmock from 3.9.4 to 3.9.5. See merge request dependabot-gitlab/dependabot!274

## [v0.1.0](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.0.8...v0.1.0) *BREAKING*

- Configuration improvements. See merge request dependabot-gitlab/dependabot!273
- Add mongodb production config. See merge request dependabot-gitlab/dependabot!272
- [BREAKING] Save project and configuration in database. Closes #34. See merge request dependabot-gitlab/dependabot!271
- Fix lcov path. See merge request dependabot-gitlab/dependabot!270
- Basic models. See merge request dependabot-gitlab/dependabot!269
- Update ruby runner version. See merge request dependabot-gitlab/dependabot!268
- Add undercover hook. See merge request dependabot-gitlab/dependabot!267
- Use only local cache for private runners. See merge request dependabot-gitlab/dependabot!266
- Add undercover gem. See merge request dependabot-gitlab/dependabot!265
- Replace lefthook with pre-commit. See merge request dependabot-gitlab/dependabot!264
- Update private runner label. See merge request dependabot-gitlab/dependabot!263
- Bump mongoid from 7.1.4 to 7.1.5. See merge request dependabot-gitlab/dependabot!261
- Bump webmock from 3.9.3 to 3.9.4. See merge request dependabot-gitlab/dependabot!262
- Bump dependabot-omnibus from 0.124.8 to 0.125.1. See merge request dependabot-gitlab/dependabot!260
- Bump dependabot-omnibus from 0.124.6 to 0.124.8. See merge request dependabot-gitlab/dependabot!258
- Bump dependabot-omnibus from 0.124.5 to 0.124.6. See merge request dependabot-gitlab/dependabot!255
- Bump bootsnap from 1.4.9 to 1.5.0. See merge request dependabot-gitlab/dependabot!256
- Adjust redis reconnect settings. See merge request dependabot-gitlab/dependabot!253
- Add mongodb gem. See merge request dependabot-gitlab/dependabot!252
- Remove warnings from redis-rb. See merge request dependabot-gitlab/dependabot!251
- Move release to internal runner. See merge request dependabot-gitlab/dependabot!250
- Add information about helm chart. See merge request dependabot-gitlab/dependabot!249

## [v0.0.8](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.0.7...v0.0.8)

- [Add redis password](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/1331e473d0dfd4ac3e99f6cfae0f91e6feeeddc2)
- [Bump dependabot-omnibus from 0.124.3 to 0.124.5](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/432926591730bec3baab9b5cd1aca673516a542e)
- [Bump rspec from 3.9.0 to 3.10.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/247)
- [Add write permissions for pyenv](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/244)
- [Bump dependabot-omnibus from 0.124.2 to 0.124.3](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/c2290338aeb6a9aba07af66fc714fba81cf31919)
- [Bump bootsnap from 1.4.8 to 1.4.9](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/243)
- [Bump puma from 5.0.3 to 5.0.4](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/242)
- [Bump puma from 5.0.2 to 5.0.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/238)
- [Bump dependabot-omnibus from 0.124.1 to 0.124.2](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/236)
- [Bump simplecov from 0.19.0 to 0.19.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/239)
- [Synchronize only specific actions](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/b5a5074e5c3c1b5930c7b039ef9fb26b67ea6370)
- [Bump dependabot-omnibus from 0.124.0 to 0.124.1](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/645737ec8fc58f98a16377052e8c6c6b640effea)
- [Bump dependabot-omnibus from 0.123.1 to 0.124.0](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/a0026b898b2c2eb9815172da6ee8ca7eafd4b47e)
- [Remove cron jobs not present in dependabot.yml anymore](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/c3ffcb061a784cbdf40a1cda6eb496ad6e833719)
- [Bump andrcuns/ruby from 2.6.6-buster-10.5 to 2.6.6-buster-10.6 in /spec/gitlab_mock](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/229)
- [Bump dependabot-omnibus from 0.123.0 to 0.123.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/225)
- [Add mock image update](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/2e76afc90ed37822c6d665500413207ff24fdd82)
- [Dev docker image and compose](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/224)
- [Synchronize dependency updates](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/223)
- [Remove unused semaphores](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/222)
- [Add global mutex for locking non thread safe operations](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/221)
- [Add mutex for locking non thread safe dependabot operations](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/220)

## [v0.0.7](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.0.6...v0.0.7)

- [Remove redis cache store](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/ce8846f5763d05bddbd5644e85328c276e747cc7)
- [Remove low level error handling](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/218)
- [Bump reek from 6.0.1 to 6.0.2](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/217)

## [v0.0.6](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.0.5...v0.0.6)

- [Set merge request to merge automatically for passed pipelines](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/4f4a176861077d1ab7fa85f2e58c597a6bd6a972)
- [Bump webmock from 3.9.2 to 3.9.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/216)
- [fix logging of credential warnings](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/209)
- [Bump dependabot-omnibus from 0.122.0 to 0.123.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/211)
- [Bump dependabot/dependabot-core from 0.122.0 to 0.123.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/212)
- [Remove github access token from e2e tests](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/213)
- [Separate docker build jobs for forked MR's](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/5d702e8f2a4763c22ce5f98f2d47525061b9658b)
- [Bump webmock from 3.9.1 to 3.9.2](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/208)
- [Bump rubocop from 0.93.0 to 0.93.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/207)
- [Bump rubocop from 0.92.0 to 0.93.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/206)
- [Add github access token for e2e tests](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/205)
- [Bump dependabot-omnibus from 0.121.0 to 0.122.0](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/8e5ec0f4c9e135fd337c4f00ec0bffc6c870449d)
- [Remove buildkit tag for e2e test job](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/9b9140e4752baf9aeeb6d1d7bbfc33127362da10)
- [Add puma error capture](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/204)
- [Bump rails from 6.0.3.3 to 6.0.3.4](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/202)
- [Bump dependabot/dependabot-core from 0.120.4 to 0.121.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/198)
- [Bump dependabot-omnibus from 0.120.4 to 0.121.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/197)
- [Use separate scalable buildkit runners](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/812195bf261e0cff91a55e029cef29be6e55b2de)
- [Bump dependabot/dependabot-core from 0.120.3 to 0.120.4](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/194)
- [Bump dependabot-omnibus from 0.120.3 to 0.120.4](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/193)
- [Bump simplecov-cobertura from 1.4.0 to 1.4.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/191)
- [Bump brakeman from 4.9.1 to 4.10.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/190)
- [Bump solargraph from 0.39.16 to 0.39.17](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/192)
- [Bump puma from 5.0.0 to 5.0.2](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/187)
- [Bump dependabot-omnibus from 0.120.1 to 0.120.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/186)
- [Use private k8s runner for image building](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/d176b7ac906a36320a4d3692bcb6e306a40479f7)
- [Bump solargraph from 0.39.15 to 0.39.16](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/185)
- [Bump dependabot-omnibus from 0.120.0 to 0.120.1](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/97aab5e84f5d5f350bec062c484b8d2c4d90a590)
- [Bump dependabot-omnibus from 0.119.6 to 0.120.0](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/eb7d0fd28bd441665fcffadfdf4b6d7e7afee523)
- [Bump sentry-raven from 3.1.0 to 3.1.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/177)
- [Bump rubocop from 0.91.1 to 0.92.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/178)
- [Bump rubocop from 0.91.0 to 0.91.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/175)
- [Bump dependabot-omnibus from 0.119.4 to 0.119.6](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/f72c7d66386981ac766b1495d0dadef5e23b4f48)

## [v0.0.5](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.0.4...v0.0.5)

- [Bump rubocop-performance from 1.8.0 to 1.8.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/170)
- [Bump sentry-raven from 3.0.4 to 3.1.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/168)
- [Bump puma from 4.3.6 to 5.0.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/169)
- [Bump rubocop-rails from 2.8.0 to 2.8.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/165)
- [Bump rubocop from 0.90.0 to 0.91.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/164)
- [Bump dependabot-omnibus from 0.119.3 to 0.119.4](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/438bd2f2d0034ac17e5546405c33fca128b4975a)
- [Bump webmock from 3.9.0 to 3.9.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/163)
- [Remove heroku deployment](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/162)
- [ci: Refactor pipeline to rules syntax](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/161)
- [Bump webmock from 3.8.3 to 3.9.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/160)
- [Bump dry-validation from 1.5.4 to 1.5.6](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/159)
- [enhancement: Dependabot configuration validation](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/57c781159d466721833b7acec9928d6b1234a34c)
- [Fix rescue statement](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/157)
- [Bump dependabot-omnibus from 0.119.2 to 0.119.3](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/bd5fd54ec2ecdddf4f5932fd1241657e4bfaa726)
- [Bump rails from 6.0.3.2 to 6.0.3.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/153)
- [Bump sidekiq from 6.1.1 to 6.1.2](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/152)

## [v0.0.4](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/0.0.3...v0.0.4)

- [Fix release job](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/64aacfbb0b6f6b9a9ec12659336be594491eb5d2)
- [dev: Fix codacy shell issues](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/150)
- [dev: Add codacy analysis](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/ccb408b3ce2a1b63b230ef93963ec7502e6cae2c)
- [feature: private docker and npm registries credentials support](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/b03396a3879b6bef7aab8d94b20bf441304a623f)
- [Bump puma from 4.3.5 to 4.3.6](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/147)
- [enhancement: Added support for multiple maven repositories](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/26c7c1913748b8527d730466c673cff4f74eb00c)
- [fix: Fix passing incorrect argument to cron job creator](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/146)
- [enhancement: Add package ecosystem mappings according to dependabot configuration](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/145)
- [Bump brakeman from 4.9.0 to 4.9.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/144)
- [enhancement: Improved documentation for allowing/ignoring specifix dependencies](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/143)
- [bugfix: Handle incorrect body in requests to webhook endpoint](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/142)
- [enhancement: Handle missing config](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/b8e44caf3f7423bb2656b49bfd6b750fca1022e2)
- [Bump rubocop-rails from 2.7.1 to 2.8.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/136)
- [enhancement: Error handling improvements](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/0fcb745baae995c6060932b255ff5aee31394992)
- [bugfix: Change owner of helpers directory](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/138)
- [nil check when logging created mr](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/137)
- [Bump rubocop-performance from 1.7.1 to 1.8.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/135)
- [Feat: Maven repository credentials](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/a2a80daaa59ebda95218455146dd5bcf3df91473)
- [Docker dev setup fix](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/133)
- [Remove v prefix from tag name](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/d42f652483e9c7e7d2a435185c94e809fb958613)
- [Improve gem cache handling](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/132)
- [Bump dependabot-omnibus from 0.119.1 to 0.119.2](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/00fd7b6623007c93b7c8de8ade4566821c1ba965)
- [Use ci_registry env variable for image name](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/128)
- [Properly handle not configured gitlab auth token](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/127)
- [Minor docker compose improvements](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/126)
- [Bump rubocop from 0.89.1 to 0.90.0](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/2f6b543ca8aba664188f8a5a2e1ad1373d10c1ed)
- [Bump dependabot-omnibus from 0.119.0 to 0.119.1](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/aefa566535f09a87c601e66b85758a693c67836f)
- [Bump sentry-raven from 3.0.3 to 3.0.4](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/122)

## [0.0.3](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.0.2...0.0.3)

- [Add rebase-strategy option support](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/b598f21c37a062550adf1a5ee70ded47911a4026)
- [Document standalone usage and other improvements](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/119)
- [Update only direct dependencies](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/ae2c917ee2cdf2c59904f7d0cd529fa9f244a2c7)
- [Bump sentry-raven from 3.0.2 to 3.0.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/116)
- [Allow definition of multiple entries of same package eco system](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/28565407270ea602bdc8c5f919927825c870b277)
- [Update readme](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/e3c9620174db19c36198eefb913827d61cbe0a3a)
- [Bump dependabot-omnibus from 0.118.16 to 0.119.0](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/ef5094e3a0095de598e7658586b833c74828a47b)
- [Add support for max pr parameter, improve logging](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/c195c42d41adf6fcb2f924b7ecf36322d8073867)
- [Bump aws-sdk-codecommit from 1.37.0 to 1.38.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/111)
- [Bump spring from 2.1.0 to 2.1.1](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/107)
- [Add logo and move ci runners file](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/a75275803f9c1403625f3d2fdd1d9d49e98d6dea)
- [Document not implemented options](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/45367d64cb46531df7c36f8f8a41a9aa983774fb)
- [Use latest master cache as fallback](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/105)
- [Add information about allow block options to readme](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/21386b7b5c0d7ee5a8edc279a9f3caffa56e8fa2)
- [Add security update support](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/8a5baa3357f9f6fd711bbf69e54b347ed6558b0d)
- [Minor readme update](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/5d6eee3aa4a859cfe8a8d5b72b4fa9fe72d47e14)
- [Add explicit cache expiry for user](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/ee6891176f1bde9e218a43cbc4243eed82107378)
- [Bump websocket-driver from 0.7.2 to 0.7.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/103)
- [Bump fugit from 1.3.6 to 1.3.8](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/102)
- [Bump dry-validation from 1.5.0 to 1.5.4](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/101)
- [Bump dry-schema from 1.5.0 to 1.5.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/100)
- [Bump dry-logic from 1.0.6 to 1.0.7](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/99)
- [Bump dry-configurable from 0.11.5 to 0.11.6](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/98)
- [Bump diff-lcs from 1.4.2 to 1.4.4](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/97)
- [Bump coderay from 1.1.2 to 1.1.3](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/96)
- [Allow all dependency updates](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/afff82b157efb3a3b7f5b664455e2df1f51b52cf)
- [Add bundle audit](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/3d639a8160c044d0d42feed61b68775c6f5ef398)
- [Implement allow and ignore options](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/2e60a49a4ec71ee89b6b97304b87825cbbcae756)
- [Fix reek command on CI](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/64efd88f9326c98cde5401dc9853b39bad00b6a5)
- [Add rubocop-rails and rubocop-performance extensions](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/834a80b4ef3e6ee9efac99ba0159acf5e70f3bf3)
- [Override buildkit entrypoint with blank cmd](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/91)
- [Simple gitlab stub for e2e tests](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/38d5764cc8e48c32b9ece38198f4388a90cf6971)
- [Bump dependabot-omnibus from 0.118.13 to 0.118.16](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/bfcd0a280f76bf1a327bc9a36e126fd2d977bf05)
- [Bump sentry-raven from 3.0.0 to 3.0.2](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/89)
- [Bump dependabot-omnibus from 0.118.12 to 0.118.13](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/543d3082c881673c36aea8cd5996690c0e7bfd50)
- [Bump solargraph from 0.39.14 to 0.39.15](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/85)
- [Bump simplecov-cobertura from 1.3.1 to 1.4.0](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/bd0a84ed0a5505a18ed30d7b2ef5a87ac508a35a)
- [Bump simplecov from 0.18.5 to 0.19.0](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/83)
- [Add brakeman](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/ea47a8d57409707811ba620cccee17ef01f50e56)
- [Docker image build and pipeline improvements](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/9ea707943dcc7f04add23b1d6133514ebace55d3)
- [Add timezone](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/cf2f12c366c7c17156b0c497305ade5ed56c8f60)
- [Bump solargraph from 0.39.13 to 0.39.14](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/79)
- [Manual register endpoint](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/b4ea51550f6261f0fd12a2eebd7d7d6c4ce4d347)
- [Additional compose fixes](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/e3b7a8c738c94afb21150dd1aa22f1d29307445d)
- [Pull latest image for cache](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/349e3600602ece698ad8da11654c586746709e0e)
- [Update docker build args](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/23afe479f369070df8c00b2ead0fdcea8c9b9bff)
- [Validate docker build on pipeline changes](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/2b3a95550aa0345a07657c1c13dd8c75a21f4fb8)

## [v0.0.2](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/v0.0.1...v0.0.2)

- [Fix rails server startup, update compose, regenerate credentials](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/77)
- [Add yard doc comment strings](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/76)
- [Bump bootsnap from 1.4.7 to 1.4.8](https://gitlab.com/dependabot-gitlab/dependabot/-/merge_requests/75)
- [Fix docker image version badge
](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/63d0508803913d309d495a3cb6ee2aa0f4a6f58c)
- [Push latest tag last
](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/ed14b2b8355c8ddcda5cd8bf31db7d7d6187f740)
- [Caching and release improvements
](https://gitlab.com/dependabot-gitlab/dependabot/-/commit/0768e162c2d2350d0d048de1ac6749afc55c135e)

## [v0.0.1](https://gitlab.com/dependabot-gitlab/dependabot/-/compare/f7c9b31...v0.0.1)

- Initial release
