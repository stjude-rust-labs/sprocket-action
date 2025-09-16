FROM ghcr.io/stjude-rust-labs/sprocket:v0.17.0
WORKDIR /app

RUN apk add --update bash

COPY . .

ENTRYPOINT ["sprocket"]
CMD ["--help"]
