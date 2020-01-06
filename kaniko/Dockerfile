FROM gcr.io/kaniko-project/executor:debug-v0.17.1
# Workaround as per https://github.com/GoogleContainerTools/kaniko/issues/656#issuecomment-564035645
COPY --from=amd64/busybox:1.31.0 /bin/busybox /busybox/busybox