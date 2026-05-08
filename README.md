# TenX Helm Charts

A collection of Helm charts maintained by [TenX](https://github.com/tenxprotocols).

## Charts

| Chart | Description |
|-------|-------------|
| [chartdb](charts/chartdb) | Open-source database diagram editor |
| [http-exporter](charts/http-exporter) | A flexible OpenMetrics exporter for HTTP (RPC and REST) endpoints |
| [juicefs](charts/juicefs) | JuiceFS S3 Gateway with PostgreSQL metadata engine |
| [signatory](charts/signatory) | A Helm chart for Signatory - a Tezos Remote Signer |

## Usage

### OCI Registry (recommended)

Charts are published to the GitHub Container Registry as OCI artifacts.

```bash
helm install my-release oci://ghcr.io/tenxprotocols/helm-charts/<chart-name> --version <version>
```

### Helm Repository

Charts are also available via a traditional Helm repository hosted on GitHub Pages.

```bash
helm repo add tenx https://tenxprotocols.github.io/helm-charts
helm repo update
helm install my-release tenx/<chart-name>
```
