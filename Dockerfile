FROM ghcr.io/stjude-rust-labs/sprocket:v0.11.0
WORKDIR /app

COPY . .

ENTRYPOINT ["sprocket"]
CMD ["--help"]
