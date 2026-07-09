FROM golang:1.26-alpine AS build

WORKDIR /app

COPY . .

RUN go mod tidy & CGOOS=linux GOARCH=amd64 go build -o skillpulse .

FROM alpine:3.18

WORKDIR /app

RUN apk add --no-cache ca-certificates

COPY --from=build /app/skillpulse .

EXPOSE 8080

CMD ["./skillpulse"]