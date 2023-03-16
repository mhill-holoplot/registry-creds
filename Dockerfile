FROM golang:1.19-alpine AS build

WORKDIR /go/src/github.com/holoplot/registry-creds

# Only invalidate the download layer if the modules changed
COPY ["go.mod", "go.sum", "./"]

RUN go mod download

COPY . .

RUN --mount=type=cache,target=/root/.cache/go-build \
  go build

FROM alpine:3.17

RUN apk add --update ca-certificates && \
  rm -rf /var/cache/apk/*

COPY --from=build /go/src/github.com/holoplot/registry-creds/registry-creds registry-creds


ENTRYPOINT ["/registry-creds"]
