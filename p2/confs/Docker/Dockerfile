FROM golang:1.11-alpine AS build
WORKDIR /src/
COPY main.go go.* /src/
COPY app.html /html/
RUN CGO_ENABLED=0 go build -o /bin/app
FROM scratch
COPY --from=build /bin/app /bin/app
COPY --from=build /html/app.html /html/app.html
ENTRYPOINT ["/bin/app"]