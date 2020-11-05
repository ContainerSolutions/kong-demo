#!/usr/bin/env bash

set -uex

cd "${0%/*}"

kubectl delete -f manifest.yaml
