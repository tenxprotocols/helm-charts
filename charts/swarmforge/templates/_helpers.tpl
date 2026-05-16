{{- define "swarmforge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "swarmforge.fullname" -}}
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

{{- define "swarmforge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "swarmforge.labels" -}}
helm.sh/chart: {{ include "swarmforge.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "swarmforge.componentName" -}}
{{- printf "%s-%s" .prefix .component | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "swarmforge.componentLabels" -}}
{{ include "swarmforge.labels" .context }}
app.kubernetes.io/name: {{ .component }}
app.kubernetes.io/instance: {{ .context.Values.global.namePrefix }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{- define "swarmforge.componentSelectorLabels" -}}
app.kubernetes.io/name: {{ .component }}
app.kubernetes.io/instance: {{ .context.Values.global.namePrefix }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{- define "swarmforge.postgresHost" -}}
{{- printf "%s-postgres" (include "swarmforge.fullname" .) }}
{{- end }}

{{- define "swarmforge.valkeyHost" -}}
{{- printf "%s-valkey" (include "swarmforge.fullname" .) }}
{{- end }}

{{- define "swarmforge.falkordbHost" -}}
{{- printf "%s-falkordb" (include "swarmforge.fullname" .) }}
{{- end }}

{{- define "swarmforge.postgresSecretName" -}}
{{- if .Values.postgres.auth.existingSecret }}
{{- .Values.postgres.auth.existingSecret }}
{{- else }}
{{- printf "%s-postgres" (include "swarmforge.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Resolve the web-facing ingress URL. Walks ingress.hosts looking for
a path whose service is "web" and returns https://host (or http:// if
no TLS covers that host).
*/}}
{{- define "swarmforge.webIngressUrl" -}}
{{- $url := "" }}
{{- if .Values.ingress.enabled }}
  {{- $tlsHosts := list }}
  {{- range .Values.ingress.tls }}
    {{- range .hosts }}
      {{- $tlsHosts = append $tlsHosts . }}
    {{- end }}
  {{- end }}
  {{- range .Values.ingress.hosts }}
    {{- $host := .host }}
    {{- range .paths }}
      {{- if eq .service "web" }}
        {{- if has $host $tlsHosts }}
          {{- $url = printf "https://%s" $host }}
        {{- else }}
          {{- $url = printf "http://%s" $host }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- $url }}
{{- end }}

{{/*
Common environment variables shared across all components.
DATABASE_URL uses $(POSTGRES_PASSWORD) variable expansion —
the POSTGRES_PASSWORD env var must appear before DATABASE_URL.
*/}}
{{- define "swarmforge.commonEnv" -}}
- name: NODE_ENV
  value: {{ .Values.global.env | quote }}
{{- if .Values.postgres.enabled }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "swarmforge.postgresSecretName" . }}
      key: password
- name: DATABASE_URL
  value: "postgresql://{{ .Values.postgres.auth.username }}:$(POSTGRES_PASSWORD)@{{ include "swarmforge.postgresHost" . }}:{{ .Values.postgres.service.port | default 5432 }}/{{ .Values.postgres.auth.database }}"
{{- end }}
{{- if .Values.valkey.enabled }}
- name: REDIS_URL
  value: "redis://{{ include "swarmforge.valkeyHost" . }}:{{ .Values.valkey.service.port | default 6379 }}"
{{- end }}
{{- if .Values.falkordb.enabled }}
- name: FALKORDB_URL
  value: "redis://{{ include "swarmforge.falkordbHost" . }}:{{ .Values.falkordb.service.port | default 6380 }}"
{{- end }}
{{- if .Values.bifrostUrl }}
- name: BIFROST_URL
  value: {{ .Values.bifrostUrl | quote }}
{{- end }}
{{- if .Values.solanaRpcUrl }}
- name: SOLANA_RPC_URL
  value: {{ .Values.solanaRpcUrl | quote }}
{{- end }}
{{- $webUrl := include "swarmforge.webIngressUrl" . }}
- name: BETTER_AUTH_URL
  value: {{ .Values.betterAuthUrl | default $webUrl | quote }}
- name: CORS_ORIGIN
  value: {{ .Values.corsOrigin | default $webUrl | quote }}
{{- range $key, $value := .Values.env }}
- name: {{ $key | quote }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{- define "swarmforge.imagePullSecrets" -}}
{{- with .Values.global.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
ServiceAccount name to use on the gateway + worker pods. Empty string when
neither serviceAccount.create nor serviceAccount.name is set (pod uses the
namespace `default`).
*/}}
{{- define "swarmforge.appServiceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (printf "%s-app" .Values.global.namePrefix) .Values.serviceAccount.name }}
{{- else }}
{{- .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
KMS env vars injected into gateway + worker. Emits nothing when
kms.provider is unset, preserving the pre-0.5 behavior.
*/}}
{{- define "swarmforge.kmsEnv" -}}
{{- if .Values.kms.provider }}
- name: KMS_PROVIDER
  value: {{ .Values.kms.provider | quote }}
{{- if eq .Values.kms.provider "local" }}
- name: KEK_LOCAL_PATH
  value: {{ printf "%s/%s" .Values.kms.local.mountDir .Values.kms.local.fileName | quote }}
{{- else if eq .Values.kms.provider "gcp" }}
- name: GCP_KMS_KEY_NAME
  value: {{ .Values.kms.gcp.keyName | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Volume entry for the local KEK file. Used only when kms.provider=local.
Sources the KEK JSON from `existingSecret` under `kms.local.secretKey`.
*/}}
{{- define "swarmforge.kekVolume" -}}
{{- if and (eq .Values.kms.provider "local") .Values.existingSecret .Values.kms.local.secretKey }}
- name: kek
  secret:
    secretName: {{ .Values.existingSecret }}
    items:
      - key: {{ .Values.kms.local.secretKey | quote }}
        path: {{ .Values.kms.local.fileName | quote }}
{{- end }}
{{- end }}

{{/*
Volume mount for the local KEK file. Used only when kms.provider=local.
*/}}
{{- define "swarmforge.kekVolumeMount" -}}
{{- if and (eq .Values.kms.provider "local") .Values.existingSecret .Values.kms.local.secretKey }}
- name: kek
  mountPath: {{ .Values.kms.local.mountDir | quote }}
  readOnly: true
{{- end }}
{{- end }}
