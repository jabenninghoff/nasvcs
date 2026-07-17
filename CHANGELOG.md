# Changelog

## [1.0.1](https://github.com/jabenninghoff/nasvcs/compare/v1.0.0...v1.0.1) (2026-07-17)


### Bug Fixes

* update lighttpd from 1.4.82 to 1.4.85 ([df5dc3c](https://github.com/jabenninghoff/nasvcs/commit/df5dc3c0ea8b05a02f42b2e2e9514bfc9ff97672))

## 1.0.0 (2026-07-15)


### Features

* add CVS web support using ViewVC ([0eede32](https://github.com/jabenninghoff/nasvcs/commit/0eede32f17d2b8481f0ef78b16d0c5fa1e0bc084))
* add packages ([2d4ff77](https://github.com/jabenninghoff/nasvcs/commit/2d4ff77994e4b2ec1c105522ed72c0fd3f9e8826))
* baseline Docker implementation ([218645b](https://github.com/jabenninghoff/nasvcs/commit/218645b300ea08dc72cba442cad5a8a35b5d98b7))
* configure basic OpenSSH server ([4027349](https://github.com/jabenninghoff/nasvcs/commit/4027349fabe1add9b93329ae48f4e67c01e5281f))
* implement ssh based cvs, git server ([9ae856b](https://github.com/jabenninghoff/nasvcs/commit/9ae856b2bce67acbf62ece37bf2a0d0a976e1df7))
* initial gitweb implementation using lighttpd ([2a6d8eb](https://github.com/jabenninghoff/nasvcs/commit/2a6d8ebb0b54cf92dc6fb78d3e232ad16adbb578))
* require authentication for gitweb and viewvc ([ddac091](https://github.com/jabenninghoff/nasvcs/commit/ddac091b6351e95e9052a712bb63831ad117f426))


### Bug Fixes

* additional (security) copilot fixes ([bbfdde1](https://github.com/jabenninghoff/nasvcs/commit/bbfdde16dfced6b75b8f99c1f18c9160269de19c))
* adopt copilot suggested improvements ([98a16fe](https://github.com/jabenninghoff/nasvcs/commit/98a16fe06b207c7136a8b520d179b0be10f0e080))
* apply patch to fix spurious viewvc errors ([cba2904](https://github.com/jabenninghoff/nasvcs/commit/cba290496b913f5adc441c156c2105e5fedf3ca9))
* bump actions/attest from 4.1.0 to 4.1.1 ([cd12b2c](https://github.com/jabenninghoff/nasvcs/commit/cd12b2c9629d5eeeaf1111adddaecf4816697307))
* bump docker/build-push-action from 7.2.0 to 7.3.0 ([049ba1a](https://github.com/jabenninghoff/nasvcs/commit/049ba1a11e5775c673f0a7edc2214ad84010cb0b))
* bump docker/login-action from 4.2.0 to 4.4.0 ([2996d94](https://github.com/jabenninghoff/nasvcs/commit/2996d943f0daae4a17460aece69872983e94daa9))
* bump docker/metadata-action from 6.1.0 to 6.2.0 ([9f84cc3](https://github.com/jabenninghoff/nasvcs/commit/9f84cc3139e4bcf5e91c55c607736f9ac4787212))
* bump docker/setup-buildx-action from 4.1.0 to 4.2.0 ([c693a71](https://github.com/jabenninghoff/nasvcs/commit/c693a71a62e1ae24f77290faac3a729360884e59))
* bump docker/setup-qemu-action from 4.1.0 to 4.2.0 ([30e6acd](https://github.com/jabenninghoff/nasvcs/commit/30e6acdfcf8876c4985a7cd9b1d89f0944a740d4))
* check viewvc sha256 ([119ba7e](https://github.com/jabenninghoff/nasvcs/commit/119ba7e29352888c7cee9767ac7bfd7845506e6d))
* patch non-interactively per Copilot ([bdd94a2](https://github.com/jabenninghoff/nasvcs/commit/bdd94a27c397f3854c8b8382d25dc8d6c8231c95))
* refactor Docker baseline ([ae215b7](https://github.com/jabenninghoff/nasvcs/commit/ae215b787cfb8f27b5e628a69317649e2591560a))
* remove deny logic preventing file views ([c11e863](https://github.com/jabenninghoff/nasvcs/commit/c11e863d9e673f134cab19ae5ec187e62a0e1302))
* start with empty CHANGELOG ([7ac3683](https://github.com/jabenninghoff/nasvcs/commit/7ac368340f31082c9612cc7c19b0d680d7f57bdd))
* switch to single vcs volume ([c372835](https://github.com/jabenninghoff/nasvcs/commit/c372835f09dd8cdcffb6fa3fa00c8b7eacad667f))
* update alpine package dependencies ([413eaac](https://github.com/jabenninghoff/nasvcs/commit/413eaacb2432b467ed4fec943c6f83a67fa3f570))
* update ViewVC template and configuration ([93b7bbb](https://github.com/jabenninghoff/nasvcs/commit/93b7bbba54c354b23881cf3b3f1e170586aad05b))
* warn on empty or missing git projectroot ([ecb0ff8](https://github.com/jabenninghoff/nasvcs/commit/ecb0ff8b83cd23ae10b74c8f2c9307357f274172))
* workaround for missing hyperlinks in ViewVC ([f200b75](https://github.com/jabenninghoff/nasvcs/commit/f200b7591470003c8d9f606d14cb7209c01d2401))
