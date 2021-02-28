# CHANGELOG

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
