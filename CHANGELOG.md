## 0.27.2 (2022-10-02)

### 🐞 Bug Fixes (4 changes)

- [Store update job failures in separate model](dependabot-gitlab/dependabot@edf4432a88261dfaa570d954dda90a38ffb9e777) by @andrcuns. See merge request dependabot-gitlab/dependabot!1780
- [Fix incorrect return value on mr creation in some cases](dependabot-gitlab/dependabot@ab2e4818b05bc3fd968c8fe034f91df3b6ec2429) by @andrcuns. See merge request dependabot-gitlab/dependabot!1779
- [Do not stop obsolete mr closing and vulnerability issue creation when open mr limit reached](dependabot-gitlab/dependabot@9ef60a0914c45e5db9ddcf89584d486a21db9b07) by @andrcuns. See merge request dependabot-gitlab/dependabot!1773

### 📦 Development dependency updates (2 changes)

- [dep: bump solargraph from 0.47.1 to 0.47.2](dependabot-gitlab/dependabot@2b926726d407c1b487f37432ebea2428b0a36b68) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1778
- [dep: bump rspec_junit_formatter from 0.5.1 to 0.6.0](dependabot-gitlab/dependabot@cb9a269067ce7c5c4436805ef82d91e6059eeffd) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1775

### 🔧 CI changes (2 changes)

