FROM ghcr.io/stjude-rust-labs/sprocket:v0.14.0
WORKDIR /app

COPY . .

ENTRYPOINT ["sprocket"]
CMD ["--help"]
