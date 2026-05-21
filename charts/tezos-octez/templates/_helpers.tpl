{{/*
Expand the name of the chart.
*/}}
{{- define "tezos-octez.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tezos-octez.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tezos-octez.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tezos-octez.labels" -}}
helm.sh/chart: {{ include "tezos-octez.chart" . }}
{{ include "tezos-octez.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tezos-octez.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tezos-octez.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Node selector labels
*/}}
{{- define "tezos-octez.nodeSelectorLabels" -}}
{{ include "tezos-octez.selectorLabels" . }}
app.kubernetes.io/component: node
{{- end }}

{{/*
Baker selector labels
*/}}
{{- define "tezos-octez.bakerSelectorLabels" -}}
{{ include "tezos-octez.selectorLabels" . }}
app.kubernetes.io/component: baker
{{- end }}

{{/*
Accuser selector labels
*/}}
{{- define "tezos-octez.accuserSelectorLabels" -}}
{{ include "tezos-octez.selectorLabels" . }}
app.kubernetes.io/component: accuser
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tezos-octez.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tezos-octez.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Node fully qualified name
*/}}
{{- define "tezos-octez.nodeFullname" -}}
{{- printf "%s-node" (include "tezos-octez.fullname" .) }}
{{- end }}

{{/*
Baker fully qualified name
*/}}
{{- define "tezos-octez.bakerFullname" -}}
{{- printf "%s-baker" (include "tezos-octez.fullname" .) }}
{{- end }}

{{/*
Accuser fully qualified name
*/}}
{{- define "tezos-octez.accuserFullname" -}}
{{- printf "%s-accuser" (include "tezos-octez.fullname" .) }}
{{- end }}

{{/*
DAL node fully qualified name
*/}}
{{- define "tezos-octez.dalFullname" -}}
{{- printf "%s-dal" (include "tezos-octez.fullname" .) }}
{{- end }}

{{/*
DAL node selector labels
*/}}
{{- define "tezos-octez.dalSelectorLabels" -}}
{{ include "tezos-octez.selectorLabels" . }}
app.kubernetes.io/component: dal
{{- end }}

{{/*
Signatory base URL — includes auth alias as username when auth is configured.
Usage: {{ include "tezos-octez.signatoryUrl" . }}
*/}}
{{- define "tezos-octez.signatoryUrl" -}}
{{- if .Values.signatory.auth.secretKey -}}
{{- .Values.signatory.endpoint | replace "://" "://signatory_auth@" -}}
{{- else -}}
{{- .Values.signatory.endpoint -}}
{{- end -}}
{{- end }}
