#!/bin/sh

set -exuo pipefail

python -m pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir ontospy[FULL] -U
mkdir /artifacts
