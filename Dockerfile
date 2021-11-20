FROM golang:1.17 as builder
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GO111MODULE=off
# fetch
RUN go get -d github.com/mdlayher/unifi_exporter/cmd/unifi_exporter
# pin to specific commit
RUN cd /go/src/github.com/mdlayher/unifi_exporter && \
  git checkout 85455df7c491b44c8589b95b6b9401881762b9e2
# build
RUN go install github.com/mdlayher/unifi_exporter/cmd/unifi_exporter

FROM alpine as cert
RUN apk --update add ca-certificates

FROM scratch
COPY --from=builder /go/bin/unifi_exporter /go/bin/unifi_exporter
COPY --from=cert /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
EXPOSE 9130
CMD ["/go/bin/unifi_exporter"]
