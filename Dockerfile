FROM golang:alpine AS build-env
LABEL maintainer "Jimmy Zelinskie <jimmyzelinskie+git@gmail.com>"

# Install OS-level dependencies.
RUN apk add --no-cache curl git

# Copy our source code into the container.
WORKDIR /go/src/github.com/chihaya/chihaya
COPY . /go/src/github.com/chihaya/chihaya

# Install our golang dependencies and compile our binary.
RUN go mod tidy
RUN go get -t .
RUN CGO_ENABLED=0 go install ./cmd/chihaya

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=build-env /go/bin/chihaya /chihaya

RUN adduser -D chihaya

# Expose a docker interface to our binary.
EXPOSE 6880 6969

# Drop root privileges
USER chihaya

ENTRYPOINT ["/chihaya"]
