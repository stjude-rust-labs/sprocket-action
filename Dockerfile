FROM ghcr.io/stjude-rust-labs/sprocket:v0.12.2
WORKDIR /app

COPY . .

RUN apt update && apt install -y shellcheck && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["sprocket"]
CMD ["--help"]
