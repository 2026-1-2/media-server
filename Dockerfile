FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git build-base
WORKDIR /build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mediamtx .

FROM alpine:3.19
WORKDIR /app
RUN apk add --no-cache tzdata ca-certificates
COPY --from=builder /build/mediamtx /app/mediamtx
COPY mediamtx.yml /app/mediamtx.yml
RUN chmod +x /app/mediamtx /app/setup.sh
EXPOSE 8554 8889 8189/tcp 8189/udp
ENTRYPOINT [ "/app/setup.sh" ]