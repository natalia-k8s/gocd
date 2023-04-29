FROM golang:1.20 as build-stage

LABEL org.opencontainers.image.source=https://github.com/natalia-k8s/gocd

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /hello-world



FROM gcr.io/distroless/base-debian11 AS release-stage

WORKDIR /

COPY --from=build-stage /hello-world /hello-world

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/hello-world"]
