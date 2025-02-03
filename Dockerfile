FROM ghcr.io/stjude-rust-labs/sprocket:v0.10.1
WORKDIR /app

COPY . .

ENTRYPOINT ["sprocket"]
CMD ["--help"]
