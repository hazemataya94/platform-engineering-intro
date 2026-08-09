{{- define "support-exporter.name" -}}
{{- default .Chart.Name .Values.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "support-exporter.labels" -}}
app.kubernetes.io/name: {{ include "support-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: platform-engineering-session
platform.engineering/workload: support-exporter
{{- end -}}
