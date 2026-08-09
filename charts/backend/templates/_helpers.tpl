{{- define "backend.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "backend.labels" -}}
app.kubernetes.io/name: {{ include "backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: platform-engineering-session
platform.engineering/workload: backend
{{- end -}}
