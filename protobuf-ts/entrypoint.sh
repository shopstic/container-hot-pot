#!/usr/bin/env bash
set -euo pipefail

mkdir /in
cp -R /proto/*/* /in/
cp -R /protobuf/* /in/

OUT_FILES_ARR=("$@")
OUT_FILES=${OUT_FILES_ARR[@]/#/\/in\/}

echo "Linting: ${OUT_FILES}"

protoc --lint_out=/out -I /in ${OUT_FILES}

echo "Compiling..."

protoc \
  -I /in \
  --include_imports \
  --descriptor_set_out=/tmp/desc \
  --dependency_out=/tmp/deps \
  ${OUT_FILES}

DEPS_ARR=($(cat /tmp/deps | tr '\n' ' ' | sed 's/\\//g'))
DEPS_ARR=(${DEPS_ARR[@]/#\/in\/})
DEPS_ARR=(${DEPS_ARR[@]//google\/*/})
DEPS=${DEPS_ARR[@]//scalapb\/*/}

echo "Going to compile: ${DEPS}"

rm -Rf /out/*

exec protoc \
  --plugin=ts-protoc-gen=/usr/lib/node_modules/ts-protoc-gen/bin/protoc-gen-ts \
  --descriptor_set_in=/tmp/desc \
  --js_out=import_style=commonjs,binary:/out/ \
  --ts_out=service=true:/out/ \
  ${DEPS}