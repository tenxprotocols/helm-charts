# heimdall-bot

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

Heimdall — TenX Slack AI assistant (cluster investigation, on-chain lookups, Drive docs).

## Usage

```bash
helm install heimdall-bot oci://ghcr.io/tenxprotocols/helm-charts/heimdall-bot --version 0.1.0 \
  --set serviceAccount.gsaEmail=heimdall-bot@<project>.iam.gserviceaccount.com
```

The chart expects an existing Kubernetes Secret (see `existingSecret`, default
`heimdall-bot-secret`) in the release namespace with the keys:

- `SLACK_BOT_TOKEN`
- `SLACK_APP_TOKEN`
- `ANTHROPIC_API_KEY`
- `ETHERSCAN_API_KEY`

The ServiceAccount created by this chart is named after the release (so it
can be referenced by a Workload Identity binding managed in terraform) and
gets the `iam.gke.io/gcp-service-account` annotation when
`serviceAccount.gsaEmail` is set.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| tenxprotocols | <software@tenx.inc> | <https://github.com/tenxprotocols> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| existingSecret | string | `"heimdall-bot-secret"` | Name of an existing Secret with SLACK_BOT_TOKEN, SLACK_APP_TOKEN, ANTHROPIC_API_KEY, ETHERSCAN_API_KEY. |
| holmes.model | string | `"claude-sonnet"` | Model HolmesGPT uses for cluster investigations |
| holmes.url | string | `"http://robusta-holmes.obs.svc.cluster.local"` | URL of the in-cluster HolmesGPT service |
| image.repository | string | `"ghcr.io/tenxprotocols/heimdall-bot"` | Image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[]` | Image pull secrets for the private ghcr.io image, e.g. `[{name: ghcr-tenx}]` |
| logLevel | string | `"INFO"` | Application log level |
| model | string | `"claude-sonnet-5"` | Anthropic model used by the bot |
| podAnnotations | object | `{}` | Extra annotations to add to the pod template |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"256Mi"` |  |
| serviceAccount.gsaEmail | string | `""` | GSA email for Workload Identity (Drive access); annotation omitted if empty |
| streaming | bool | `true` | Enable streaming responses in Slack |
