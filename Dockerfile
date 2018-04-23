FROM golang as builder
ENV CGO_ENABLED=0
ENV GOOS=linux
RUN go get github.com/mdlayher/unifi_exporter/cmd/unifi_exporter

FROM scratch
COPY --from=builder /go/bin/unifi_exporter /go/bin/unifi_exporter
EXPOSE 9130
CMD ["/go/bin/unifi_exporter"]
