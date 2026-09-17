FROM ghcr.io/stjude-rust-labs/sprocket:v0.31.0
WORKDIR /app

RUN apk add --update bash

COPY . .

ENTRYPOINT ["sprocket"]
CMD ["--help"]
