# Changelog

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
