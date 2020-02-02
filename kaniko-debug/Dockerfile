FROM gcr.io/kaniko-project/executor:debug-v0.19.0
# Workaround as per https://github.com/GoogleContainerTools/kaniko/issues/656#issuecomment-564035645
COPY --from=amd64/busybox:1.31.1 /bin/busybox /busybox/busybox