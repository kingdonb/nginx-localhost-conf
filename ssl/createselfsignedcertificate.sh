#!/usr/bin/env bash
openssl req -new -sha256 -nodes -out localhost.csr -newkey rsa:2048 -keyout localhost.key -config localhost.csr.cnf

openssl x509 -req -in localhost.csr -CA ./rootCA.pem -CAkey ./rootCA.key -CAcreateserial -out localhost.crt -days 500 -sha256 -extfile v3.ext
