FROM rust:1.81
WORKDIR /app

COPY . .

RUN cargo install sprocket

ENTRYPOINT ["sprocket"]
CMD ["--help"]
