{{- define "librenms.configChecksum" -}}
{{- include (print $.Template.BasePath "/librenms-configmap.yml") . | sha256sum -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "librenms.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "librenms.fullname" -}}
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
{{- define "librenms.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "librenms.labels" -}}
helm.sh/chart: {{ include "librenms.chart" . }}
{{ include "librenms.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "librenms.selectorLabels" -}}
app.kubernetes.io/name: {{ include "librenms.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "librenms.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "librenms.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use
*/}}
{{- define "librenms.secretName" -}}
{{ include "librenms.appkeySecretNameOrExisting" . }}
{{- end -}}

{{/*
Secret name used when chart manages the APP_KEY
*/}}
{{- define "librenms.appkeySecretName" -}}
{{- if .Values.librenms.appkeySecretName }}
{{- .Values.librenms.appkeySecretName }}
{{- else }}
{{- include "librenms.fullname" . }}-appkey
{{- end }}
{{- end }}

{{/*
Resolve secret name (existingSecret vs managed Secret)
*/}}
{{- define "librenms.appkeySecretNameOrExisting" -}}
{{- if .Values.librenms.existingSecret }}
{{- .Values.librenms.existingSecret }}
{{- else }}
{{- include "librenms.appkeySecretName" . }}
{{- end }}
{{- end }}

{{/*
Generate-once APP_KEY logic
On first install: generates random key or uses user-provided value
On upgrade: reuses existing key from Secret (lookup)
*/}}
{{- define "librenms.appkeyValue" -}}
{{- $secretName := include "librenms.appkeySecretName" . -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace $secretName -}}
{{- if $existing }}
  {{- index $existing.data "appkey" | b64dec -}}
{{- else if .Values.librenms.appkey }}
  {{- .Values.librenms.appkey -}}
{{- else -}}
  {{- randAlphaNum 32 -}}
{{- end -}}
{{- end }}