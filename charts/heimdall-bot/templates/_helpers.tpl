{{/*
Expand the name of the chart.
*/}}
{{- define "heimdall-bot.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified app name. Fixed to the release name (no
nameOverride/fullnameOverride support) so the ServiceAccount name is
predictable for Workload Identity bindings set up in terraform.
*/}}
{{- define "heimdall-bot.fullname" -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "heimdall-bot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "heimdall-bot.labels" -}}
app.kubernetes.io/name: {{ include "heimdall-bot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "heimdall-bot.chart" . }}
{{- end -}}
