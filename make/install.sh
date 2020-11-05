#!/usr/bin/env bash

set -uex

cd "${0%/*}"

kubectl apply -f manifest.yaml
