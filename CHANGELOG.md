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
