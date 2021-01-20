#!/usr/bin/env bash
set -euo pipefail

OUT_FILES_ARR=("$@")
OUT_FILES=${OUT_FILES_ARR[@]/#/\/in\/}

echo "Compiling..."

protoc \
  -I /in \
  --include_imports \
  --descriptor_set_out=/tmp/desc \
  --dependency_out=/tmp/deps \
  ${OUT_FILES}

DEPS_ARR=($(cat /tmp/deps | tr '\n' ' ' | sed 's/\\//g'))
DEPS_ARR=(${DEPS_ARR[@]/#\/in\/})
DEPS_ARR=(${DEPS_ARR[@]//\/usr\/*/})
DEPS=${DEPS_ARR[@]//scalapb\/*/}

echo "Going to compile: ${DEPS}"

rm -Rf /out/*

exec protoc \
  --descriptor_set_in=/tmp/desc \
  --js_out=import_style=commonjs:/out/ \
  --grpc-web_out=import_style=typescript,mode=grpcwebtext:/out \
  ${DEPS}