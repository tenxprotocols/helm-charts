# Changelog

## [3.0.1](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v3.0.0...tezos-octez-v3.0.1) (2026-05-16)


### Bug Fixes

* **tezos-octez:** set fsGroup on DAL statefulset for PVC writability ([4fc2adf](https://github.com/tenxprotocols/helm-charts/commit/4fc2adff52fa572603a03e87bcdb65f0bedbec90))

## [3.0.0](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.1.5...tezos-octez-v3.0.0) (2026-05-16)


### ⚠ BREAKING CHANGES

* **tezos-octez:** appVersion bumped from octez-v24.2 to octez-v24.4. Users who don't override `node.image.tag` / `baker.image.tag` / `dal.image.tag` will see the default image tag change. Pods using chart defaults will roll on next reconcile.

### Features

* **tezos-octez:** support inline network config for community testnets ([687b978](https://github.com/tenxprotocols/helm-charts/commit/687b9787cb9f0cdbfb126219f3d953e23772f6ec))

## [2.1.5](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.1.4...tezos-octez-v2.1.5) (2026-04-30)


### Bug Fixes

* **tezos-octez:** remove dead baker metrics plumbing ([0256981](https://github.com/tenxprotocols/helm-charts/commit/02569815f7f7279c49aa5cebfe3d048d6bf5eb05))

## [2.1.4](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.1.3...tezos-octez-v2.1.4) (2026-04-30)


### Bug Fixes

* **tezos-octez:** add metrics address flag to baker deployment ([3e30b91](https://github.com/tenxprotocols/helm-charts/commit/3e30b911b04cf6f51b340de9f77b3a809c168f8c))

## [2.1.3](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.1.2...tezos-octez-v2.1.3) (2026-03-18)


### Bug Fixes

* **dal:** add restart wrapper to avoid CrashLoopBackOff ([159f2e9](https://github.com/tenxprotocols/helm-charts/commit/159f2e9ca33610a6fdb3410a7c2bfdbb1126f3cb))

## [2.1.2](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.1.1...tezos-octez-v2.1.2) (2026-03-12)


### Bug Fixes

* **client-keys-secret:** skip duplicate DAL profile addresses already in keys ([5760b5c](https://github.com/tenxprotocols/helm-charts/commit/5760b5c273ec1f3afdf5e30cba72d511d9926284))

## [2.1.1](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.1.0...tezos-octez-v2.1.1) (2026-03-12)


### Bug Fixes

* **tezos-octez:** add timeout to wget in node sync check ([8db9e7f](https://github.com/tenxprotocols/helm-charts/commit/8db9e7f017d5be729945aa50b0e8701372d822f7))
* **tezos-octez:** pass consensus and companion key aliases to baker ([8b4d549](https://github.com/tenxprotocols/helm-charts/commit/8b4d5499d35106831636d99717b7996248b28185))

## [2.1.0](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.0.2...tezos-octez-v2.1.0) (2026-03-12)


### Features

* **tezos-octez:** add consensus and companion public key support ([867bfc3](https://github.com/tenxprotocols/helm-charts/commit/867bfc371ad99041fc9ff19a5927c6ca1aea815e))

## [2.0.2](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.0.1...tezos-octez-v2.0.2) (2026-03-12)


### Bug Fixes

* **tezos-octez:** include baker public key in public_keys and reduce sync wait ([8814d59](https://github.com/tenxprotocols/helm-charts/commit/8814d5937d8fbd3a3265f056eb5224c22c800483))

## [2.0.1](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v2.0.0...tezos-octez-v2.0.1) (2026-03-12)


### Bug Fixes

* **tezos-octez:** only include keys with known public keys in public_keys file ([df8e86d](https://github.com/tenxprotocols/helm-charts/commit/df8e86d3ca4d720d976b8ac9fc4c4453b777db3e))

## [2.0.0](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v1.0.1...tezos-octez-v2.0.0) (2026-03-12)


### ⚠ BREAKING CHANGES

* **tezos-octez:** replace init-container key import with pre-rendered Secret

### Code Refactoring

* **tezos-octez:** replace init-container key import with pre-rendered Secret ([af61b47](https://github.com/tenxprotocols/helm-charts/commit/af61b472a3371991eb13fea13f20e6d78649195f))

## [1.0.1](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v1.0.0...tezos-octez-v1.0.1) (2026-03-12)


### Bug Fixes

* **tezos-octez:** replace hyphens with underscores in signatory auth alias ([491286f](https://github.com/tenxprotocols/helm-charts/commit/491286f3b5eabd7641c0a5fd729f434543dc1150))

## [1.0.0](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.3.1...tezos-octez-v1.0.0) (2026-03-12)


### ⚠ BREAKING CHANGES

* **tezos-octez:** add signatory auth, multi-key import, and DAL attester support

### Features

* **tezos-octez:** add signatory auth, multi-key import, and DAL attester support ([df31d9a](https://github.com/tenxprotocols/helm-charts/commit/df31d9abc3cc52468220eba452b3ca17adf8058a))

## [0.3.1](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.3.0...tezos-octez-v0.3.1) (2026-03-11)


### Bug Fixes

* **tezos-octez:** add RPC ACL config with empty blacklist ([5c9d20d](https://github.com/tenxprotocols/helm-charts/commit/5c9d20dd027656cf3e5224b0af9ac3dac1904545))

## [0.3.0](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.2.5...tezos-octez-v0.3.0) (2026-03-11)


### Features

* **tezos-octez:** add DAL node StatefulSet and service support ([e91336e](https://github.com/tenxprotocols/helm-charts/commit/e91336e5ecf1f4e65434610969157d0edc27eb87))


### Bug Fixes

* **tezos-octez:** correct appVersion prefix and add dal disabled default ([192a360](https://github.com/tenxprotocols/helm-charts/commit/192a360cfcb2eec12796d63d99ea82a7745f035a))

## [0.2.5](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.2.4...tezos-octez-v0.2.5) (2026-03-11)


### Bug Fixes

* **tezos-octez:** use remote endpoint flag for octez-baker command ([1bd14b4](https://github.com/tenxprotocols/helm-charts/commit/1bd14b402122ed6b2afcf440402fa8c2cf02a2b7))

## [0.2.4](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.2.3...tezos-octez-v0.2.4) (2026-03-11)


### Bug Fixes

* **tezos-octez:** use protocol-agnostic octez-baker binary ([28454a3](https://github.com/tenxprotocols/helm-charts/commit/28454a35fd26209a4d4044af60598fc9e43b7c0d))

## [0.2.3](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.2.2...tezos-octez-v0.2.3) (2026-03-11)


### Bug Fixes

* **tezos-octez:** use shared emptyDir volume for snapshot tmp file ([28ad4a4](https://github.com/tenxprotocols/helm-charts/commit/28ad4a4e7afd1f0098e5564a0780170b1b9308b1))

## [0.2.2](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.2.1...tezos-octez-v0.2.2) (2026-03-11)


### Bug Fixes

* **tezos-octez:** replace hardcoded values with env vars in templates ([9f855a2](https://github.com/tenxprotocols/helm-charts/commit/9f855a28eaee152efa1dad94b28727dd6e2d32a8))

## [0.2.1](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.2.0...tezos-octez-v0.2.1) (2026-03-11)


### Bug Fixes

* **configmap:** simplify snapshot URL construction ([dde52c5](https://github.com/tenxprotocols/helm-charts/commit/dde52c5ec8d73f905d18d1badb90a6aafb6f669b))

## [0.2.0](https://github.com/tenxprotocols/helm-charts/compare/tezos-octez-v0.1.0...tezos-octez-v0.2.0) (2026-03-11)


### Features

* **tezos-octez:** add Helm chart for Tezos Octez node and baker ([30b4d28](https://github.com/tenxprotocols/helm-charts/commit/30b4d28a48918877d4964db6b596b649827da925))
* **tezos-octez:** add Helm chart for Tezos Octez node and baker ([#10](https://github.com/tenxprotocols/helm-charts/issues/10)) ([5d9e72c](https://github.com/tenxprotocols/helm-charts/commit/5d9e72c5ed61800942b3be31ab78e451f018e32b))
