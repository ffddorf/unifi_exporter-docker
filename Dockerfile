FROM golang as builder
ENV CGO_ENABLED=0
ENV GOOS=linux
RUN go get github.com/mdlayher/unifi_exporter/cmd/unifi_exporter

FROM busybox as cert
RUN wget -O /cacert.pem https://curl.haxx.se/ca/cacert.pem

FROM scratch
COPY --from=builder /go/bin/unifi_exporter /go/bin/unifi_exporter
COPY --from=cert /cacert.pem /etc/ssl/certs/ca-certificates.crt
EXPOSE 9130
CMD ["/go/bin/unifi_exporter"]
