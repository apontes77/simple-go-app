# Stage 1: Build stage
FROM golang:1.20-alpine AS build

WORKDIR /usr/src/app

EXPOSE 80

COPY go.mod ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/src/app/app ./...

# Stage 2: Final image
FROM alpine:latest

WORKDIR /app

COPY --from=build /usr/src/app/app ./app

CMD ["./app"]
