FROM golang:1.22.2-alpine3.19 as builder
RUN apk update && apk add ca-certificates curl git make tzdata

RUN mkdir -p /go/src/github.com/banzaicloud/spot-price-exporter
WORKDIR /go/src/github.com/banzaicloud/spot-price-exporter

ADD . /go/src/github.com/banzaicloud/spot-price-exporter
RUN make vendor
RUN go build -o /bin/spot-price-exporter .

FROM alpine:3.19
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /bin/spot-price-exporter /bin
ENTRYPOINT ["/bin/spot-price-exporter"]
