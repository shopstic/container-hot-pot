{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fdb-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fdb-cluster.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fdb-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "fdb-cluster.labels" -}}
helm.sh/chart: {{ include "fdb-cluster.chart" . }}
{{ include "fdb-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "fdb-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fdb-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "fdb-cluster.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "fdb-cluster.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create sidecar FDB metrics Prometheus exporter based on trace logs
*/}}
{{- define "fdb-cluster.log-metrics-exporter" -}}
{{- if .Values.exporter.enabled }}
- name: {{ .Chart.Name }}-log-metrics-exporter
  image: {{ .Values.exporter.image.repository }}:{{ .Values.exporter.image.tag }}
  imagePullPolicy: {{ .Values.exporter.image.pullPolicy }}
  resources:
    requests:
      cpu: {{ .Values.exporter.resources.requests.cpu }}
      memory: {{ add .Values.exporter.heapMemoryLimitMBs .Values.exporter.nonHeapMemorySizeMBs }}Mi
    limits:
      cpu: {{ .Values.exporter.resources.limits.cpu }}
      memory: {{ add .Values.exporter.heapMemoryLimitMBs .Values.exporter.nonHeapMemorySizeMBs }}Mi
  ports:
    - name: fdb-metrics
      containerPort: 9095
      protocol: TCP
    {{- if .Values.exporter.jmx.enabled }}
    - name: jmx
      containerPort: {{ .Values.exporter.jmx.port }}
      protocol: TCP
    {{- end }}
  livenessProbe:
    httpGet:
      path: /metrics
      port: fdb-metrics
    initialDelaySeconds: 20
    periodSeconds: 20
  readinessProbe:
    httpGet:
      path: /metrics
      port: fdb-metrics
    initialDelaySeconds: 10
    periodSeconds: 5
  command: ["/opt/docker/bin/fdb-exporter"]
  args:
    - "-J-XshowSettings:vm"
    - "-J-Xms{{ .Values.exporter.heapMemoryLimitMBs }}m"
    - "-J-Xmx{{ .Values.exporter.heapMemoryLimitMBs }}m"
    - "-J-XcompilationThreads1"
    - "-Dlog.level=INFO"
    {{- if .Values.exporter.jmx.enabled }}
    - "-Dcom.sun.management.jmxremote"
    - "-Dcom.sun.management.jmxremote.port={{ .Values.exporter.jmx.port }}"
    - "-Dcom.sun.management.jmxremote.rmi.port={{ .Values.exporter.jmx.port }}"
    - "-Dcom.sun.management.jmxremote.host=0.0.0.0"
    - "-Djava.rmi.server.hostname=127.0.0.1"
    - "-Dcom.sun.management.jmxremote.local.only=false"
    - "-Dcom.sun.management.jmxremote.ssl=false"
    - "-Dcom.sun.management.jmxremote.authenticate=false"
    {{- end }}
    {{- with .Values.exporter.args }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  env:
    - name: APP_DIRECTORY_TAILER_PATH
      value: /app/data/log
    {{- if .Values.exporter.env }}
    {{- toYaml .Values.exporter.env | nindent 12 }}
    {{- end }}
  volumeMounts:
    - name: app-data
      mountPath: /app/data
{{- end}}
{{- end -}}
