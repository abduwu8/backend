FROM golang:1.22-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /server ./cmd/server

FROM alpine:3.20

WORKDIR /app

RUN adduser -D -g '' appuser

COPY --from=builder /server /app/server

ENV PORT=8080
ENV FRONTEND_ASSETS_PATH=/assets

EXPOSE 8080

USER appuser

CMD ["/app/server"]
