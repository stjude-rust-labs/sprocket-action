FROM rust:1.82
WORKDIR /app

COPY . .

RUN cargo install sprocket

ENTRYPOINT ["sprocket"]
CMD ["--help"]