- [chore(deps): update registry.gitlab.com/dependabot-gitlab/ci-images:ruby docker digest to 61e257f](dependabot-gitlab/dependabot@7188da379e9a0198c0cc008fef39da72157f7d6c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1776
- [Make sure migration runs successfully in deploy test job](dependabot-gitlab/dependabot@1f1354ab7b45c5e48ef5a757e4196e1d7752119a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1774

### 🛠️ Chore (7 changes)

- [Restore deleted migration](dependabot-gitlab/dependabot@1b2a157724ef7f32bb771ea6398e608ec823d8c8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1781
- [Update github graphql schema](dependabot-gitlab/dependabot@69c811786eb2d6d3f8202f35f832e46192fa4353) by @andrcuns. See merge request dependabot-gitlab/dependabot!1784
- [Correctly unset removed attributes](dependabot-gitlab/dependabot@18194548508709d4203c07bb06c4bc14816c9f6b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1783
- [Update seeded test data](dependabot-gitlab/dependabot@e1f89c5aef900f32ea69c5ebac7b9b3c8a8559b8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1782
- [Clean up old run log and error array objects](dependabot-gitlab/dependabot@fc6cc3d2047bb69e3be80bfb74fe3f11a5cf6e3b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1782
- [Remove old migration for non existing model](dependabot-gitlab/dependabot@5fedd8f929df3debfca89b041526ec35b1d55826) by @andrcuns. See merge request dependabot-gitlab/dependabot!1782
- [Add validation for migrations completed successfully](dependabot-gitlab/dependabot@ca81f2451bcea64a86546a0dbd448db3e272f519) by @andrcuns. See merge request dependabot-gitlab/dependabot!1781
- [Add migration testing](dependabot-gitlab/dependabot@74f24485c2a68ff30120b5c4771e1275f7e02ff8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1777

### 📄 Documentation updates (1 change)

- [Add link to releases in Gitlab container registry](dependabot-gitlab/dependabot@e26c4517548afdcdc648655f60cfe2bfdd2b9563) by @andrcuns.

## 0.27.1 (2022-09-29)

### 🐞 Bug Fixes (1 change)

- [Remove global milestone cache](dependabot-gitlab/dependabot@e06096ebde7ef3e7ac04cfdec4a95c5c45df8b80) by @andrcuns. See merge request dependabot-gitlab/dependabot!1771

### 📦 Dependency updates (1 change)

- [dep: bump yabeda-sidekiq from 0.8.2 to 0.9.0](dependabot-gitlab/dependabot@af818afcb07a7daed35ac06971b1f680bd4c59c4) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1769

### 📦 Development dependency updates (2 changes)

- [dep: bump solargraph from 0.47.0 to 0.47.1](dependabot-gitlab/dependabot@6619249aa573b2beb26b53b6202b24d025267b35) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1770
- [dep: bump solargraph from 0.46.0 to 0.47.0](dependabot-gitlab/dependabot@caad51faa3b8f12c62f7703285adc14058412708) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1767

### 🔧 CI changes (8 changes)

- [Fix release jobs and image publishing](dependabot-gitlab/dependabot@beafca15b52f296f76a9281f11e898309a5cd5d3) by @andrcuns.
- [chore(deps): update andrcuns/allure-report-publisher docker tag to v1](dependabot-gitlab/dependabot@e8e198bf7331ce578cfa7c69a15d89bf5db51eda) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1768
- [Add metrics report for standalone test runtime](dependabot-gitlab/dependabot@05efb9f0ef89cf7f2248ffafb3321d7fecc16aad) by @andrcuns. See merge request dependabot-gitlab/dependabot!1765
- [Update registry.gitlab.com/dependabot-gitlab/ci-images:ruby Docker digest to d8d532b](dependabot-gitlab/dependabot@f3fd55540497321749de9953461e11c50c8d44ef) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1766
- [Update registry.gitlab.com/dependabot-gitlab/ci-images:ruby Docker digest to c523584](dependabot-gitlab/dependabot@188249d8125af8af6398d15240f62801cf2c109c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1763
- [Run docker workflows on large runner](dependabot-gitlab/dependabot@8c1ebc4d01bc89b8c197a262b5ef52ba9fb2f670) by @andrcuns. See merge request dependabot-gitlab/dependabot!1762
- [Build multi-arch images on dep changes and master runs](dependabot-gitlab/dependabot@7a466620276f4f7782a9db87414b6fa4fa7796d9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1760
- [Replace regctl with buildx imagetools](dependabot-gitlab/dependabot@90b3a01db982d9b12353369c0405bc3b59b07eee) by @andrcuns. See merge request dependabot-gitlab/dependabot!1761

### 🛠️ Chore (1 change)

- [Add more information to log context](dependabot-gitlab/dependabot@f936c2ade081b7504cf6f3705bc0f309f86af70f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1764

## 0.27.0 (2022-09-23)

### 🔬 Improvements (1 change)

- [Add limited support for arm docker images](dependabot-gitlab/dependabot@dd07bea3ce645ded4f44ef2eeb77024282ad6b6c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1749

### 🐞 Bug Fixes (1 change)

- [Do not save execution log as single document](dependabot-gitlab/dependabot@58dae320ec916f00ed475f401c8a0a45de2ef79e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1756

### 📦 Dependency updates (5 changes)

- [dep: [security] bump commonmarker from 0.23.5 to 0.23.6](dependabot-gitlab/dependabot@fccdd1cabcfbc3612f9db0447fe4397efc70c2f1) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1755
- [dep: bump sidekiq from 6.5.6 to 6.5.7](dependabot-gitlab/dependabot@9fb68c757a0de2fdc253308bb61b33131d8ba69c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1748
- [dep: bump yabeda-sidekiq from 0.8.1 to 0.8.2](dependabot-gitlab/dependabot@e3a2a7ccd911cc6ffb4535f9c7dfef6fd3a8c740) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1745
- [dep: bump rubocop-rails from 2.15.2 to 2.16.0](dependabot-gitlab/dependabot@fb6e2ea9e6b2ed102ed766cd50519aa4711ee9b4) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1741
- [dep: bump rails from 7.0.3.1 to 7.0.4](dependabot-gitlab/dependabot@cec21b9ef20b41cc13e72f1379024b946340c5ae) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1740

### 📦 Development dependency updates (5 changes)

- [dep: bump rubocop-rspec from 2.13.1 to 2.13.2](dependabot-gitlab/dependabot@4d91a65a0dec697d0902fdd71bf4e45d837fdb13) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1754
- [dep: bump spring from 4.0.0 to 4.1.0](dependabot-gitlab/dependabot@2217d726fdc4dfcbafd7ea37033496452c2b2c73) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1751
- [dep: bump rubocop-rails from 2.16.0 to 2.16.1](dependabot-gitlab/dependabot@5fcfba79075616c4c78b06527e21952024844499) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1747
- [dep: bump rubocop-rspec from 2.12.1 to 2.13.1](dependabot-gitlab/dependabot@4fc6e83ce50ae1b53eb16801fcb6342e61c1a10f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1743
- [dep: bump rubocop-performance from 1.14.3 to 1.15.0](dependabot-gitlab/dependabot@d201c1041a623afde12ab7a81e4431424c7fb27e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1742

### 🔧 CI changes (6 changes)

- [Always use buildkit builder for image builds](dependabot-gitlab/dependabot@cb76ba2961a16722e32ab44d5f2bcefee4597110) by @andrcuns. See merge request dependabot-gitlab/dependabot!1758
- [Always generate test report and coverage](dependabot-gitlab/dependabot@951a631ec596609c4f4406c9a51d83797f5496fe) by @andrcuns. See merge request dependabot-gitlab/dependabot!1757
- [chore(deps): update registry.gitlab.com/dependabot-gitlab/ci-images:ruby docker digest to 0ff5817](dependabot-gitlab/dependabot@6586619c1c9d32db731a908e02d73294c7e4227e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1753
- [chore(deps): update registry.gitlab.com/dependabot-gitlab/ci-images:ruby docker digest to 12a9f5a](dependabot-gitlab/dependabot@00710d894a5cddc0855bedaea36397d522e3dc07) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1750
- [Update andrcuns/allure-report-publisher docker tag to v0.11.0](dependabot-gitlab/dependabot@d49397649c0306e76000cc64dfc49b97ef72725a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1746
- [dep: update docker docker tag to v20.10.18](dependabot-gitlab/dependabot@6ef8ff76387097edcd90b48a0da49cc71cd429ff) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1744

## 0.26.1 (2022-09-09)

### 🐞 Bug Fixes (1 change)

- [Fix ui page styles](dependabot-gitlab/dependabot@3786c35655216e828d89a6c83c01acb55bbf51fc) by @andrcuns. See merge request dependabot-gitlab/dependabot!1739

## 0.26.0 (2022-09-09)

### 🚀 New features (1 change)

- [Add app version number to top right corner of UI](dependabot-gitlab/dependabot@c241a2c2ae2f5529a426dd39b858ad36e6d41a3a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1736

### 🔬 Improvements (1 change)

- [Add delay when retrying gitlab api requests](dependabot-gitlab/dependabot@b49690b3acfa690aa5b71802b4a15fffbcc0544a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1737

### 🐞 Bug Fixes (1 change)

- [Respect squash option when auto-merging in standalone mode](dependabot-gitlab/dependabot@f6533501724a20d373280f5733b3e3d026c730c0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1738

### 📦 Dependency updates (3 changes)

- [dep: bump dependabot-omnibus from 0.211.0 to 0.212.0](dependabot-gitlab/dependabot@767a32de00222f96e78a5cc89d24d6adbd2262d1) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1735
- [dep: bump rubocop from 1.35.1 to 1.36.0](dependabot-gitlab/dependabot@a497ffd9897eebe82255c744c85bfa077c33bda2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1734
- [dep: bump sidekiq from 6.5.5 to 6.5.6](dependabot-gitlab/dependabot@4fe8db178713aab3438f2ef665b6a381c4648e7c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1732

### 📦 Development dependency updates (1 change)

- [dep: bump faker from 2.22.0 to 2.23.0](dependabot-gitlab/dependabot@6d129c4c7fb3a2cfda6dd6a6fa6132bba94119a9) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1733

### 📄 Documentation updates (1 change)

- [Add various private gitlab registries usage examples](dependabot-gitlab/dependabot@6d5667c5a537d6490345635f358aabf17470edfd) by @andrcuns. See merge request dependabot-gitlab/dependabot!1730

## 0.25.2 (2022-08-29)

### 🐞 Bug Fixes (1 change)

- [Set rails env to production by default](dependabot-gitlab/dependabot@299674778fa82b9c2764736165229b248d0cdcd5) by @andrcuns. See merge request dependabot-gitlab/dependabot!1729

## 0.25.1 (2022-08-28)

### 🐞 Bug Fixes (3 changes)

- [Return correct recreate command result status](dependabot-gitlab/dependabot@6adc173f27d98e2c7be3ee73a1aa8066311456ac) by @andrcuns. See merge request dependabot-gitlab/dependabot!1728
- [Correctly handle mr recreate when dependency is up to date](dependabot-gitlab/dependabot@369fc566dc3d717793a3e129c851356291a1c778) by @andrcuns. See merge request dependabot-gitlab/dependabot!1727
- [Use correct gitlab access token on mr recreate](dependabot-gitlab/dependabot@f4840a00b452753d60cecdc61e34127886ec04bc) by @andrcuns. See merge request dependabot-gitlab/dependabot!1725

### 📦 Dependency updates (4 changes)

- [dep: bump dependabot-omnibus from 0.209.0 to 0.211.0](dependabot-gitlab/dependabot@da1239c60cdc3d8a339486f972c9aab2e8cd3d32) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1722
- [dep: bump puma from 5.6.4 to 5.6.5](dependabot-gitlab/dependabot@68390f9ca52506e6aa3823b86f83e77c6b9aeec6) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1723
- [dep: bump sidekiq from 6.5.4 to 6.5.5](dependabot-gitlab/dependabot@59c46aeb9ffe8cfdd5809f72d17ba5ef022023bb) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1720
- [dep: bump solargraph from 0.45.0 to 0.46.0](dependabot-gitlab/dependabot@71b5aef1fe7db368629b10a015a097d52060378f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1719

### 📦 Development dependency updates (2 changes)

- [dep: bump rubocop from 1.35.0 to 1.35.1](dependabot-gitlab/dependabot@b2c87c3b29f7eb4e6354fdde12b61286ec978485) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1718
- [dep: bump git from 1.11.0 to 1.12.0](dependabot-gitlab/dependabot@dcba2a1c0375c24732bd974c4df4892f75dc8237) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1717

### 🔧 CI changes (2 changes)

- [Run dependency and license scan on dependency changes only](dependabot-gitlab/dependabot@a0e37cc00f8435b8a41d4c02e1bbdf69eb2aca6d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1726
- [chore(deps): update registry.gitlab.com/dependabot-gitlab/ci-images:ruby docker digest to cec6af7](dependabot-gitlab/dependabot@0b538bcc85192c06dbbaba222516007ddbdbb487) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1721

### 🛠️ Chore (1 change)

- [Ignore warning generated by sidekiq](dependabot-gitlab/dependabot@e9d023da223b50148b6546682ae3ffd070b5d397) by @andrcuns. See merge request dependabot-gitlab/dependabot!1724

## 0.25.0 (2022-08-18)

### 🚀 New features (1 change)

- [Support for project specific gitlab access tokens](dependabot-gitlab/dependabot@81affd260497ac472de946e0c30cf30f79a8b7f9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1676

### 🔬 Improvements (3 changes)

- [Add improved error message if project is missing default branch or repository](dependabot-gitlab/dependabot@4faecf9458355e7588dd8d3b74484100e678d213) by @andrcuns. See merge request dependabot-gitlab/dependabot!1713
- [Add custom ruby warning processing](dependabot-gitlab/dependabot@b4e36fdecf8ddc786860c40173c0498b852db023) by @andrcuns. See merge request dependabot-gitlab/dependabot!1696
- [Normalize log messages saved in database](dependabot-gitlab/dependabot@b6b5c2cb7b7bcbb229a18c890a20244a6646d99b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1681

### 🐞 Bug Fixes (5 changes)

- [Correctly handle non existing project when processing webhooks](dependabot-gitlab/dependabot@e5082990288da3fe83c2d6abeda1771532bcc73b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1690
- [Use project specific gitlab access token when processing webhooks](dependabot-gitlab/dependabot@99407ea3c4c97a77bb74b0231051e0ab89d08553) by @andrcuns. See merge request dependabot-gitlab/dependabot!1685
- [Fixup logging message saving](dependabot-gitlab/dependabot@c205a8eeff3fa17b795c53ceb3c3cbe9485b5cc2) by @andrcuns.
- [Correctly persist dependency update job log in database](dependabot-gitlab/dependabot@0e8865c7495eaca279dcc4dd6c6c5321b2deb4b4) by @andrcuns. See merge request dependabot-gitlab/dependabot!1679
- [Use correct gitlab access token for project sync in UI](dependabot-gitlab/dependabot@a8f1127d8db82bb234e4f22051739f3ee865e3b7) by @andrcuns. See merge request dependabot-gitlab/dependabot!1678

### 📦 Dependency updates (12 changes)

- [dep: bump sentry-sidekiq from 5.4.1 to 5.4.2](dependabot-gitlab/dependabot@b36be124c74dfb59fe3c232c28cfb4ba19f2ba25) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1716
- [dep: bump sentry-rails from 5.4.1 to 5.4.2](dependabot-gitlab/dependabot@57df4584c8b916ef8dd01f315455a9bd13ede283) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1715
- [dep: bump dependabot-omnibus from 0.208.0 to 0.209.0](dependabot-gitlab/dependabot@3f09d20110d9a42f4057e1d7982e7bb09e2be0c9) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1714
- [dep: bump dependabot-omnibus from 0.207.0 to 0.208.0](dependabot-gitlab/dependabot@c70d25aecfd2c2935dd8d21cc93a24e053f9d8f5) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1711
- [dep: bump pry-byebug from 3.10.0 to 3.10.1](dependabot-gitlab/dependabot@94f371444ac40df900cccbb63bd3cad745c58d80) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1712
- [dep: bump dependabot-omnibus from 0.204.0 to 0.207.0](dependabot-gitlab/dependabot@fcf91dfd5a22965d45cf61b44353e395620b2e9a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1704
- [dep: bump rubocop from 1.33.0 to 1.34.1](dependabot-gitlab/dependabot@217d7bf3450a11c29390a54805fca7e83d205620) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1700
- [dep: bump sidekiq from 6.5.3 to 6.5.4](dependabot-gitlab/dependabot@be509cbc9d869fa27296c94cc58005407da59836) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1699
- [dep: bump rubocop from 1.32.0 to 1.33.0](dependabot-gitlab/dependabot@3176f4d66c2f3508281f6663891f1dbce6feea00) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1689
- [dep: bump sidekiq from 6.5.1 to 6.5.3](dependabot-gitlab/dependabot@1e6954c7a7351eda64af29ce3a925820ab124d25) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1688
- [dep: bump dependabot-omnibus from 0.202.0 to 0.204.0](dependabot-gitlab/dependabot@afffa2056eb65c11d9d713090a4aa4b6835e3efe) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1683
- [dep: bump sentry-sidekiq from 5.3.1 to 5.4.1](dependabot-gitlab/dependabot@59d84fb334fb3b8621b48629d65835cd669226c7) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1674

### 📦 Development dependency updates (2 changes)

- [dep: bump pry-byebug from 3.9.0 to 3.10.0](dependabot-gitlab/dependabot@dca728d42c9b68e34006b3e4020238ae792284c5) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1710
- [dep: bump rubocop from 1.34.1 to 1.35.0](dependabot-gitlab/dependabot@2828dfaa735f90148e93eaef3ddda10c612eeed0) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1707

### 🔧 CI changes (11 changes)

- [chore(deps): update andrcuns/allure-report-publisher docker tag to v0.10.0](dependabot-gitlab/dependabot@0f9515f14c47340ba5a2d602e9c378ef03e59f72) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1709
- [chore(deps): update registry.gitlab.com/dependabot-gitlab/ci-images:ruby docker digest to 82a0fce](dependabot-gitlab/dependabot@d1ec173d5af18b95ac2d71bc979bc606f3a7bee6) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1708
- [Add initial support for multi-platform image building](dependabot-gitlab/dependabot@fc4b5ab91bd794221c05146d55403facc2e2375a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1706
- [Remove unused container scanning variable](dependabot-gitlab/dependabot@cda826b8fd25203286eb7da29a5a06f58c6b18fe) by @andrcuns. See merge request dependabot-gitlab/dependabot!1703
- [Use specific sha-id for default ci image](dependabot-gitlab/dependabot@3f9f69237ea304bcb459741b5c7c766e7617c4e0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1703
- [Skip coverage upload on failed pipeline](dependabot-gitlab/dependabot@467fb8825a347c4d3d0bce4119e276585ce28d88) by @andrcuns.
- [Update codacy reporter version and caching](dependabot-gitlab/dependabot@8b32907d17549fbac520fa06a6946b46f3f09d3c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1695
- [Add docker image container scan job](dependabot-gitlab/dependabot@437fc4a4f4623f208ba85d85832c897f52fdf93a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1694
- [chore(deps): update dependency bitnami/mongodb to v6](dependabot-gitlab/dependabot@0b71d16d3126cece1fc186e360602ae53ec6880c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1686
- [Use gitlab license scanner job](dependabot-gitlab/dependabot@c800f0d1b0e7409efb152f11f98f3ab42d0580cf) by @andrcuns. See merge request dependabot-gitlab/dependabot!1680
- [Add license scanning job](dependabot-gitlab/dependabot@7fa7b49faa07fb4c8bc32f049be865159e42b502) by @andrcuns. See merge request dependabot-gitlab/dependabot!1677

### 🛠️ Chore (10 changes)

- [Add option to print next changelog](dependabot-gitlab/dependabot@f7b2e47ea15ec787ddca28036fe92040db7d967b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1705
- [Set warning processing after logger is set up](dependabot-gitlab/dependabot@22dcbd9e5279ffa94d001a47cb6ebc3a567ae147) by @andrcuns. See merge request dependabot-gitlab/dependabot!1703
- [Add upgradable info to container scan output](dependabot-gitlab/dependabot@dc3e9aacff15622831142e0ac97c244aceb685d5) by @andrcuns. See merge request dependabot-gitlab/dependabot!1697
- [Fix order dependant spec](dependabot-gitlab/dependabot@6fb9a01879ab6771678da16587f27c67946d241b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1684
- [Remove redundant methods and wrappers](dependabot-gitlab/dependabot@dcc1e389bf595300bec3b0f39c8052e21e7b857d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1682
- [Remove sentry-ruby top level dependency](dependabot-gitlab/dependabot@e33a9271b59b02eed51b6e03856cdd82fd9b2c8a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1675
- [Add request store for global stores](dependabot-gitlab/dependabot@83f8014b3717331ba5a50df4bb00deb76be9a816) by @andrcuns. See merge request dependabot-gitlab/dependabot!1673
- [Extract common dependency update logic to common class](dependabot-gitlab/dependabot@3c7f5f5eec3d06f6fedbb27471ac2d7e76183ac9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1672
- [Extract credentials passing](dependabot-gitlab/dependabot@41b11d5d56242db46c4ca7ed5837eaa9d460c3ce) by @andrcuns. See merge request dependabot-gitlab/dependabot!1671
- [Extract common webhook handling logic](dependabot-gitlab/dependabot@120234dfdfb1fb45a6b3e6f69cbdb900b865471e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1670

### 📄 Documentation updates (1 change)

- [Document gitlab webhook token configuration](dependabot-gitlab/dependabot@fea429600f55ff3046e501a052b5799165f8e311) by @andrcuns. See merge request dependabot-gitlab/dependabot!1669

### dependencies (1 change)

- [Add faraday-retry gem](dependabot-gitlab/dependabot@73f1927bdaf67db514eafd0e362d8e82e88a0bc3) by @andrcuns.

## 0.24.0 (2022-07-29)

### 🚀 New features (1 change)

- [Add dry-run option](dependabot-gitlab/dependabot@d60f078eb9031cabc80c8a8b6d2e7fa5392c7073) by @andrcuns. See merge request dependabot-gitlab/dependabot!1648

### 🐞 Bug Fixes (2 changes)

- [Correctly substitute multiple env var values in auth fields](dependabot-gitlab/dependabot@2a91e4e57655fc99a0d1b1f9f4a8beeaa1338296) by @andrcuns. See merge request dependabot-gitlab/dependabot!1652
- [Convert python registry basic auth to token format](dependabot-gitlab/dependabot@5791c32e665665c65e97e0f49d9dfc24451487f2) by @andrcuns. See merge request dependabot-gitlab/dependabot!1650

### 📦 Dependency updates (14 changes)

- [dep: bump faker from 2.21.0 to 2.22.0](dependabot-gitlab/dependabot@edc7cb7f1d6dcbbd5475e7cd9a8771c42312ef0a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1668
- [dep: bump bootsnap from 1.12.0 to 1.13.0](dependabot-gitlab/dependabot@d9cf3ab46d09e6d53ded149c63c7fc699fb0d8be) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1667
- [dep: bump sentry-rails and sentry-ruby](dependabot-gitlab/dependabot@ee6b10a74b28cdf6368273d616f67895465793bd) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1666
- [dep: bump dependabot-omnibus from 0.201.1 to 0.202.0](dependabot-gitlab/dependabot@b598c4b80f1f95b1cd4da6795d373a39286b0abc) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1665
- [dep: bump dependabot-omnibus from 0.201.0 to 0.201.1](dependabot-gitlab/dependabot@a1c1fe424e5b40ccca227bf6542600dc06c5f0a1) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1664
- [dep: bump sidekiq-cron from 1.6.0 to 1.7.0](dependabot-gitlab/dependabot@2c8b753818893738a00050e0cbb912646b6fb6e0) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1663
- [dep: bump mongoid from 8.0.1 to 8.0.2](dependabot-gitlab/dependabot@2caa2bfdb0bb4c038e9126ce9f61abc0eb366bdc) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1662
- [dep: bump dependabot-omnibus from 0.200.0 to 0.201.0](dependabot-gitlab/dependabot@3dbc708f82a0b2bcd7406421be2549d6be1890ce) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1661
- [dep: bump rubocop from 1.31.2 to 1.32.0](dependabot-gitlab/dependabot@f43a633e26ab6aa0e3013155d7a510989a40de67) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1660
- [dep: bump dependabot-omnibus from 0.199.0 to 0.200.0](dependabot-gitlab/dependabot@91976a1e2cf4a3dab069062ba38c2bc9ad569480) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1659
- [dep: bump mongoid from 7.4.0 to 8.0.1](dependabot-gitlab/dependabot@2fe99b487fb1d0ed80dfc82671513161f328634f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1658
- [dep: bump dependabot-omnibus from 0.198.0 to 0.199.0](dependabot-gitlab/dependabot@91044603ecbff502a357d0dee0bc322ebdba630b) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1656
- [dep: Bump redis from 4.7.0 to 4.7.1](dependabot-gitlab/dependabot@e9520693dc49cd16f81723d36439b78b113c6a38) by @andrcuns. See merge request dependabot-gitlab/dependabot!1654
- [dep: bump dependabot-omnibus from 0.197.0 to 0.198.0](dependabot-gitlab/dependabot@979cfb780fed65d72151082b1fb70ac5e734cdc9) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1647

### 📦 Development dependency updates (1 change)

- [dep: bump rubocop-performance from 1.14.2 to 1.14.3](dependabot-gitlab/dependabot@b7047f8a54cffe70edbf56bb13fdaf4f9742f511) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1655

### 🔧 CI changes (1 change)

- [chore(deps): update dependency andrcuns/allure-report-publisher to v0.9.0](dependabot-gitlab/dependabot@a02c764d7c8300759e7158d8b610e480ba24cd7b) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1651

### 🛠️ Chore (2 changes)

- [Remove deprecated method usage](dependabot-gitlab/dependabot@5b58dfc134603b0accd232cbb540ed6fca52e01c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1653
- [Add support for building multiple core helpers](dependabot-gitlab/dependabot@96fd5ee30966f3507608f763bc470068874bfadb) by @andrcuns. See merge request dependabot-gitlab/dependabot!1649

## 0.23.0 (2022-07-15)

### 🚀 New features (2 changes)

- [Add option to set different commit trailers for dev dependency mrs](dependabot-gitlab/dependabot@71b365dc5100630a0ebbab807119e774f6effe45) by @andrcuns. See merge request dependabot-gitlab/dependabot!1638
- [Add option to set different commit trailers for security mrs](dependabot-gitlab/dependabot@77aeac540edaf9aead636bada8ebc59a1f2f1f83) by @andrcuns. See merge request dependabot-gitlab/dependabot!1637

### 📦 Dependency updates (11 changes)

- [dep: bump dependabot-omnibus from 0.196.4 to 0.197.0](dependabot-gitlab/dependabot@3a511f78342dfc2a3b15b7a5016437c89a0a4411) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1645
- [Bump debian version for redis and mongodb](dependabot-gitlab/dependabot@cdc263621c3173880f10fdca24828d8fbf9367f8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1644
- [dep: Update dependency bitnami/redis to v7](dependabot-gitlab/dependabot@702836e8652a71dfc598d9d0fbe417250ca074bb) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1587
- [dep: bump dependabot-omnibus from 0.196.3 to 0.196.4](dependabot-gitlab/dependabot@b4d1b4a1649f3c705f6766a4d0ba1be9f2ede1d5) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1643
- [dep: bump dependabot-omnibus and gitlab](dependabot-gitlab/dependabot@d06e67af21f2f6e617d91175c1d90520d8c45db8) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1640
- [dep: bump rails from 7.0.3 to 7.0.3.1](dependabot-gitlab/dependabot@f1f491584d8aa3e58980dc6da0bbb619d35a950a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1642
- [dep-dev: bump rubocop-rails from 2.15.1 to 2.15.2](dependabot-gitlab/dependabot@d2fc4ea1ee5e40afa4fb9efcd35653a2de5f5f15) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1636
- [dep-dev: bump rubocop from 1.31.1 to 1.31.2](dependabot-gitlab/dependabot@ef081ed22f1912fa774736f9d178a83d67533f17) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1635
- [dep: [security] bump rails-html-sanitizer from 1.4.2 to 1.4.3](dependabot-gitlab/dependabot@27533e075249b79260eb88bed52969ec82260d06) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1634
- [dep-dev: bump rubocop-rspec from 2.12.0 to 2.12.1](dependabot-gitlab/dependabot@951e7378d79b628f8b4ef6a04919d87e127ac875) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1632
- [dep-dev: bump rubocop-rspec from 2.11.1 to 2.12.0](dependabot-gitlab/dependabot@edd2b50370fae8185fe5701cf0d1def704de0a7d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1631

### 🛠️ Chore (2 changes)

- [Print changelog data when bumping version](dependabot-gitlab/dependabot@b0a4742f750e1ef891cb91698b5fd78e54d2c8fb) by @andrcuns. See merge request dependabot-gitlab/dependabot!1646
- [Deprecate branch name configurations via environment variables](dependabot-gitlab/dependabot@6288dfe781d4c7f5bd1658eccdd9f7c24af0a2e5) by @andrcuns. See merge request dependabot-gitlab/dependabot!1633

## 0.22.4 (2022-07-01)

### 📦 Dependency updates (4 changes)

- [dep: bump sidekiq-cron from 1.5.1 to 1.6.0](dependabot-gitlab/dependabot@8a7505141b519b34b91f1badd1ad585ed77335c2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1629
- [dep: bump dependabot-omnibus from 0.196.0 to 0.196.2](dependabot-gitlab/dependabot@49025cdb2298d5af41cee6e3d09d0eefb56c71e9) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1628
- [dep-dev: bump rubocop from 1.30.1 to 1.31.1](dependabot-gitlab/dependabot@7c0c0f266f0a7f532f2ec7088292d3c6f926e3a2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1627
- [dep-dev: bump rubocop-rails from 2.15.0 to 2.15.1](dependabot-gitlab/dependabot@eb2a27780ad615d69c9829aaf5d0d930ed8caa11) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1624

## 0.22.3 (2022-06-25)

### 🐞 Bug Fixes (1 change)

- [Correctly set config for auto-merge: true option](dependabot-gitlab/dependabot@be8ac64bfadd6b2fd85a5ec0dbaf8080afd2e3a4) by @andrcuns. See merge request dependabot-gitlab/dependabot!1622

### 📦 Dependency updates (2 changes)

- [dep: bump dependabot-omnibus from 0.194.1 to 0.196.0](dependabot-gitlab/dependabot@707411f6d55dbdcb772c02355ed94693b0a7b48e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1623
- [dep: bump dependabot-omnibus from 0.194.0 to 0.194.1](dependabot-gitlab/dependabot@b42d54dd1462a385f5705a93decbf401f1f517eb) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1621

## 0.22.2 (2022-06-21)

### 🐞 Bug Fixes (1 change)

- [Do not set auto-merge to true by default](dependabot-gitlab/dependabot@da98d17d3000ee74a7bfd6c5d2b7a693348ebce3) by @andrcuns. See merge request dependabot-gitlab/dependabot!1620

## 0.22.1 (2022-06-20)

### 🐞 Bug Fixes (1 change)

- [Correctly handle merge errors when auto merging dependency updates](dependabot-gitlab/dependabot@9a5b36ff078f42d1eefb17ce9b0c0036ad363d12) by @andrcuns. See merge request dependabot-gitlab/dependabot!1617

### 📦 Dependency updates (5 changes)

- [dep: bump dependabot-omnibus from 0.193.0 to 0.194.0](dependabot-gitlab/dependabot@53452c4e2fac43d85208ee13a06f97861041dc55) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1616
- [dep: bump dependabot-omnibus from 0.192.1 to 0.193.0](dependabot-gitlab/dependabot@c4093853ccfc881e2995fbd1e1041a0f049f9bb1) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1614
- [dep: bump sidekiq from 6.5.0 to 6.5.1](dependabot-gitlab/dependabot@cbbdd6136a89a729ab699e1cbcded6590ab86a7a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1613
- [dep: bump dependabot-omnibus from 0.192.0 to 0.192.1](dependabot-gitlab/dependabot@c2bed200ca6a252165ae64f2e1ffe41b7fdf4fa9) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1611
- [dep-dev: bump rubocop-rails from 2.14.2 to 2.15.0](dependabot-gitlab/dependabot@22309a121334163ee0b7ff490abdd5b66a90ceb3) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1612

## 0.22.0 (2022-06-14)

### 🚀 New features (1 change)

- [Support for optional base configuration template](dependabot-gitlab/dependabot@06a642060f5274f96865f685eaad5243d1cf92a0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1608

### 📦 Dependency updates (1 change)

- [dep: bump dependabot-omnibus from 0.191.0 to 0.192.0](dependabot-gitlab/dependabot@8ba1a2aa1df57224de444b44cc418554f27dee28) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1607

### 🛠️ Chore (2 changes)

- [Raise error on incorrect base config updates definition](dependabot-gitlab/dependabot@c41c5de4d655def2178dbc48c8ed7f08a1ef222e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1610
- [Rename base configuration file option](dependabot-gitlab/dependabot@cd1a9f18acd54289941b9113550aa6ba0805dc98) by @andrcuns. See merge request dependabot-gitlab/dependabot!1609

## 0.21.1 (2022-06-11)

### 🔬 Improvements (1 change)

- [Add option to disable vulnerability alerts](dependabot-gitlab/dependabot@837c796e2a0f74a092b47f2625e700f2d143caaf) by @andrcuns. See merge request dependabot-gitlab/dependabot!1604

### 🐞 Bug Fixes (1 change)

- [Fetch correct obsolete vulnerability issues](dependabot-gitlab/dependabot@8c5448f20fcea45692076ed04377bbfffca54278) by @andrcuns. See merge request dependabot-gitlab/dependabot!1605

### 📦 Dependency updates (6 changes)

- [dep: bump sidekiq-cron from 1.5.0 to 1.5.1](dependabot-gitlab/dependabot@c34466fad311c95d67d9bcae4a4acbf38dff7a5f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1606
- [dep: bump sidekiq from 6.4.2 to 6.5.0](dependabot-gitlab/dependabot@a865fa06ec452d92664fc581c0b7a1d418c23073) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1600
- [dep: bump sidekiq-cron from 1.4.0 to 1.5.0](dependabot-gitlab/dependabot@1853b0c35558008e18c9910cb4a0ced95cfe7a64) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1602
- [dep-dev: bump rubocop-performance from 1.14.1 to 1.14.2](dependabot-gitlab/dependabot@f23ff1735357adbec8a1ec3e9a965781d48f3e38) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1601
- [dep: bump dependabot-omnibus from 0.190.1 to 0.191.0](dependabot-gitlab/dependabot@c6ffede174b97b86a3ace4264e1bdf3394862273) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1599
- [dep-dev: bump rubocop from 1.30.0 to 1.30.1](dependabot-gitlab/dependabot@2817a34317208235a3e9bc8e961cf4df452d7766) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1597

### 🔧 CI changes (2 changes)

- [Pin minor docker version in CI](dependabot-gitlab/dependabot@35744dfc674897b54ddcb45ec2a9c1784eb82d8d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1603
- [Update dependency docker to v20.10.17](dependabot-gitlab/dependabot@5417a0727a44a750a933c82df1f08d8b5f06b5bb) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1598

## 0.21.0 (2022-06-06)

### 🚀 New features (1 change)

- [Add dependabot-core http request logging](dependabot-gitlab/dependabot@f9f12b32add92ee71aced982a3703fd3eea65b1f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1585

### 🔬 Improvements (2 changes)

- [Pretty print helpers output](dependabot-gitlab/dependabot@6a2bafc2ce748d2ca95da0308d111abfb87b597d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1591
- [Log dependabot core parsed package manager version](dependabot-gitlab/dependabot@67cd250ea23db003050079d6156ee36c37aae4f2) by @andrcuns. See merge request dependabot-gitlab/dependabot!1590

### 🐞 Bug Fixes (1 change)

- [Correct open mr url for monorepos with multiple same package manager directories](dependabot-gitlab/dependabot@663d04dea95b1c3ff8e6017374732f7465b9952d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1589

### 📦 Dependency updates (8 changes)

- [dep-dev: bump rubocop-performance from 1.14.0 to 1.14.1](dependabot-gitlab/dependabot@0e540defae724a4a5939de534aa58028432e7c9d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1596
- [Bump jemmaloc version to 5.3.0](dependabot-gitlab/dependabot@17ddc18c1d6caa0b126fec77b6f7bc81ea47d2c1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1588
- [dep: bump dependabot-omnibus from 0.190.0 to 0.190.1](dependabot-gitlab/dependabot@9056b9644d63640ad0be2c6526e8aba3c280535f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1586
- [dep: bump bootsnap from 1.11.1 to 1.12.0](dependabot-gitlab/dependabot@94ecb8526a57f5de4ccc43e598edcc388acd682e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1584
- [dep: [security] bump rack from 2.2.3 to 2.2.3.1](dependabot-gitlab/dependabot@2846bd65201d5d1016d2f94c19168c2c31a3f386) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1579
- [dep: bump dry-validation from 1.8.0 to 1.8.1](dependabot-gitlab/dependabot@9473e81c5b20e7313f5f2396b24217ef34cf8902) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1578
- [dep-dev: bump rubocop from 1.29.1 to 1.30.0](dependabot-gitlab/dependabot@708428779e2aeaef3f6fc11bd14d67857c53f9df) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1577
- [dep-dev: bump rubocop-performance from 1.13.3 to 1.14.0](dependabot-gitlab/dependabot@3f34fd31d0eae1dbebd4525649a1d909588ad91e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1575

### 🔧 CI changes (6 changes)

- [Simplify docker runner args](dependabot-gitlab/dependabot@b67b1c16e237d056d7bc138dc49e679f3a45abe8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1594
- [Move dependency cache to build stage](dependabot-gitlab/dependabot@ce7bdf4789169b0668cd0facc55cc3ad4f4ff52f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1595
- [Always run all tests](dependabot-gitlab/dependabot@cca5da11ff97888c5fc6d39dc56a02802e1a5577) by @andrcuns. See merge request dependabot-gitlab/dependabot!1593
- [Use separate token for allure test reports](dependabot-gitlab/dependabot@3f8847012dcd96ea3cc39c282732f4a7dd07a9d3) by @andrcuns.
- [dep-dev: Update dependency andrcuns/allure-report-publisher to v0.8.0](dependabot-gitlab/dependabot@f9dea4875674d49dc81cf97ab88078f406dd3f52) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1582
- [Remove ci image build](dependabot-gitlab/dependabot@6d9b2aa128638d75c78eec0c127c0f90fa37df6d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1580

### 🛠️ Chore (5 changes)

- [Replace credentials value in helper command output](dependabot-gitlab/dependabot@0d584a470d99e22b472f7788ee9ea8f9cbf06eb7) by @andrcuns. See merge request dependabot-gitlab/dependabot!1592
- [Refactor log helper method](dependabot-gitlab/dependabot@62ea2b1a720dbace1f35d7a0d1b2c91b4afe9fba) by @andrcuns. See merge request dependabot-gitlab/dependabot!1592
- [Add testing rake tasks](dependabot-gitlab/dependabot@51d0121c9d9da6d835b414706fc0736e2d468d94) by @andrcuns. See merge request dependabot-gitlab/dependabot!1583
- [Store update job log entries in database as hash](dependabot-gitlab/dependabot@87d77ec33a4f98ca7a03a0c976541cecdd89689b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1583
- [Migrate to main branch](dependabot-gitlab/dependabot@c2e35a922f54d17f81a071ea4bab2700ad6250e8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1581

## 0.20.2 (2022-05-24)

### 🐞 Bug Fixes (2 changes)

- [Add missing rust package mapping for security vulnerabilities](dependabot-gitlab/dependabot@fb9b6ba8051180fe15112e2bd8045d81ee4daa24) by @andrcuns. See merge request dependabot-gitlab/dependabot!1573
- [Only evaluate explicitly allowed registries when fetching config](dependabot-gitlab/dependabot@62244bdeabca0641e1bd8c7335a35978a840814a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1568

### 📦 Dependency updates (4 changes)

- [dep-dev: bump allure-rspec from 2.17.0 to 2.18.0](dependabot-gitlab/dependabot@3ad5dd6853c1d77a73a17a46cbd23b41d9ed83c5) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1571
- [dep-dev: bump solargraph from 0.44.3 to 0.45.0](dependabot-gitlab/dependabot@e7aa89a9869f3b703c330f09d5549c9eca58f70b) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1572
- [dep: bump dependabot-omnibus from 0.189.0 to 0.190.0](dependabot-gitlab/dependabot@ea0ca1f5ef4f8c34d23d2b9e1d507eea826a5ced) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1570
- [dep-dev: bump rubocop-rspec from 2.10.0 to 2.11.1](dependabot-gitlab/dependabot@be5bc4707772d208d6c63fc4e87d9633e1000889) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1559

### 🔧 CI changes (2 changes)

- [Set all ci jobs as interruptible by default](dependabot-gitlab/dependabot@7e8276a4048723b70a6aedfd1f801238a5b292ce) by @andrcuns. See merge request dependabot-gitlab/dependabot!1567
- [Build docker images with buildx docker plugin](dependabot-gitlab/dependabot@8efcc057b455bc630f4d40beea7efe7eeb39b353) by @andrcuns. See merge request dependabot-gitlab/dependabot!1562

### 🛠️ Chore (6 changes)

- [Remove thread from log message of standalone mode](dependabot-gitlab/dependabot@8b687b7a2457870684b339c913240f7cd1935fbe) by @andrcuns. See merge request dependabot-gitlab/dependabot!1569
- [[BREAKING] Disable metrics endpoint by default](dependabot-gitlab/dependabot@9df5fc9d1d2aa38bd3051ef037ad004f53f91bfa) by @andrcuns. See merge request dependabot-gitlab/dependabot!1566
- [Fix dependency update log message saving](dependabot-gitlab/dependabot@5ec98b84f889b598f62f479caa79e6c906e96eaf) by @andrcuns. See merge request dependabot-gitlab/dependabot!1565
- [Reuse same logger instance for sidekiq](dependabot-gitlab/dependabot@0f822be11987627db75c005c847825a7b8cd2f79) by @andrcuns. See merge request dependabot-gitlab/dependabot!1564
- [Persist dependency update job log in database](dependabot-gitlab/dependabot@3e08bec71b9750413313c25be1d6337b094e7c04) by @andrcuns. See merge request dependabot-gitlab/dependabot!1561
- [Move db querries to model classes](dependabot-gitlab/dependabot@a932ba8ee93f98266c8ca0fe55ea5da37d547e8e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1560

## 0.20.1 (2022-05-17)

### 🐞 Bug Fixes (1 change)

- [Correctly handle vulnerabilities without patched version](dependabot-gitlab/dependabot@6d37bdd9e705407f4644ce933b535a8df4b625b1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1557

### 📦 Dependency updates (3 changes)

- [dep: bump dependabot-omnibus from 0.188.0 to 0.189.0](dependabot-gitlab/dependabot@60e31c572115e204af2c4f83385eb61c168ea110) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1558
- [dep: bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@9b49517843fa3103147eefad3c7a37c4c68ae5ac) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1555
- [dep: bump dependabot-omnibus from 0.187.0 to 0.188.0](dependabot-gitlab/dependabot@f8b8fa47a1e9cea1ba2960fcce9a5df4de7345ac) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1554

### 🔧 CI changes (2 changes)

- [dep-dev: Update docker to 20.10.16](dependabot-gitlab/dependabot@7aaad62a788c34075eee3e0ffb8459339ea0a47d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1556
- [dep-dev: Update dependency docker to v20.10.16](dependabot-gitlab/dependabot@4f2979099eb366807c79c3c4403441fe03dc1707) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1550

## 0.20.0 (2022-05-16)

### 🚀 New features (1 change)

- [Security vulnerability alerts](dependabot-gitlab/dependabot@e536cbdd966b7482921bffac3b0c0ce0dadf3ab0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1540

### 🔬 Improvements (3 changes)

- [Add configurable assignee for vulnerability issues](dependabot-gitlab/dependabot@4fa9a92b918bf6d3433773be89526d51791c94a5) by @andrcuns. See merge request dependabot-gitlab/dependabot!1548
- [Add webhook to close vulnerability issue in local database](dependabot-gitlab/dependabot@1ae97867bfa6c241dc6feb868c0b574ec1dfaf45) by @andrcuns. See merge request dependabot-gitlab/dependabot!1546
- [Automatically close obsolete vulnerability issues](dependabot-gitlab/dependabot@dd0d29f42551ab8f7e3067e12759d6e41a6c63b1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1541

### 📦 Dependency updates (9 changes)

- [dep-dev: bump faker from 2.20.0 to 2.21.0](dependabot-gitlab/dependabot@b76b91132646245592bee3796e14fcc7ff99694c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1553
- [dep: bump dependabot-omnibus from 0.186.1 to 0.187.0](dependabot-gitlab/dependabot@8f406bd9c95c4bd292fd2b471ed69ea9eb57ad14) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1552
- [dep-dev: bump rubocop from 1.29.0 to 1.29.1](dependabot-gitlab/dependabot@503c5897c26b711e048e41c63e8bc919482b1969) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1551
- [dep: bump dependabot-omnibus from 0.185.0 to 0.186.1](dependabot-gitlab/dependabot@925e946498c242d01e63acb3cad01aa76bd1579e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1547
- [dep-dev: bump capybara from 3.37.0 to 3.37.1](dependabot-gitlab/dependabot@f13f74588f7060a5800685112ffd745368a3853e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1545
- [dep: bump rails from 7.0.2.4 to 7.0.3](dependabot-gitlab/dependabot@5fe98f7158dac95b2ebe170f927a2d97d51f369d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1544
- [dep: bump dependabot-omnibus from 0.184.0 to 0.185.0](dependabot-gitlab/dependabot@5f38f400d4b4ba864c9223f038e53da923579940) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1543
- [dep-dev: bump capybara from 3.36.0 to 3.37.0](dependabot-gitlab/dependabot@2d6e11e0583aecb02d8d69fdd6e4c869413faede) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1542
- [dep-dev: bump rubocop from 1.28.2 to 1.29.0](dependabot-gitlab/dependabot@c821aa7099c5317daf68c2c07b48062cd7369116) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1538

### 🔧 CI changes (2 changes)

- [Update kind to v0.12 and docker to 20.10.15](dependabot-gitlab/dependabot@4c6ad5fadd860fbf221c9c11357c6ea63f40ae0d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1539
- [dep-dev: Update dependency docker to v20.10.15](dependabot-gitlab/dependabot@13078ce86302efdaad4ce2621c637f1a68188643) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1536

### 🛠️ Chore (1 change)

- [Make helpers build script more portable](dependabot-gitlab/dependabot@10da8a2bafa35e69b07836cade6c9a7e3af93a06) by @andrcuns. See merge request dependabot-gitlab/dependabot!1541

### 📄 Documentation updates (1 change)

- [Document security vulnerability alert issues](dependabot-gitlab/dependabot@5ada980f6894db32d4bb9d53cdfcd75503631961) by @andrcuns. See merge request dependabot-gitlab/dependabot!1549

## 0.19.2 (2022-05-07)

### 🐞 Bug Fixes (1 change)

- [Correctly handle projects without config on release_notification](dependabot-gitlab/dependabot@06fcb6a1255187f6f66adad0f37437274b37ed2d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1535

### 📦 Dependency updates (3 changes)

- [dep-dev: bump rubocop from 1.28.2 to 1.29.0](dependabot-gitlab/dependabot@c821aa7099c5317daf68c2c07b48062cd7369116) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1538
- [dev-dep: Update dependency thiht/smocker to v0.18.2](dependabot-gitlab/dependabot@adae591932d34070e2bc814e42200aac8b6435f5) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1532
- [dep: bump dependabot-omnibus from 0.183.0 to 0.184.0](dependabot-gitlab/dependabot@c796c959bf9845ae335a3f86fb4e492a582dc9b1) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1531

### 🔧 CI changes (4 changes)

- [dep-dev: Update dependency moby/buildkit to v0.10.3](dependabot-gitlab/dependabot@e4bd9a6c938564ddfe896181c81093f871a1d1e3) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1537
- [Fix coverage report publishing](dependabot-gitlab/dependabot@d9e9c8c6fac984deb847c9ffbbe9df04160af15d) by @andrcuns. See merge request dependabot-gitlab/dependabot!1533
- [dep-dev: Update dependency andrcuns/allure-report-publisher to v0.7.0](dependabot-gitlab/dependabot@33407da542644e467746c5d121607fa598bb866d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1530
- [Automatically detect dependabot-core image version](dependabot-gitlab/dependabot@7205072b13d54319e31427a010d5166f6247d28c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1529

## 0.19.1 (2022-05-04)

### 🔬 Improvements (1 change)

- [Add manual rake task to trigger automatic project registration](dependabot-gitlab/dependabot@9e6a050d6eb7e747ef4cd1502191a75373bb94ca) by @andrcuns. See merge request dependabot-gitlab/dependabot!1528

### 🐞 Bug Fixes (1 change)

- [Remove custom ignored sentry error parsing](dependabot-gitlab/dependabot@7b43e3f986a6b9fa858b2065075443657fea5db3) by @andrcuns. See merge request dependabot-gitlab/dependabot!1527

### 📦 Dependency updates (3 changes)

- [dep: bump graphql-client from 0.17.0 to 0.18.0](dependabot-gitlab/dependabot@4146cd07a093d95e1b059a229a7d4ca996ba9788) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1526
- [dep-dev: Update dependency bitnami/mongodb to v5](dependabot-gitlab/dependabot@f4201395989eabf5ffbacec92ddbdb6e5fb490ce) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1524
- [dep: bump dependabot-omnibus from 0.182.4 to 0.183.0](dependabot-gitlab/dependabot@2acf5b6a783ac7de9d58571eccd0e0b0c12078cc) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1522

### 🔧 CI changes (2 changes)

- [Use dev prefix for temp images](dependabot-gitlab/dependabot@d7df0701c68dd92e40e87d83a8d474e073745919) by @andrcuns. See merge request dependabot-gitlab/dependabot!1525
- [Wait for image release to update dependent repos](dependabot-gitlab/dependabot@5e3e8cb81a24b4d0e5cd5ee0059b8d6c0eacca75) by @andrcuns. See merge request dependabot-gitlab/dependabot!1521

### 📄 Documentation updates (1 change)

- [Update documentation on `CONFIG_BRANCH` setting](dependabot-gitlab/dependabot@f2ee0bdec29c66dda4d13340ccb96f0d5a6b844e) by @andrcuns.

## 0.19.0 (2022-04-29)

### 🚀 New features (3 changes)

- [Add option to ignore certain sentry errors](dependabot-gitlab/dependabot@c1410ddf00bf3f9f7017f674d4a1cb18f7a84d34) by @andrcuns. See merge request dependabot-gitlab/dependabot!1496
- [Add fixed vulnerability info to merge requests](dependabot-gitlab/dependabot@9cfb7c35c1283271c6a7def93ea59153dcff4215) by @andrcuns. See merge request dependabot-gitlab/dependabot!1477
- [Check security advisories when performing dependency update](dependabot-gitlab/dependabot@294d00d5526d783989badfe04e13f1f0fd092644) by @andrcuns. See merge request dependabot-gitlab/dependabot!1477

### 🐞 Bug Fixes (1 change)

- [Consider all dependencies when checking for obsolete mrs](dependabot-gitlab/dependabot@3f80f2366fb5ef3b18dec74ca98a1e3969516fd6) by @andrcuns. See merge request dependabot-gitlab/dependabot!1504

### 📦 Dependency updates (8 changes)

- [dep: bump sidekiq-cron from 1.3.0 to 1.4.0](dependabot-gitlab/dependabot@df0a8731d594866eec77c2c2fd4c8bf99b92ac27) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1518
- [dep: bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@2ba39d5f8d00770ef23b6ec70a974e8074874e59) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1517
- [dep: bump rails from 7.0.2.3 to 7.0.2.4](dependabot-gitlab/dependabot@9c3bacd0f23a43b1ea86efe25856023cbd225e01) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1514
- [dep: bump dependabot-omnibus from 0.182.0 to 0.182.4](dependabot-gitlab/dependabot@169bb14bcdeec315a094fca7fb6de84210b401c1) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1511
- [dep-dev: bump rubocop from 1.28.1 to 1.28.2](dependabot-gitlab/dependabot@d2cf2139409468c8105ff18a7e2a5309297274f0) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1508
- [dep-dev: bump rspec-rails from 5.1.1 to 5.1.2](dependabot-gitlab/dependabot@11b2c4895e30873f10e775d3128b30ebd97fe268) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1507
- [dep-dev: Update dependency thiht/smocker to v0.18.1](dependabot-gitlab/dependabot@0f74ca914903ac5a48523c4ba9640ac930b65662) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1499
- [dep-dev: bump rubocop from 1.27.0 to 1.28.1](dependabot-gitlab/dependabot@41556f5b0827c5f6ea8dc0ab6f6700a18bca7503) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1489

### 🔧 CI changes (7 changes)

- [Use latest tag as cache for docker build](dependabot-gitlab/dependabot@d4be6d72aa3b12965fc54a63e62b0010c1bc81e8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1520
- [Remove container-scan job](dependabot-gitlab/dependabot@0eff0a50654de0f37f6b9edb1dacc959eab9294e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1519
- [dep-dev: Update dependency moby/buildkit to v0.10.2](dependabot-gitlab/dependabot@1af632f1ce09b869babb9af5503a6f51d2bae191) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1516
- [Update container scanning options](dependabot-gitlab/dependabot@f5837d1c352135eeb80b3dc624b81d919ddd3991) by @andrcuns. See merge request dependabot-gitlab/dependabot!1515
- [dep-dev: Update dependency andrcuns/allure-report-publisher to v0.6.2](dependabot-gitlab/dependabot@ae1f7ff8ec395551198c30b57952032be6114e12) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1513
- [dep-dev Update dependency andrcuns/allure-report-publisher to v0.6.0](dependabot-gitlab/dependabot@7e512f058a610f0476f234f5e75096f2958d14d7) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1502
- [.gitlab-ci and docker-compose dependency updates via renovate](dependabot-gitlab/dependabot@46b13efdf29f9ee5b38c9b59be09651ead07ed36) by @andrcuns. See merge request dependabot-gitlab/dependabot!1498

### 🛠️ Chore (9 changes)

- [Remove external precommit-hooks](dependabot-gitlab/dependabot@78778017bf595c8daed872113dc4008355dca97e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1506
- [Update debug logger messages](dependabot-gitlab/dependabot@5875252e1b40b594a577fa1b07f1dc6913a85cfc) by @andrcuns. See merge request dependabot-gitlab/dependabot!1505
- [Update pre-commit hook jumanjihouse/pre-commit-hooks to v2.1.6](dependabot-gitlab/dependabot@50c03197224e76f43dc05841eaa595c802745cbd) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1503
- [Improve vulnerability database update logging and error handling](dependabot-gitlab/dependabot@ffb860ff71ec9e6acfde8a2d592ccd20a8a4b558) by @andrcuns. See merge request dependabot-gitlab/dependabot!1497
- [Improve github graphql query error handling](dependabot-gitlab/dependabot@01a5b578f729e77a660b5eca242a3eed8169b439) by @andrcuns. See merge request dependabot-gitlab/dependabot!1495
- [Add missing vulnerability sidekiq queue](dependabot-gitlab/dependabot@baa0b44dfbebe3416485851653f77024450e2587) by @andrcuns. See merge request dependabot-gitlab/dependabot!1492
- [Use tagged logger to indicate action instead of class name](dependabot-gitlab/dependabot@147bb952ef42feacaa0e3c984a4e69373ee1893a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1477
- [Improve job logger context setting](dependabot-gitlab/dependabot@4888893223ce670307d4cd04825bf30581b62dac) by @andrcuns. See merge request dependabot-gitlab/dependabot!1477
- [Add capability to fetch vulnerability info from Github](dependabot-gitlab/dependabot@36e1dc50fc0dfb7324639de79bb4e1a58e79dcd9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1477

## 0.18.0 (2022-04-21)

### 🚀 New features (3 changes)

- [Add support for custom updater options](dependabot-gitlab/dependabot@55debb7d07943ea423e7974b1f9dc730bd78e398) by @andrcuns. See merge request dependabot-gitlab/dependabot!1472
- [Add project configuration sync button in UI](dependabot-gitlab/dependabot@5f61e97ad3519d32fbf8af0304dbb4edc061d500) by @andrcuns. See merge request dependabot-gitlab/dependabot!1464
- [Add auto-rebase with-assignee option](dependabot-gitlab/dependabot@88445f45d748db50280de8f099f7b814861bccd8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1458

### 🔬 Improvements (1 change)

- [Improve configured url handling](dependabot-gitlab/dependabot@1a6e9ea642ec56199025348f9f08f3b377754fc4) by @andrcuns. See merge request dependabot-gitlab/dependabot!1460

### 🐞 Bug Fixes (2 changes)

- [Respect config branch option when registering new project](dependabot-gitlab/dependabot@1b29facd766417352a0e39d183bd0531d5bd8e5e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1478
- [Correctly handle reopened mr with restored branch](dependabot-gitlab/dependabot@911a393750b9ea8c6debc7abe23f422ba4b9e6e0) by @andrcuns. See merge request dependabot-gitlab/dependabot!1456

### 📦 Dependency updates (8 changes)

- [dep-dev: bump reek from 6.1.0 to 6.1.1](dependabot-gitlab/dependabot@3dec16b1bb7215a6b08ace4fde32b7efb4b9e3e2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1488
- [dep: bump dependabot/dependabot-core from 0.180.5 to 0.182.0](dependabot-gitlab/dependabot@efee8d15cb828d7f6abf9343af57148910f39839) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1484
- [dep-dev: bump rubocop-rspec from 2.9.0 to 2.10.0](dependabot-gitlab/dependabot@4c05321eefbfa57a78b494324c46c7ad0171b38b) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1486
- [dep: bump sidekiq from 6.4.1 to 6.4.2](dependabot-gitlab/dependabot@dca621365b30ef48e05dea8de0178c075a73410e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1485
- [dep-dev: bump git from 1.10.2 to 1.11.0](dependabot-gitlab/dependabot@b838734798a60d5bc7550d21bb8cd9abf2f9cacb) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1481
- [Bump nokogiri to 1.13.4](dependabot-gitlab/dependabot@e61f04f17188d8cb050063abb48445ecfb43053c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1471
- [dep-dev: bump ruby in /.gitlab/docker](dependabot-gitlab/dependabot@f069551934ffc86e4463ef5d8ed6e4268bd94ba8) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1470
- [dep-dev: bump rubocop from 1.26.1 to 1.27.0](dependabot-gitlab/dependabot@d03524b4c029ad235a5451c6952a98c07f9f6753) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1457

### 🔧 CI changes (13 changes)

- [Move issue triage to toolbox project](dependabot-gitlab/dependabot@90964ca9cbe9fff9d55881d598b47c4388b56ebd) by @andrcuns. See merge request dependabot-gitlab/dependabot!1482
- [Bump allure-report-publisher to 0.5.3](dependabot-gitlab/dependabot@fa87e8f85d592396f2eea078c0b3e3b099e78f63) by @andrcuns. See merge request dependabot-gitlab/dependabot!1480
- [Bump allure-report-publisher to 0.5.2](dependabot-gitlab/dependabot@55df5d76afb753942da0c0de3857908e7b8ee612) by @andrcuns. See merge request dependabot-gitlab/dependabot!1476
- [Simplify standalone test setup](dependabot-gitlab/dependabot@97d7b03e69e9a44e679beceaa02c619f8f2efde9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1468
- [Remove deprecated bundle-audit dependency scan](dependabot-gitlab/dependabot@a4a72d9ddc2230fb1af5e913ab1e2e9bae76600c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1467
- [Ruby based CI image](dependabot-gitlab/dependabot@3a8b225b24d8b918e0913b4d9153bda74555a163) by @andrcuns. See merge request dependabot-gitlab/dependabot!1466
- [Update bundler ci version](dependabot-gitlab/dependabot@1bcb55e09726bf174d4a86d596fb8221784f3f27) by @andrcuns. See merge request dependabot-gitlab/dependabot!1465
- [Add automated handling of stale issues](dependabot-gitlab/dependabot@7eb7bb5623199672c055c165fb13d73da9dd81b5) by @andrcuns. See merge request dependabot-gitlab/dependabot!1463
- [Remove redundant gitlab access token var reassigning for release jobs](dependabot-gitlab/dependabot@c73381f11d6e0d7f1749746cfd9a7e0108f5b663) by @andrcuns. See merge request dependabot-gitlab/dependabot!1462
- [Use ci image for release job](dependabot-gitlab/dependabot@d103b8ac20941776d3dd2c126e5cf68de398c9a8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1461
- [Fix deployment job](dependabot-gitlab/dependabot@ec2210d1ad3472ad80e0b656a51c97f22f44c1d4) by @andrcuns. See merge request dependabot-gitlab/dependabot!1459
- [Update buildkit version to v0.10.1](dependabot-gitlab/dependabot@1ea2f73cfa0a73ef7bf372a340f72d54ca640b11) by @andrcuns. See merge request dependabot-gitlab/dependabot!1454
- [Push ci generated app images to separate registry](dependabot-gitlab/dependabot@ebb923bbc3b0e174c6bb3a44cabac397789333bb) by @andrcuns. See merge request dependabot-gitlab/dependabot!1452

### 🛠️ Chore (3 changes)

- [Temporary disable broken spec](dependabot-gitlab/dependabot@e538caeb9a29e6d5157d981c9d00c63de277b4f9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1479
- [Log mongodb, redis and sentry to separate files](dependabot-gitlab/dependabot@96a5e0d395ce766dc55fbcfead6d3bafba78e293) by @andrcuns. See merge request dependabot-gitlab/dependabot!1479
- [Add missing updater options migration](dependabot-gitlab/dependabot@b89b1bf5b9af7e04faaae7c4092e038b798f9d07) by @andrcuns. See merge request dependabot-gitlab/dependabot!1474

## 0.17.2 (2022-04-08)

### 🐞 Bug Fixes (2 changes)

- [Ignore dependabot commands for non dependabot merge requests](dependabot-gitlab/dependabot@fd4e2c364842da8fc1e76b835d495f2f8092816a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1448
- [Correctly pass configuration when updating out of sync jobs](dependabot-gitlab/dependabot@48d83f64f015b5c7e921e69dde83f57e8a3c412c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1445

### 📦 Dependency updates (6 changes)

- [dep: bump dependabot-omnibus from 0.180.4 to 0.180.5](dependabot-gitlab/dependabot@ef80501e7af166d4f599b87ba3bdbd7c8bbdc68e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1449
- [dep: bump sidekiq_alive from 2.1.4 to 2.1.5](dependabot-gitlab/dependabot@e30b00dfd70f0dcf46bc4e986ac70a0dbcb66710) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1450
- [dep: bump sidekiq-cron from 1.2.0 to 1.3.0](dependabot-gitlab/dependabot@8825e705aa7fe59ff7c262c73df15cb0235b9360) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1442
- [dep: bump dependabot-omnibus from 0.180.3 to 0.180.4](dependabot-gitlab/dependabot@86173a7b8385007bc016d2eb0465212034171583) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1441
- [dep: bump dependabot-omnibus from 0.180.2 to 0.180.3](dependabot-gitlab/dependabot@558995d0d3040454308a549a13a9354fa70d3a7c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1437
- [dep-dev: bump allure-rspec from 2.16.2 to 2.17.0](dependabot-gitlab/dependabot@a4afdceb317b01c2dad80df02d37d5cdbe631b2a) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1438

### 🛠️ Chore (3 changes)

- [Fix flaky configuration parser spec](dependabot-gitlab/dependabot@6f04c761c88a37dc5fbc4cf8280daeb319719d6e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1447
- [Add docker-compose deploy test](dependabot-gitlab/dependabot@c33aaae170494b00372ebb134b6c2f928bafcc81) by @andrcuns. See merge request dependabot-gitlab/dependabot!1444
- [Use factories for object fabrication in tests](dependabot-gitlab/dependabot@48199118f3277fdd9c3e90ec38c0eb3a48f277e9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1440

## 0.17.1 (2022-04-04)

### 🔬 Improvements (1 change)

- [Always evaluate private registries auth fields from environment variables](dependabot-gitlab/dependabot@eab98234d5905e356311ab426ef2e84f5d46a68a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1434

### 🐞 Bug Fixes (1 change)

- [Add back log level rails config](dependabot-gitlab/dependabot@bd76e1fcb22667393c409741ef1dd73bdc26e66a) by @andrcuns. See merge request dependabot-gitlab/dependabot!1436

## 0.17.0 (2022-04-04)

### 🐞 Bug Fixes (5 changes)

- [Allow replaces-base key in registries configuration](dependabot-gitlab/dependabot@b44838259fb4adcea927bdae8726bc3e85413cd4) by @andrcuns. See merge request dependabot-gitlab/dependabot!1433
- [Correctly close obsolete merge requests](dependabot-gitlab/dependabot@d347d072ac74668b2e732aded409178811ed3f50) by @andrcuns. See merge request dependabot-gitlab/dependabot!1429
- [Correctly handle forked project webhooks](dependabot-gitlab/dependabot@151782c1a5335ddc61dc6401578a4fa82244b6dd) by @andrcuns. See merge request dependabot-gitlab/dependabot!1418
- [Correctly handle obsolete mr closing for forks](dependabot-gitlab/dependabot@5bbc0e713c55ad5ecb93e679efa7d57d7978677e) by @andrcuns. See merge request dependabot-gitlab/dependabot!1417
- [Rebase fork merge requests on no conflicts](dependabot-gitlab/dependabot@de093bf39e9a4f4fd334409cf4efdc25d45924c8) by @andrcuns. See merge request dependabot-gitlab/dependabot!1414

### 📦 Dependency updates (12 changes)

- [dep: bump mongoid from 7.3.4 to 7.4.0](dependabot-gitlab/dependabot@c1614fcc173985a84d42770d583e658c02d9dc6d) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1427
- [dep: bump puma from 5.6.2 to 5.6.4](dependabot-gitlab/dependabot@f55f1777917c2139d467eba745e8a0f4778bc995) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1428
- [dep: bump lograge from 0.11.2 to 0.12.0](dependabot-gitlab/dependabot@5f43541012ac0e9f5bca2a37b6d75fc33801142e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1426
- [dep: bump dependabot-omnibus from 0.180.1 to 0.180.2](dependabot-gitlab/dependabot@2a8e48cec2e3bd14ac28eb44059d1304892eac69) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1424
- [[BREAKING] dep: bump dependabot/dependabot-core from 0.180.0 to 0.180.1](dependabot-gitlab/dependabot@2468d28c80d045a40022020bdef610b0673599da) by @andrcuns. See merge request dependabot-gitlab/dependabot!1423
- [dep-dev: bump docker from 20.10.13 to 20.10.14 in /.gitlab/docker/ci](dependabot-gitlab/dependabot@e1d66fdca9b4eaac427b021f43f53dd43f992282) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1422
- [dep-dev: bump rubocop from 1.26.0 to 1.26.1](dependabot-gitlab/dependabot@afb0a7a77c073f7d52f63be382ad0531b5185cec) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1420
- [dep: bump dependabot-omnibus from 0.179.0 to 0.180.0](dependabot-gitlab/dependabot@ed30a525d5d7b908ca91b74585256c6267de1121) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1408
- [dep: bump sentry-rails, sentry-ruby and sentry-sidekiq](dependabot-gitlab/dependabot@89b25b2708bb539018eb1f6de8a6188b5c7719cc) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1409
- [dep-dev: bump rubocop-rails from 2.14.1 to 2.14.2](dependabot-gitlab/dependabot@059a738877bad49be18fe2b5536e29a29f5f0cfe) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1412
- [dep: bump dependabot-omnibus from 0.178.1 to 0.179.0](dependabot-gitlab/dependabot@625676825ac402ff5622ebc5b4a1ddacb620a86c) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1401
- [dep-dev: bump rubocop-rails from 2.14.0 to 2.14.1](dependabot-gitlab/dependabot@aa6537b8d9ca73077695cc365bd1ee78ec4b0838) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1402

### 🔧 CI changes (2 changes)

- [Fix pipeline definitions for forked projects](dependabot-gitlab/dependabot@ba16ce5c7d3257e5c96249a08b4e342654f5c399) by @andrcuns. See merge request dependabot-gitlab/dependabot!1416
- [Run all tests in parallel in single stage](dependabot-gitlab/dependabot@3a553c02cb3b8641de1d50fffa28cf2bca996150) by @andrcuns. See merge request dependabot-gitlab/dependabot!1415

### 🛠️ Chore (6 changes)

- [Capitalise rake task descriptions](dependabot-gitlab/dependabot@f5ae611209cc5739cedef566ae8350d76e050efa) by @andrcuns.
- [Mr update system spec](dependabot-gitlab/dependabot@f11f45e92597636368cd85cd8554d9dec58615cd) by @andrcuns. See merge request dependabot-gitlab/dependabot!1432
- [Improve system test coverage](dependabot-gitlab/dependabot@ec5ac69b9d961ae6661180671a71c2b9a886b365) by @andrcuns. See merge request dependabot-gitlab/dependabot!1431
- [Add tags for test reports](dependabot-gitlab/dependabot@ca63e1ee058a63e3cb9579fdb3dffdec22dafecc) by @andrcuns. See merge request dependabot-gitlab/dependabot!1430
- [Add system test setup](dependabot-gitlab/dependabot@7200a87f2b632bfd11b16c563703a30d55f3e4a4) by @andrcuns. See merge request dependabot-gitlab/dependabot!1419
- [Extract dependabot configuration in to separate model](dependabot-gitlab/dependabot@315fd495659ac030f9ccf345d5676e839c67aedc) by @andrcuns. See merge request dependabot-gitlab/dependabot!1404

## 0.16.0 (2022-03-16)

### 🚀 New features (2 changes)

- [Close obsolete merge requests if dependency is up to date](dependabot-gitlab/dependabot@6f643a388283d2e1d6401175643780cb4e99be3f) by @andrcuns. See merge request dependabot-gitlab/dependabot!1398
- [[BREAKING] Add option to rebase mr on approval event](dependabot-gitlab/dependabot@bb1d11441069c6c7d355ed62c24646906f6ca211) by @andrcuns. See merge request dependabot-gitlab/dependabot!1395

### 🔬 Improvements (2 changes)

- [Add link to open mr list](dependabot-gitlab/dependabot@9a49e65c85ee32eef48239392ed35a3469336f24) by @andrcuns. See merge request dependabot-gitlab/dependabot!1388
- [Include group milestones in milestone search](dependabot-gitlab/dependabot@8b5b866d5d638438aafbcd2b2eefe19e1f8ddb62) by @andrcuns. See merge request dependabot-gitlab/dependabot!1387

### 🐞 Bug Fixes (3 changes)

- [Improve poor load speed of open merge requests links](dependabot-gitlab/dependabot@f2bc80cf5518f0c6e080fd489c9273aaa7607125) by @andrcuns. See merge request dependabot-gitlab/dependabot!1400
- [Correctly update project fork attributes](dependabot-gitlab/dependabot@68c289fe3329ee2ba0be92b86e8c6249af937ab2) by @andrcuns. See merge request dependabot-gitlab/dependabot!1393
- [Use correct url for open merge requests link](dependabot-gitlab/dependabot@f90235f3f7a21788e7f9a5a689da708667335817) by @andrcuns. See merge request dependabot-gitlab/dependabot!1391

### 📦 Dependency updates (2 changes)

- [dep-dev: bump rubocop-rails from 2.13.2 to 2.14.0](dependabot-gitlab/dependabot@b0a39e08484f127eba2925622c9ed6783560fd13) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1399
- [dep: bump dependabot-omnibus from 0.178.0 to 0.178.1](dependabot-gitlab/dependabot@521acd73aa76e033c1db10d6905e35eb6f651f43) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1396

### 🛠️ Chore (2 changes)

- [Pass auto-merge option to pull request creator](dependabot-gitlab/dependabot@19ff4c5a11b4eb02595bf8c71aa026a98d4e9be1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1390
- [Load updated rails defaults](dependabot-gitlab/dependabot@c2d8e3866b82c2e36bb9fdcb50fb2e96ee1a58c9) by @andrcuns. See merge request dependabot-gitlab/dependabot!1389

## 0.15.3 (2022-03-12)

### 🐞 Bug Fixes (1 change)

- [Count only unique merge requests towards mr limit](dependabot-gitlab/dependabot@64e16dbdbcb7be9fd001217cd405ba484726fa91) by @andrcuns. See merge request dependabot-gitlab/dependabot!1386

### 📦 Dependency updates (14 changes)

- [dep: bump anyway_config from 2.2.3 to 2.3.0](dependabot-gitlab/dependabot@385f10667fa890473d975ac519d47f0174eb40e4) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1384
- [dep-dev: bump docker from 20.10.12 to 20.10.13 in /.gitlab/docker/ci](dependabot-gitlab/dependabot@862beecc18f66d1c8819047563e6b02d9ac4db6e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1383
- [dep: bump dependabot-omnibus from 0.177.0 to 0.178.0](dependabot-gitlab/dependabot@79653ae7d61699136a70211156c553c4952e22c0) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1381
- [dep-dev: bump rubocop from 1.25.1 to 1.26.0](dependabot-gitlab/dependabot@34a9dab3853819d904af7803ec2c7d7e3bb9e323) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1379
- [dep-dev: bump allure-rspec from 2.16.1 to 2.16.2](dependabot-gitlab/dependabot@683501a848b9aee7c123ce151fc947d8ce019626) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1380
- [dep: bump sentry-ruby, sentry-rails, rails and sentry-sidekiq](dependabot-gitlab/dependabot@c231c9f82f91430520af36931c7b67956d96dcf2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1377
- [dep: bump bootsnap from 1.10.3 to 1.11.1](dependabot-gitlab/dependabot@2f8dc8f7af286dd4a2f7ed0e44c1234427a413ed) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1374
- [dep: bump rails from 7.0.2.2 to 7.0.2.3](dependabot-gitlab/dependabot@78c3c6fede9dfa41136e13f33379ed546eedb283) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1375
- [dep-dev: bump rspec-rails from 5.1.0 to 5.1.1](dependabot-gitlab/dependabot@e4011e94a888ee20a4dd5a9ac561a9ac7ab718cb) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1373
- [dep-dev: bump faker from 2.19.0 to 2.20.0](dependabot-gitlab/dependabot@697abcb75d1c020f900cfe8544163e5d34c5bc29) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1372
- [dep-dev: bump rubocop-performance from 1.13.2 to 1.13.3](dependabot-gitlab/dependabot@f855c51c61d0ad9a38f0877b5caca45d453b6570) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1371
- [dep: bump dependabot-omnibus from 0.176.0 to 0.177.0](dependabot-gitlab/dependabot@c3cae6e524c38ddca6ad01400dd7f45bbc34e430) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1369
- [dep: bump dependabot-omnibus from 0.175.0 to 0.176.0](dependabot-gitlab/dependabot@91e44955c16d9a666cb5c174dc8f784e4722227e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1366
- [dep-dev: bump rubocop-rspec from 2.8.0 to 2.9.0](dependabot-gitlab/dependabot@5b403a3d00259f60e85a8ee244eb32bc1328df6f) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1365

### 🔧 CI changes (1 change)

- [Bump ci dind image to 20.10.13](dependabot-gitlab/dependabot@ea4b162650e5b6741f5e7b71596a2775915a6554) by @andrcuns. See merge request dependabot-gitlab/dependabot!1385

### 📄 Documentation updates (1 change)

- [Document configuration default values](dependabot-gitlab/dependabot@82fef2543f9de31c8374f53fd2a3e3a367a81dd1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1368

## 0.15.2 (2022-02-28)

### 🔬 Improvements (2 changes)

- [Add colorized logs](dependabot-gitlab/dependabot@856f33c95bf68df6c304b2a231210d8b5c3a9f98) by @andrcuns. See merge request dependabot-gitlab/dependabot!1363
- [Log to error on shared helpers subprocess failure](dependabot-gitlab/dependabot@2d5723e85a7a0dbb1bcff4f437a49c263a683fe7) by @andrcuns. See merge request dependabot-gitlab/dependabot!1345

### 🐞 Bug Fixes (2 changes)

- [Correctly convert config entry after rails upgrade](dependabot-gitlab/dependabot@065ea148409999fb906821ebfbab945dbae08c0c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1361
- [Correctly handle mrs without conflict status present](dependabot-gitlab/dependabot@100d99fd6f910a2f6d287ab31440278ba2c4616c) by @andrcuns. See merge request dependabot-gitlab/dependabot!1358

### 📦 Dependency updates (5 changes)

- [dep: bump rails from 6.1.4.6 to 7.0.2.2](dependabot-gitlab/dependabot@662ba575dfa156a147f7210df59ac6d34fd79686) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1361
- [dep: bump dependabot-omnibus from 0.174.1 to 0.175.0.](dependabot-gitlab/dependabot@01795b0ea4c0821db45f518dd2667a054d99e3a3) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1353
- [dep: bump rails from 6.1.4.6 to 7.0.2.2](dependabot-gitlab/dependabot@aa7e51a7027baa0023b0a13045ed769488823a2e) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1350
- [dep: bump dependabot-omnibus from 0.174.0 to 0.174.1](dependabot-gitlab/dependabot@dd9aae64ee55ec1a26b2fcd6f7c54ea6a0988250) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1346
- [dep: bump mongoid from 7.3.3 to 7.3.4](dependabot-gitlab/dependabot@5d3b9c8917d298d9911ac827eececf7ef82c2de2) by @dependabot-bot. See merge request dependabot-gitlab/dependabot!1347

### 🔧 CI changes (1 change)

- [Remove test image usage](dependabot-gitlab/dependabot@9ae1a946977c04785d0b5f8b6f826ef1c0e12aaa) by @andrcuns. See merge request dependabot-gitlab/dependabot!1357

### 🛠️ Chore (3 changes)

- [Adjust log message padding](dependabot-gitlab/dependabot@573b3f82726aeba67d0bba399cb2a75b0caa0e81) by @andrcuns. See merge request dependabot-gitlab/dependabot!1364
- [Add spec for configuration fetching](dependabot-gitlab/dependabot@ffa8d90d7813a153e53d9bfa0cd8f9245b1a1b5b) by @andrcuns. See merge request dependabot-gitlab/dependabot!1360
- [Add SECRET_KEY_BASE env variable for docker-compose.yml](dependabot-gitlab/dependabot@6a854b60d08bdb964f084348099088f010fe4193) by @andrcuns.

### 📄 Documentation updates (1 change)

- [Document missing configuration environment variables](dependabot-gitlab/dependabot@77770a05c2ec9219dc1e4575c6ea734ab20c1d92) by @andrcuns. See merge request dependabot-gitlab/dependabot!1362

## 0.15.1 (2022-02-21)

### 🐞 Bug Fixes (1 change)

- [Correctly remove credentials from SharedHelpers debug log messages](dependabot-gitlab/dependabot@f592a438d71e6b6c80302049273e6b5052f3f2b1) by @andrcuns. See merge request dependabot-gitlab/dependabot!1344

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
