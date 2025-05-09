FROM ghcr.io/stjude-rust-labs/sprocket:v0.12.2
WORKDIR /app

COPY . .

ENTRYPOINT ["sprocket"]
CMD ["--help"]
