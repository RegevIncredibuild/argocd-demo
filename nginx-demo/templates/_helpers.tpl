{{/*
Common labels
*/}}
{{- define "common.labels" -}}
app: {{ .Release.Name }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Debug annotations
*/}}
{{- define "common.debugAnnotations" -}}
{{- if .Values.debug.enabled }}
debug.argocd/enabled: "true"
debug.argocd/level: {{ .Values.debug.logLevel | quote }}
{{- if .Values.debug.includeConfigDump }}
debug.argocd/config-dump: {{ toJson .Values | b64enc | quote }}
{{- end }}
{{- if .Values.debug.additionalAnnotations }}
{{- toYaml .Values.debug.additionalAnnotations }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "common.selectorLabels" -}}
app: {{ .Release.Name }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
