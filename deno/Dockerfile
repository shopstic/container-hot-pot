FROM shopstic/bin-deno:1.9.2 as bin-deno

FROM ubuntu:20.04

COPY --from=bin-deno /usr/bin/deno /usr/bin/deno
