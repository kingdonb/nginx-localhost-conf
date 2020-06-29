#!/usr/bin/env bash
#mkdir ~/ssl/
openssl genrsa -des3 -out ./rootCA.key 2048
openssl req -x509 -new -nodes -key ./rootCA.key -sha256 -days 1825 -out ./rootCA.pem
