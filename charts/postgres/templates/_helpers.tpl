{{- define "postgres.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "postgres.fullname" -}}
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

{{- define "postgres.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "postgres.labels" -}}
helm.sh/chart: {{ include "postgres.chart" . }}
{{ include "postgres.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "postgres.secretName" -}}
{{- if .Values.auth.existingSecret }}
{{- .Values.auth.existingSecret }}
{{- else }}
{{- include "postgres.fullname" . }}
{{- end }}
{{- end }}

{{/*
Resolve the TLS Secret name. Fails when tls.enabled and neither / both of
existingSecret and certManager.enabled are set.
*/}}
{{- define "postgres.tlsSecretName" -}}
{{- if not .Values.tls.enabled -}}
  {{- "" -}}
{{- else if and .Values.tls.existingSecret .Values.tls.certManager.enabled -}}
  {{- fail "postgres: set exactly one of tls.existingSecret or tls.certManager.enabled" -}}
{{- else if .Values.tls.existingSecret -}}
  {{- .Values.tls.existingSecret -}}
{{- else if .Values.tls.certManager.enabled -}}
  {{- printf "%s-tls" (include "postgres.fullname" .) -}}
{{- else -}}
  {{- fail "postgres: tls.enabled requires either tls.existingSecret or tls.certManager.enabled" -}}
{{- end -}}
{{- end }}

{{/*
Default DNS names for the cert-manager Certificate when tls.certManager.dnsNames is empty.
*/}}
{{- define "postgres.tlsDefaultDnsNames" -}}
{{- $fullname := include "postgres.fullname" . -}}
{{- $ns := .Release.Namespace -}}
- {{ $fullname | quote }}
- {{ printf "%s.%s" $fullname $ns | quote }}
- {{ printf "%s.%s.svc" $fullname $ns | quote }}
- {{ printf "%s.%s.svc.cluster.local" $fullname $ns | quote }}
{{- end }}
