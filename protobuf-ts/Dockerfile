FROM shopstic/protobuf:0.0.1

RUN apk add --no-cache nodejs bash curl

RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install -g ts-protoc-gen google-protobuf && \
    npm cache clean --force

RUN mkdir /protobuf/scalapb && \
    curl -Lo /protobuf/scalapb/scalapb.proto https://raw.githubusercontent.com/scalapb/ScalaPB/master/protobuf/scalapb/scalapb.proto

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
