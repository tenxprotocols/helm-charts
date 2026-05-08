{{/*
Expand the name of the chart.
*/}}
{{- define "juicefs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name (truncated to 63 chars per K8s DNS rules).
*/}}
{{- define "juicefs.fullname" -}}
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
Chart name + version label.
*/}}
{{- define "juicefs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "juicefs.labels" -}}
helm.sh/chart: {{ include "juicefs.chart" . }}
{{ include "juicefs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "juicefs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "juicefs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "juicefs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "juicefs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Container image with optional global registry override.
*/}}
{{- define "juicefs.image" -}}
{{- $registry := .Values.global.imageRegistry | default "" -}}
{{- $tag := .Values.image.tag | default (printf "ce-v%s" .Chart.AppVersion) -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry .Values.image.repository $tag }}
{{- else -}}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end -}}
{{- end }}

{{/*
Image pull secrets, merging global and local.
*/}}
{{- define "juicefs.imagePullSecrets" -}}
{{- $secrets := concat (.Values.global.imagePullSecrets | default list) (.Values.imagePullSecrets | default list) -}}
{{- if $secrets }}
imagePullSecrets:
  {{- toYaml $secrets | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Postgres connection helpers — resolve subchart values, fall back to inline metadata.postgres.*

Note: this mirrors the postgres subchart's own fullname template logic for the
common case. If the user sets postgres.fullnameOverride or postgres.nameOverride
on the subchart, they should also set metadata.postgres.host explicitly.
*/}}
{{- define "juicefs.postgres.fullname" -}}
{{- $name := "postgres" -}}
{{- if contains $name .Release.Name -}}
  {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
  {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end }}

{{- define "juicefs.postgres.host" -}}
{{- if .Values.metadata.postgres.host -}}
  {{- .Values.metadata.postgres.host -}}
{{- else if .Values.postgres.enabled -}}
  {{- include "juicefs.postgres.fullname" . -}}
{{- else -}}
  {{- fail "juicefs: metadata.postgres.host is required when postgres.enabled is false" -}}
{{- end -}}
{{- end }}

{{- define "juicefs.postgres.database" -}}
{{- if .Values.metadata.postgres.database -}}
  {{- .Values.metadata.postgres.database -}}
{{- else -}}
  {{- .Values.postgres.auth.database -}}
{{- end -}}
{{- end }}

{{- define "juicefs.postgres.username" -}}
{{- if .Values.metadata.postgres.username -}}
  {{- .Values.metadata.postgres.username -}}
{{- else -}}
  {{- .Values.postgres.auth.username -}}
{{- end -}}
{{- end }}

{{- define "juicefs.postgres.passwordSecret.name" -}}
{{- if .Values.metadata.postgres.passwordSecret.name -}}
  {{- .Values.metadata.postgres.passwordSecret.name -}}
{{- else if .Values.postgres.auth.existingSecret -}}
  {{- .Values.postgres.auth.existingSecret -}}
{{- else if .Values.postgres.enabled -}}
  {{- include "juicefs.postgres.fullname" . -}}
{{- else -}}
  {{- fail "juicefs: metadata.postgres.passwordSecret.name is required when postgres.enabled is false" -}}
{{- end -}}
{{- end }}

{{/*
Object storage Secret name resolution.
*/}}
{{- define "juicefs.objectStorage.secretName" -}}
{{- if .Values.objectStorage.existingSecret -}}
  {{- .Values.objectStorage.existingSecret -}}
{{- else -}}
  {{- printf "%s-object-storage" (include "juicefs.fullname" .) -}}
{{- end -}}
{{- end }}

{{/*
Gateway auth Secret name resolution.
*/}}
{{- define "juicefs.gatewayAuth.secretName" -}}
{{- if .Values.gatewayAuth.existingSecret -}}
  {{- .Values.gatewayAuth.existingSecret -}}
{{- else -}}
  {{- printf "%s-gateway-auth" (include "juicefs.fullname" .) -}}
{{- end -}}
{{- end }}

{{/*
Validate that we have a path to a non-empty postgres password.
Render-time failure is far better than discovering an empty-password
URL at pod-start time.
*/}}
{{- define "juicefs.validatePostgresPassword" -}}
{{- if not .Values.metadata.postgres.passwordSecret.name -}}
  {{- if .Values.postgres.enabled -}}
    {{- if and (not .Values.postgres.auth.password) (not .Values.postgres.auth.existingSecret) -}}
      {{- fail "juicefs: postgres.auth.password or postgres.auth.existingSecret must be set when postgres.enabled (or override metadata.postgres.passwordSecret.name)" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end }}

{{/*
Validate that sslmode matches the postgres subchart's TLS setting.
postgres.tls.enabled=true with sslmode=disable would silently use unencrypted
connections, defeating the TLS configuration.
*/}}
{{- define "juicefs.validateSslmode" -}}
{{- if and .Values.postgres.enabled .Values.postgres.tls.enabled (eq .Values.metadata.postgres.sslmode "disable") -}}
  {{- fail "juicefs: postgres.tls.enabled=true requires metadata.postgres.sslmode != 'disable'. Set sslmode to 'require' (encrypted, no cert verification) or 'verify-full' (with PGSSLROOTCERT configured via extraEnv)." -}}
{{- end -}}
{{- end }}
