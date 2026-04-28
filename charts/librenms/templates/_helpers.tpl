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
{{- if .Values.librenms.existingSecret -}}
{{- .Values.librenms.existingSecret -}}
{{- else -}}
{{- .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Database host - returns the database host based on mode (without port)
*/}}
{{- define "librenms.dbHost" -}}
{{- if not .Values.mysql.enabled -}}
{{- $host := required "externalDatabase.host is required when mysql.enabled is false" .Values.externalDatabase.host -}}
{{- if contains ":" $host -}}
{{- $host | splitList ":" | first -}}
{{- else -}}
{{- $host -}}
{{- end -}}
{{- else -}}
{{- printf "%s-mysql" .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Database port - returns the database port based on mode
Extracts port from host string if present (host:port), otherwise uses explicit port field
*/}}
{{- define "librenms.dbPort" -}}
{{- if not .Values.mysql.enabled -}}
{{- $host := required "externalDatabase.host is required when mysql.enabled is false" .Values.externalDatabase.host -}}
{{- if contains ":" $host -}}
{{- $host | splitList ":" | last -}}
{{- else -}}
{{- .Values.externalDatabase.port | default 3306 -}}
{{- end -}}
{{- else -}}
{{- print "3306" -}}
{{- end -}}
{{- end -}}

{{/*
Database name - returns the database name based on mode
*/}}
{{- define "librenms.dbName" -}}
{{- if not .Values.mysql.enabled -}}
{{- required "externalDatabase.name is required when mysql.enabled is false" .Values.externalDatabase.name -}}
{{- else -}}
{{- .Values.mysql.auth.database -}}
{{- end -}}
{{- end -}}

{{/*
Database user - returns the database username based on mode
*/}}
{{- define "librenms.dbUser" -}}
{{- if not .Values.mysql.enabled -}}
{{- required "externalDatabase.user is required when mysql.enabled is false" .Values.externalDatabase.user -}}
{{- else -}}
{{- .Values.mysql.auth.username -}}
{{- end -}}
{{- end -}}

{{/*
Database timeout - returns the database timeout based on mode
*/}}
{{- define "librenms.dbTimeout" -}}
{{- if not .Values.mysql.enabled -}}
{{- .Values.externalDatabase.timeout | default 60 -}}
{{- else -}}
{{- print "60" -}}
{{- end -}}
{{- end -}}

{{/*
Database password environment variable - returns the env var definition for DB_PASSWORD
*/}}
{{- define "librenms.dbPasswordEnv" -}}
{{- if not .Values.mysql.enabled -}}
{{- if .Values.externalDatabase.existingSecret.name -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.externalDatabase.existingSecret.name }}
    key: {{ .Values.externalDatabase.existingSecret.key | default "mysql-password" }}
{{- else if .Values.externalDatabase.password -}}
value: {{ .Values.externalDatabase.password | quote }}
{{- else -}}
{{- fail "Either externalDatabase.existingSecret.name or externalDatabase.password must be set when mysql.enabled is false" -}}
{{- end -}}
{{- else -}}
{{- if and .Values.mysql.existingAuthSecret .Values.mysql.existingAuthSecret.name -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.mysql.existingAuthSecret.name }}
    key: {{ .Values.mysql.existingAuthSecret.key | default "mysql-user-password" }}
{{- else -}}
valueFrom:
  secretKeyRef:
    name: {{ .Release.Name }}-mysql-auth
    key: mysql-user-password
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Redis host - returns the Redis host based on mode
*/}}
{{- define "librenms.redisHost" -}}
{{- if not .Values.redis.enabled -}}
{{- required "externalRedis.host is required when redis.enabled is false" .Values.externalRedis.host -}}
{{- else -}}
{{- printf "%s-redis-client" .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Redis port - returns the Redis port based on mode
*/}}
{{- define "librenms.redisPort" -}}
{{- if not .Values.redis.enabled -}}
{{- .Values.externalRedis.port | default 6379 -}}
{{- else -}}
{{- print "6379" -}}
{{- end -}}
{{- end -}}

{{/*
Redis database number - returns the Redis DB index based on mode
*/}}
{{- define "librenms.redisDb" -}}
{{- if not .Values.redis.enabled -}}
{{- .Values.externalRedis.db | default 0 -}}
{{- else -}}
{{- print "0" -}}
{{- end -}}
{{- end -}}

{{/*
Redis auth enabled - returns true if Redis password auth should be configured
*/}}
{{- define "librenms.redisAuthEnabled" -}}
{{- if not .Values.redis.enabled -}}
{{- if or .Values.externalRedis.password .Values.externalRedis.existingSecret.name -}}
true
{{- end -}}
{{- else -}}
{{- if .Values.redis.auth.enabled -}}
true
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Redis password environment variable - returns the env var definition for REDIS_PASSWORD
*/}}
{{- define "librenms.redisPasswordEnv" -}}
{{- if not .Values.redis.enabled -}}
{{- if .Values.externalRedis.existingSecret.name -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.externalRedis.existingSecret.name }}
    key: {{ .Values.externalRedis.existingSecret.key | default "redis-password" }}
{{- else if .Values.externalRedis.password -}}
value: {{ .Values.externalRedis.password | quote }}
{{- end -}}
{{- else -}}
{{- if .Values.redis.auth.existingSecret -}}
valueFrom:
  secretKeyRef:
    name: {{ .Values.redis.auth.existingSecret }}
    key: {{ .Values.redis.auth.existingSecretPasswordKey | default "redis-password" }}
{{- else -}}
valueFrom:
  secretKeyRef:
    name: {{ .Release.Name }}-redis-auth
    key: redis-password
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate external Redis configuration
*/}}
{{- define "librenms.validateExternalRedis" -}}
{{- if not .Values.redis.enabled -}}
{{- if not .Values.externalRedis.host -}}
{{- fail "externalRedis.host is required when redis.enabled is false" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Validate external database configuration
*/}}
{{- define "librenms.validateExternalDB" -}}
{{- if not .Values.mysql.enabled -}}
{{- if not .Values.externalDatabase.host -}}
{{- fail "externalDatabase.host is required when mysql.enabled is false" -}}
{{- end -}}
{{- if not .Values.externalDatabase.name -}}
{{- fail "externalDatabase.name is required when mysql.enabled is false" -}}
{{- end -}}
{{- if not .Values.externalDatabase.user -}}
{{- fail "externalDatabase.user is required when mysql.enabled is false" -}}
{{- end -}}
{{- if and (not .Values.externalDatabase.existingSecret.name) (not .Values.externalDatabase.password) -}}
{{- fail "Either externalDatabase.existingSecret.name or externalDatabase.password must be set when mysql.enabled is false" -}}
{{- end -}}
{{- end -}}
{{- end -}}
