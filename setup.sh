#!/usr/bin/env sh

set -exu

python -m pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir "ontospy[FULL]" -U
mkdir /artifacts
