FROM ghcr.io/stjude-rust-labs/sprocket:v0.15.0
WORKDIR /app

COPY . .

ENTRYPOINT ["sprocket"]
CMD ["--help"]
