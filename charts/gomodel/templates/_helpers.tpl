{{/*
Expand the name of the chart.
*/}}
{{- define "gomodel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gomodel.fullname" -}}
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
{{- define "gomodel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gomodel.labels" -}}
helm.sh/chart: {{ include "gomodel.chart" . }}
{{ include "gomodel.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gomodel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gomodel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gomodel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gomodel.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the image name including global registry override
*/}}
{{- define "gomodel.image" -}}
{{- $registry := .Values.global.imageRegistry | default "" -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end -}}
{{- end }}

{{/*
Return the list of image pull secrets, merging global and local
*/}}
{{- define "gomodel.imagePullSecrets" -}}
{{- $secrets := concat (.Values.global.imagePullSecrets | default list) (.Values.imagePullSecrets | default list) -}}
{{- if $secrets }}
imagePullSecrets:
  {{- toYaml $secrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Name of the ConfigMap holding non-sensitive environment variables.
*/}}
{{- define "gomodel.configMapName" -}}
{{- .Values.existingConfigMap | default (include "gomodel.fullname" .) }}
{{- end }}

{{/*
Name of the Secret holding sensitive environment variables.
*/}}
{{- define "gomodel.secretName" -}}
{{- .Values.existingSecret | default (include "gomodel.fullname" .) }}
{{- end }}

{{/*
Redis-compatible cache URL: explicit cache.redisUrl wins, otherwise the
bundled valkey subchart service when enabled.
*/}}
{{- define "gomodel.redisUrl" -}}
{{- if .Values.cache.redisUrl }}
{{- .Values.cache.redisUrl }}
{{- else if .Values.valkey.enabled }}
{{- printf "redis://%s-valkey:6379" .Release.Name }}
{{- end }}
{{- end }}
