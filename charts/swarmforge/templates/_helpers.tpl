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
