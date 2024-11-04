FROM alpine:3.20.3 AS builder
RUN apk add --no-cache git
WORKDIR /tmp
RUN git clone https://github.com/Hextris/hextris.git

FROM 404cat/chainguard-nginx:1.27
# FROM cgr.dev/chainguard/nginx:latest - original image. Copied to the personal repo as Chainguard provides only latest images for free
COPY --from=builder /tmp/hextris/ /usr/share/nginx/html

EXPOSE 8080
