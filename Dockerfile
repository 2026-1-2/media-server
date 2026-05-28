FROM golang:1.26-alpine AS builder
RUN apk add --no-cache git build-base
WORKDIR /build
COPY . .
RUN go generate ./...
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mediamtx .

FROM alpine:3.19
WORKDIR /app
RUN apk add --no-cache tzdata ca-certificates
COPY --from=builder /build/mediamtx /app/mediamtx
COPY mediamtx.yml /app/mediamtx.yml
COPY setup.sh /app/setup.sh
RUN chmod +x /app/mediamtx
RUN chmod +x /app/setup.sh
EXPOSE 8554 8889 8189/tcp 8189/udp
ENTRYPOINT [ "/app/setup.sh" ]
