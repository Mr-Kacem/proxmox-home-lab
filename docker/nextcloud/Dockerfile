FROM nextcloud:34.0.2-apache

COPY homelab-ca.crt /usr/local/share/ca-certificates/homelab-ca.crt

RUN update-ca-certificates
