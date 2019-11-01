#!/usr/bin/env bash

set -x

: ${DOC_IMG:=f5devcentral/containthedocs:1.0.8}

exec docker run -i \
  -v $PWD:$PWD --workdir $PWD \
  ${DOC_IMG} /bin/bash -s <<EOF
set -e
#echo "Installing project dependencies"
pip install --user -r requirements.txt
echo "Building docs with Sphinx"
make clean
echo "Generating site"
make html
echo "Checking links"
make linkcheck
EOF