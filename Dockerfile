FROM golang:1.21-bookworm

ARG TARGETARCH
ARG VERSION=0.0.0
ARG GOFLAGS

WORKDIR /go/src/github.com/jmorganca/ollama
RUN apt-get update && apt-get install -y git build-essential cmake

COPY . .
ENV GOARCH=$TARGETARCH
RUN /usr/local/go/bin/go generate llm/llama.cpp/generate_linux.go \
    && /usr/local/go/bin/go build -ldflags "-linkmode=external -extldflags='-static' -X=github.com/jmorganca/ollama/version.Version=$VERSION -X=github.com/jmorganca/ollama/server.mode=release" .

FROM debian:bookworm-slim
ENV OLLAMA_HOST 0.0.0.0

RUN apt-get update && apt-get install -y ca-certificates

ARG USER=ollama
ARG GROUP=ollama
RUN groupadd $GROUP && useradd -m -g $GROUP $USER

COPY --from=0 /go/src/github.com/jmorganca/ollama/ollama /bin/ollama

USER $USER:$GROUP
ENTRYPOINT ["/bin/ollama"]
CMD ["serve"]