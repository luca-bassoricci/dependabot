## 0.15.0 (2022-02-21)

### 🚀 New features (1 change)

- [Allow mr auto-merge on approval event](dependabot-gitlab/dependabot@7590b96b27f2285b2999ee6e2e73332ce93bd9d0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1342

### 🔬 Improvements (2 changes)

- [Rename moved projects during project sync](dependabot-gitlab/dependabot@155d31b939d58b7669ebd37616aca241619f6e86) by @andrcuns. See merge request dependabot-gitlab/dependabot!1341
- [Log dependabot shared helper output to debug level](dependabot-gitlab/dependabot@20b21243d39a5db0a74472cbeff85a13036382da) by @andrcuns. See merge request dependabot-gitlab/dependabot!1340

### 📦 Dependency updates (3 changes)

- [dep: bump dependabot-omnibus from 0.173.0 to 0.174.0](dependabot-gitlab/dependabot@1183178d3223d6575bbb0e1cce325cd6a0b1f6b8) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1337
- [dep: bump dry-validation from 1.7.0 to 1.8.0](dependabot-gitlab/dependabot@82db2007e56d48d9dcb40c328ae31e0bada364da) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1336
- [dep: bump dependabot-omnibus from 0.172.2 to 0.173.0](dependabot-gitlab/dependabot@874b36b16f8f9b75ece734a7b4c201d600c7faec) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1334

### 🛠️ Chore (1 change)

- [Improve dependabot helper logging](dependabot-gitlab/dependabot@bccd4e484c739ba824c606111696371bbb99dd3d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1343

## 0.14.2 (2022-02-14)

### 🐞 Bug Fixes (3 changes)

- [Rescue gitlab response on mr update](dependabot-gitlab/dependabot@b2e7c666fbe3635571add2d1848b7f3da4f7170a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1333
- [Always recreate mr on forks](dependabot-gitlab/dependabot@7bc8e7891715b6d2483b1243cf98631b471f6f28) by @andrcuns. See merge request dependabot-gitlab/dependabot!1332
- [Fix log call typo](dependabot-gitlab/dependabot@cd03091cfeb30956d4d78e8418d6478b89cdaf10) by @andrcuns. See merge request dependabot-gitlab/dependabot!1328

### 📦 Dependency updates (4 changes)

- [dep: bump dependabot-omnibus from 0.172.1 to 0.172.2](dependabot-gitlab/dependabot@c23b6fa4ed5b00f290795ffd289e3c52a2b968ce) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1322
- [dep: bump sentry-ruby, sentry-rails, rails and sentry-sidekiq](dependabot-gitlab/dependabot@d784c5dab577c62074525304d666cfe81dfb37c3) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1326
- [dep: bump rails from 6.1.4.4 to 6.1.4.6](dependabot-gitlab/dependabot@7e5ef271f9c5f677559ba2e8e972687c8e82dcd3) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1324
- [dep: bump puma from 5.6.1 to 5.6.2](dependabot-gitlab/dependabot@d7707a3743a566d539066bf1209eb7ee3303614a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1323

### 🛠️ Chore (4 changes)

- [Add Dependencies namespace for better grouping](dependabot-gitlab/dependabot@d78a24207e8e4e9bd68ad04e255dd8eebd588f9d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1331
- [Move merge request persistence to creator class](dependabot-gitlab/dependabot@92f0ecd1819c413be42a1f8af71ce033b2a1943a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1331
- [Add execution context for mr update jobs](dependabot-gitlab/dependabot@88a1bc24069a8a3f4bba5e802ad2fea3f312826f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1330
- [Do not fetch dependency info on merge request rebase](dependabot-gitlab/dependabot@72068195a08989ffa935d69af768f100f3e9a2ec) by @andrcuns. See merge request dependabot-gitlab/dependabot!1330

## 0.14.1 (2022-02-11)

### 🐞 Bug Fixes (1 change)

- [Fix schedule hours validation](dependabot-gitlab/dependabot@2b3bf70bc35d41487646c9ce405cddce4aaf863b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1321

## 0.14.0 (2022-02-10)

### 🚀 New features (1 change)

- [Add ability to set random schedule hour range](dependabot-gitlab/dependabot@c5ea19677c783c35e8bcb6cbacf7a18559e23021) by @andrcuns. See merge request dependabot-gitlab/dependabot!1314

### 🔬 Improvements (1 change)

- [Refactor update service to run full update of single dep at a time](dependabot-gitlab/dependabot@6ff0c2c301751ad24fecb8713c5bbf02755e05a6) by @andrcuns. See merge request dependabot-gitlab/dependabot!1297

### 🐞 Bug Fixes (2 changes)

- [Update sidekiq logger patch](dependabot-gitlab/dependabot@0423277ab9e6f2c7ffa050801278fc00e2f0a2fd) by @andrcuns. See merge request dependabot-gitlab/dependabot!1313
- [Check mr is in opened state before updating](dependabot-gitlab/dependabot@886d28b6b098987ff07d037e7928e463a724769c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1307

### 📦 Dependency updates (11 changes)

- [dep: bump dependabot-omnibus from 0.171.5 to 0.172.1](dependabot-gitlab/dependabot@073cd14bb6cf9038aaa97cc3d248052ad193956d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1318
- [dep-dev: bump rspec from 3.10.0 to 3.11.0](dependabot-gitlab/dependabot@bc4938894ab94fbb0e1329c07d96878acdf27477) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1319
- [Bump dependabot-omnibus from 0.171.4 to 0.171.5](dependabot-gitlab/dependabot@c930a3b2daf8807ec5944adf963fdf29e16c39fe) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1310
- [Bump sidekiq from 6.4.0 to 6.4.1](dependabot-gitlab/dependabot@c4d1568d6b8c9226deb8330d1169c09f264a75aa) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1311
- [Bump rubocop from 1.25.0 to 1.25.1](dependabot-gitlab/dependabot@86f65aa3be2e7651d100bed4a7f146915afc7501) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1305
- [Bump allure-rspec from 2.16.0 to 2.16.1](dependabot-gitlab/dependabot@b7886ef9714ac7e5f59b52a1c7183cda60237637) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1306
- [Bump bootsnap from 1.10.2 to 1.10.3](dependabot-gitlab/dependabot@6aa21dbfd489ed6a05da9fc41e3c3114e40fff03) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1304
- [Bump dependabot-omnibus from 0.171.3 to 0.171.4](dependabot-gitlab/dependabot@027771b5c706938b2723085e658312c66d258eca) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1290
- [Bump puma from 5.6.0 to 5.6.1](dependabot-gitlab/dependabot@08b6d025bdf1e54fdfef70b9b9f80725d4ef69ee) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1291
- [Bump dependabot/dependabot-core from 0.171.2 to 0.171.3](dependabot-gitlab/dependabot@63ef3906590731c1a6683266f3fa340ceb226a86) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1287
- [Bump rspec-rails from 5.0.2 to 5.1.0](dependabot-gitlab/dependabot@47ddd1e8ae350e4066643cff7922979435f6973d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1288

### 🔧 CI changes (4 changes)

- [Remove codecov](dependabot-gitlab/dependabot@d9b1de32b24d22a5d0bf8bcf0a6033730de3ae5e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1303
- [Update dependencies in CI image](dependabot-gitlab/dependabot@18a250f45981de4ff2915b98548f89816e21d450) by @andrcuns. See merge request dependabot-gitlab/dependabot!1295
- [Remove chart-testing from ci image](dependabot-gitlab/dependabot@9e30121eb67669bb0a8bef590cab0ec6d25a02c1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1294
- [Add helm diff and local version plugins](dependabot-gitlab/dependabot@dc63d3a7b758864b413fb459ee377e32f26f17ab) by @andrcuns. See merge request dependabot-gitlab/dependabot!1293

### 🛠️ Chore (7 changes)

- [Remove unnecessary UpdateErrors instance creation](dependabot-gitlab/dependabot@2ee7b5eb18dc0d78a2d9b86fc3185db7dd6c4cab) by @andrcuns. See merge request dependabot-gitlab/dependabot!1317
- [Refetch config from gitlab when webhooks are not configured](dependabot-gitlab/dependabot@717b9e4a2259514c80f9a6ff0f43c90526ff276c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1316
- [Temporary patch sidekiq job class](dependabot-gitlab/dependabot@6f30ed7526031310bea889522e96ca3860dc3dc0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1315
- [Lazy iterate gitlab projects on registration job](dependabot-gitlab/dependabot@9e7c79ef1d3cc59e60e32acf26a2c539773edfa6) by @andrcuns. See merge request dependabot-gitlab/dependabot!1308
- [Simplify update service setup](dependabot-gitlab/dependabot@d8ff1c27ca61642bab31f31cc62d2e5bb64b31b6) by @andrcuns. See merge request dependabot-gitlab/dependabot!1302
- [Remove redundant config methods](dependabot-gitlab/dependabot@d5f7535523105bcd8c794ab6e5c4999a0b53d5cc) by @andrcuns. See merge request dependabot-gitlab/dependabot!1301
- [Refactor config fetching](dependabot-gitlab/dependabot@17ff51fec808e28dc178418dc34b7be27bf4e3ac) by @andrcuns. See merge request dependabot-gitlab/dependabot!1296

### 📄 Documentation updates (1 change)

- [Remove latest master tag from documentation](dependabot-gitlab/dependabot@f739f3e3fd513bc901a9d41a062c3f542f0add49) by @andrcuns. See merge request dependabot-gitlab/dependabot!1309

## 0.13.0 (2022-01-26)

### 🚀 New features (1 change)

- [Support allow and ignore rules for auto-merge](dependabot-gitlab/dependabot@9a10516a07ce428d1ed26a0c268fc623723079c9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1234

### 🔬 Improvements (3 changes)

- [Add directory to missing config entry error.](dependabot-gitlab/dependabot@002c48a405b230d7b214ebc8020f053a8b4ac176) by @cchantep. See merge request dependabot-gitlab/dependabot!1284
- [Better error handling during merge request update and reopen action](dependabot-gitlab/dependabot@ed09638e397c3a6b80991914176b27ed7975fd3f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1275
- [Remove manually closed merge request branch](dependabot-gitlab/dependabot@67500fbdcfd65243a0c2a0dfc87983a7c9b88b3c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1266

### 🐞 Bug Fixes (5 changes)

- [Change healthcheck test syntax to array notation](dependabot-gitlab/dependabot@8ac6e1f539aab492dbd888edb96c7fc656bf9516) by @GijsDJ. See merge request dependabot-gitlab/dependabot!1283
- [Do not register projects without default branch](dependabot-gitlab/dependabot@940dddc189e263f8be5d25306779556e85e47325) by @andrcuns. See merge request dependabot-gitlab/dependabot!1281
- [Add mr comment only if mr update failed](dependabot-gitlab/dependabot@dad84a7d8caf4363d26d881c00ef4059e2ebb1c0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1280
- [Clear logger execution context after job finished](dependabot-gitlab/dependabot@6732af98db4bf19a5787fff177e6fd0c5d5ca8b1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1255
- [Use correct config class in rake task](dependabot-gitlab/dependabot@93b56dd8f00b144006e0294226a83a8a339d85c5) by @testn1. See merge request dependabot-gitlab/dependabot!1230

### 📦 Dependency updates (38 changes)

- [Bump puma from 5.5.2 to 5.6.0](dependabot-gitlab/dependabot@217bfdcbf6b8b38276f0faf88f47526bbc00e6b2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1282
- [Bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@0be1f858c02bb9caaac29dd5b9461075eb29811f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1276
- [Bump rubocop-rspec from 2.7.0 to 2.8.0](dependabot-gitlab/dependabot@1640a3999a995edb63d932a2290a93c24b580239) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1279
- [Bump solargraph from 0.44.2 to 0.44.3](dependabot-gitlab/dependabot@6068173a803f4c7b998c1974985fe89932dfd495) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1274
- [Bump allure-rspec from 2.15.0 to 2.16.0](dependabot-gitlab/dependabot@f9e3e4cad7e674029ec598ecd1124bf04ab4c2ed) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1273
- [Bump bootsnap from 1.10.1 to 1.10.2](dependabot-gitlab/dependabot@70db8743b43eea41b905b1a16de5f2989e299144) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1272
- [Bump anyway_config from 2.2.2 to 2.2.3](dependabot-gitlab/dependabot@450a2ac6a76ed0fb5063046af45f68f25104009a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1271
- [Bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@01f6343eecd57d61801bfae2f8c864a0c8af4fb4) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1267
- [Bump sidekiq from 6.3.1 to 6.4.0](dependabot-gitlab/dependabot@b75cdf900e36f894d2c0e7f3926a93a37d358dfe) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1270
- [Bump sentry-sidekiq, sentry-rails and sentry-ruby](dependabot-gitlab/dependabot@be451771f7bac2bb1b74b320ee043cf3ee9bc715) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1265
- [Bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@96203195c3d672993e58438b475e66b570516bae) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1263
- [Bump rubocop from 1.24.1 to 1.25.0](dependabot-gitlab/dependabot@162fc64daf053d77b87fab27fad28e1f6f1ddfbf) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1262
- [Bump bootsnap from 1.9.4 to 1.10.1](dependabot-gitlab/dependabot@bc087fcf621b3e43587dfc53fd29017ca8f797e5) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1261
- [Bump rubocop-performance from 1.13.1 to 1.13.2](dependabot-gitlab/dependabot@f4bd8e7e01d691718cbff7babbeb3c0ab68318d3) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1258
- [Bump rubocop-rails from 2.13.1 to 2.13.2](dependabot-gitlab/dependabot@4b648962cbb80935808ee93b9e8ae536a87eedef) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1256
- [Bump dependabot-omnibus from 0.171.1 to 0.171.2](dependabot-gitlab/dependabot@7a90756912fae3edad6b5a16aa9752d8244df2e9) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1245
- [Bump reek from 6.0.6 to 6.1.0](dependabot-gitlab/dependabot@972fa565a88f34074b48f6b0a304e6506e4a9a64) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1252
- [Bump sentry-sidekiq from 4.9.0 to 4.9.1](dependabot-gitlab/dependabot@39ac4f5d2ee36b8b9e78ecabd31db955d1668f6e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1251
- [Bump sentry-rails from 4.9.0 to 4.9.1](dependabot-gitlab/dependabot@f54e87dbad482fd1975a668647d0e06e431c4b2d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1250
- [Bump reek from 6.0.6 to 6.1.0](dependabot-gitlab/dependabot@4fc65cc75b45858946bf7d0f7df4235bba423a7a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1249
- [Bump sentry-ruby from 4.9.0 to 4.9.1](dependabot-gitlab/dependabot@59f595afb9e430428729b19bb0a6602935e176c7) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1247
- [Bump dependabot-omnibus from 0.171.0 to 0.171.1](dependabot-gitlab/dependabot@eb3a2941b293c5fd9f6f11fbba7029f2393d1a44) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1243
- [Bump dependabot-omnibus from 0.170.0 to 0.171.0](dependabot-gitlab/dependabot@8620cc7b49afaa95885344712dff1dda0b675506) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1240
- [Bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@c8cac9818a6d0f52126084fa27cdaa81f31a291a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1237
- [Bump bootsnap from 1.9.3 to 1.9.4](dependabot-gitlab/dependabot@eb7a26a7c5f82798173af2c9724550334b0dab02) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1236
- [Bump rubocop-rails from 2.13.0 to 2.13.1](dependabot-gitlab/dependabot@84927f4bf1264e7da62a6d46ebc4f47da3ca2904) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1235
- [Bump git from 1.10.1 to 1.10.2](dependabot-gitlab/dependabot@2712164b193255aafb120cf63b2fdf661fb4a62d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1233
- [Bump dependabot-omnibus from 0.169.8 to 0.170.0](dependabot-gitlab/dependabot@0d343aa2538fac66bcc8b6f117a605112b18e8b4) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1224
- [Bump rspec_junit_formatter from 0.5.0 to 0.5.1](dependabot-gitlab/dependabot@151221763c41e7e35e4167b81e0e188f289fb195) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1229
- [Bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@28e6d7c1c0e2f7f550ebda971bffe26ecd261dd0) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1225
- [Bump rspec_junit_formatter from 0.4.1 to 0.5.0](dependabot-gitlab/dependabot@cbc77e35ec5d437d224c315e7a7aee372e9a1c41) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1223
- [Bump git from 1.10.0 to 1.10.1](dependabot-gitlab/dependabot@3ae497e2ff459d9a393039a9948221e5481c31c9) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1222
- [Bump rubocop-performance from 1.13.0 to 1.13.1](dependabot-gitlab/dependabot@26a265a9fbb8b78b702b20510a86deb00113ac05) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1220
- [Bump rubocop from 1.24.0 to 1.24.1](dependabot-gitlab/dependabot@a0b714fbc136055c3fb8fbab26a8835b0647cb3a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1219
- [Bump rubocop-rspec from 2.6.0 to 2.7.0](dependabot-gitlab/dependabot@4478637320ee16a00fd5497a012643d732ce509f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1215
- [Bump rubocop-performance from 1.12.0 to 1.13.0](dependabot-gitlab/dependabot@7f46ca824811daf6258dbd065bb7abd6039cf5c8) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1213
- [Bump rubocop from 1.23.0 to 1.24.0](dependabot-gitlab/dependabot@a9105c6d03291897243e152dddd51245daa5d845) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1212
- [Bump dependabot-omnibus from 0.169.7 to 0.169.8](dependabot-gitlab/dependabot@fc61e06d35d45536a28c8ca72ea85f67781299c8) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1209

### 📦🛠️ Development dependency updates (2 changes)

- [Bump gitlab-org/release-cli in /.gitlab/docker/ci](dependabot-gitlab/dependabot@0063c185d6396fdd6cfbcfdf0fdf8263ec87a68f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1285
- [Bump helmpack/chart-testing from v3.4.0 to v3.5.0 in /.gitlab/docker/ci](dependabot-gitlab/dependabot@c4679a9aa37e31adf7df1f1f7ec0e5a7eaf36240) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1232

### 🔧 CI changes (4 changes)

- [Do not use dependency proxy for forks](dependabot-gitlab/dependabot@c131e711c12e09ee059e722b7a1fa3e81b999cb8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1286
- [Add inline cache for built images](dependabot-gitlab/dependabot@4734591c867d7f2d21f6632df6b7a4773a7d8f24) by @andrcuns. See merge request dependabot-gitlab/dependabot!1221
- [Fix CI runner image names](dependabot-gitlab/dependabot@d6910e5a4d081a11087e57b21698a626e0aa850b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1218
- [Run e2e tests on dependency updates](dependabot-gitlab/dependabot@0a86f2bb6bb8937b4c23947d28e038a69318c04b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1211

### 🛠️ Chore (2 changes)

- [Improve class grouping by using separate modules](dependabot-gitlab/dependabot@8d498d923f47687456833a0b5e86892d0a209716) by @andrcuns. See merge request dependabot-gitlab/dependabot!1259
- [Rename and group merge request classes](dependabot-gitlab/dependabot@e1edcafa8fca28754b34afd5d40699c6361b0c33) by @andrcuns. See merge request dependabot-gitlab/dependabot!1257

### 📄 Documentation updates (2 changes)

- [Add docs for auto-merge allow/ignore rules](dependabot-gitlab/dependabot@21e5e8fe2fef7f25d51125aa9015fe674ad5d837) by @andrcuns. See merge request dependabot-gitlab/dependabot!1242
- [fix helm chart configuration link](dependabot-gitlab/dependabot@fb1d00b2b914f667c151c1ce280ebcc8895ffc62) by @solidnerd. See merge request dependabot-gitlab/dependabot!1217

## 0.12.0 (2021-12-21)

### 🔬 Improvements (3 changes)

- [Log conflicting dependencies when update is impossible](dependabot-gitlab/dependabot@22eb0b7d45733bacb1e95101702b90279bcaeefe) by @andrcuns. See merge request dependabot-gitlab/dependabot!1193
- [[BREAKING] Capture run errors on standalone run and fail if any present](dependabot-gitlab/dependabot@2c2acf3536ba2adac87417dbca087b896088c17f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1191
- [Automatically resolve bot command discussions](dependabot-gitlab/dependabot@6eb348fe563934eb72fcf6c2ee6a4b656b1f6c93) by @andrcuns. See merge request dependabot-gitlab/dependabot!1190

### 🐞 Bug Fixes (7 changes)

- [Strip protocol from private terraform registries](dependabot-gitlab/dependabot@7c5398c40464b8371092e7dc6cbfe81ef26f275a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1208
- [Correctly pass registries credentials to core updaters](dependabot-gitlab/dependabot@06e0b82ddb57bcac6a480500d9bf5f964518f8ec) by @andrcuns. See merge request dependabot-gitlab/dependabot!1203
- [Strip protocol from private docker registries](dependabot-gitlab/dependabot@84b0c3440db8820fb2932e259373f17cc94d0add) by @andrcuns. See merge request dependabot-gitlab/dependabot!1200
- [Strip protocol from npm private registries](dependabot-gitlab/dependabot@e3e0f5d7d17f22c8a513b33bed9bf5a3d2335fec) by @andrcuns. See merge request dependabot-gitlab/dependabot!1199
- [Use correct cache key for config from different branches](dependabot-gitlab/dependabot@8b1bd7c6cf69a37b71805513ba5632f91a09f657) by @andrcuns. See merge request dependabot-gitlab/dependabot!1198
- [Correctly fetch milestone_id from title](dependabot-gitlab/dependabot@2156c5f94d1a52390498da5e68478eba0e2aba62) by @andrcuns. See merge request dependabot-gitlab/dependabot!1192
- [respect directory when closing superseeded merge requests](dependabot-gitlab/dependabot@9cf7b4a1bddc7a3fddbbac3be7f2096ce0e3c92b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1189

### 📦 Dependency updates (7 changes)

- [Bump dependabot-omnibus from 0.169.6 to 0.169.7](dependabot-gitlab/dependabot@255a84d8c0e71956b75c7d481a01650c65113f15) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1204
- [Bump rails from 6.1.4.3 to 6.1.4.4](dependabot-gitlab/dependabot@5333a4c85498999a537370999bf77826a2f139f4) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1188
- [Bump simplecov-cobertura from 2.0.0 to 2.1.0](dependabot-gitlab/dependabot@d1786305838245f576ac26779b34eefa43e6d7b7) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1187
- [Bump rails from 6.1.4.2 to 6.1.4.3](dependabot-gitlab/dependabot@d2eeed5d4982ac291df7f54ca37700c78d0cebd2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1186
- [Bump dependabot-omnibus from 0.169.5 to 0.169.6](dependabot-gitlab/dependabot@147d10b3842162ec79259304f7915bfdef40ec08) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1183
- [Bump rails from 6.1.4.1 to 6.1.4.2](dependabot-gitlab/dependabot@7c228b5dbf843bd442a3803f545cb3b0fd376254) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1184
- [Bump gitlab from `cfd0d9a` to `25f6f76`](dependabot-gitlab/dependabot@ceec855b3895295de9967e412725598eb1d43c57) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1173

### 📦🛠️ Development dependency updates (3 changes)

- [Bump git from 1.9.1 to 1.10.0](dependabot-gitlab/dependabot@17e772d96fb0dd8ddd1ff552e7c2645f94f9b632) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1205
- [Bump docker from 20.10.11 to 20.10.12 in /.gitlab/docker/ci](dependabot-gitlab/dependabot@521bbdca92637a3231e337e112818bc7c3735b1b) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1181
- [Update base image for gitlab mock](dependabot-gitlab/dependabot@ddcc662d39e9fff1a19f29fd7d0ba85c4adcfd8c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1174

### 🔧 CI changes (4 changes)

- [Reuse COMPOSE_PROJECT_NAME env var](dependabot-gitlab/dependabot@463c85cc140635747a2e90db8738c55c7a69b3f3) by @andrcuns. See merge request dependabot-gitlab/dependabot!1179
- [Update buildkit version](dependabot-gitlab/dependabot@7aeaf564247258a063a677ec0e8ca257dd3fcf5f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1178
- [Fix ci image latest tag](dependabot-gitlab/dependabot@da8b44cbc587d8a8e1a2d6408c13d960e83678a9) by @andrcuns.
- [Update CI setup](dependabot-gitlab/dependabot@bf519a07bac2c1d8022561d9fdc843f9df6d695f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1172

### 🛠️ Chore (6 changes)

- [Remove unused update_cache parameter in config fetcher](dependabot-gitlab/dependabot@c12ce283adcc802226de1b8a39edbbf046dc9298) by @andrcuns. See merge request dependabot-gitlab/dependabot!1202
- [Update cached config on ProjectCreator call](dependabot-gitlab/dependabot@ed96229a54e1a5df9c6d8999ffdf9c2216660fbf) by @andrcuns. See merge request dependabot-gitlab/dependabot!1201
- [Remove OpenStruct usage](dependabot-gitlab/dependabot@6365a90197834cedc9bffc33004f8b5303a62252) by @andrcuns. See merge request dependabot-gitlab/dependabot!1195
- [Update devcontainer setup](dependabot-gitlab/dependabot@af6015efd8ba1170ca051656b45f1ec613fd88b0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1194
- [Refactor controller tests to use airborne](dependabot-gitlab/dependabot@c5901a783ade51cbf9bfb39f50f14a889c7a4902) by @andrcuns. See merge request dependabot-gitlab/dependabot!1182
- [Update gitlab mocking setup for testing](dependabot-gitlab/dependabot@46e2db2bd2fcc8a1e8deb38e345147623cc8c47f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1177

## 0.11.0 (2021-12-11)

### 🚀 New features (1 change)

- [[BREAKING] add get, add, and delete projects api endpoints](dependabot-gitlab/dependabot@b281491ba435a5ef51b4014bdae37758608456fa) by @andrcuns. See merge request dependabot-gitlab/dependabot!1139

### 🔬 Improvements (1 change)

- [Add project update endpoint](dependabot-gitlab/dependabot@ca1f2a02a32c443e5e29a58688cc8a32ba3b172c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1169

### 📦 Dependency updates (1 change)

- [Bump dependabot-omnibus from 0.169.3 to 0.169.4](dependabot-gitlab/dependabot@365663e571deb1459b1c037540d76c3a8062b329) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1163

### 🔧 CI changes (3 changes)

- [Allow redundant pipeline to be canceled](dependabot-gitlab/dependabot@88834748eeb6f17030177df9d0197aa16c50ff75) by @andrcuns. See merge request dependabot-gitlab/dependabot!1165
- [Add custom changelog template](dependabot-gitlab/dependabot@b2b9e5c51a4c24c3bcd99339ae5ea4142bfd5656) by @andrcuns. See merge request dependabot-gitlab/dependabot!1161
- [Fix gitlab release creation](dependabot-gitlab/dependabot@d4d68c9527d9a4374db1a913d8bd676018a082eb) by @andrcuns. See merge request dependabot-gitlab/dependabot!1160

### 💾 Deployment (1 change)

- [Bump google from 4.2.1 to 4.3.0 in /terraform](dependabot-gitlab/dependabot@7c399d8d488dfe715181aecd3ca9c2f26f6048d6) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1162

## 0.10.11 (2021-12-06)

### 🚀 New features (1 change)

- [add support for custom commit message trailers](dependabot-gitlab/dependabot@31843d3023641298877eadb5d615cbb8580ba3cf) by @andrcuns.

### 🔧 CI changes (3 changes)

- [use gitlab changelog generation functionality](dependabot-gitlab/dependabot@8c230ffe5e54e86423476cad17972ecb091bc526) by @andrcuns. See merge request dependabot-gitlab/dependabot!1158
- [use gitlab dependency proxy for docker images](dependabot-gitlab/dependabot@3e203c4309239ef2c43efc7ed84e884de1a0b77f) by @andrcuns.
- [bump ci ruby version, remove custom image](dependabot-gitlab/dependabot@bfae42210dd5e5e701bbd5c28d47de79106d4bcf) by @andrcuns.

### 💾 Deployment (1 change)

- [Bump kubernetes from 2.7.0 to 2.7.1 in /terraform](dependabot-gitlab/dependabot@5c6ae81878d9b0dc3e565b7a82411df49456b114) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1159

### 🛠️ Chore (1 change)

- [Remove ci dockerfile dependency updates](dependabot-gitlab/dependabot@6cd40e44bbc07f7a45bb9ca5fe7f97591907b99f) by @andrcuns.
