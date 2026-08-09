{{- define "adminer.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "adminer.labels" -}}
app.kubernetes.io/name: {{ include "adminer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: platform-engineering-session
platform.engineering/workload: adminer
{{- end -}}
