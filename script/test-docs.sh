#!/usr/bin/env bash

set -x

: ${DOC_IMG:=f5devcentral/containthedocs:latest}

exec docker run -i \
  -v $PWD:$PWD --workdir $PWD \
  ${DOC_IMG} /bin/bash -s <<EOF
set -e
#echo "Installing project dependencies"
pip install --user -r requirements.txt
export PATH=$PATH:/root/.local/bin
echo "Building docs with Sphinx"
make clean
echo "Checking links"
make -C docs/ linkcheck
EOF