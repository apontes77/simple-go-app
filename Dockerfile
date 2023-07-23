# Stage 1: Build stage
FROM golang:1.20 AS build

WORKDIR /usr/src/app

COPY go.mod ./
RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o /usr/src/app/app ./...

# Stage 2: Final image
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=build /usr/src/app/app ./app

CMD ["./app"]

EXPOSE 8080