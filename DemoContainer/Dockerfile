### Prepare environment for compiled binary from go file
FROM golang:1.20rc2-alpine AS build

WORKDIR /src/
COPY main.go go.mod /src/
RUN CGO_ENABLED=0 go build -o /bin/demo

### Create container with minimum possible size for our binary
FROM scratch
COPY --from=build /bin/demo /bin/demo
ENTRYPOINT ["/bin/demo"]