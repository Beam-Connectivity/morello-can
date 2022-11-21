#!/bin/bash

# Fetch script directory
ORIGINAL_DIR="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd ${SCRIPT_DIR}

# Extract files
tar -xf /root/morello_workspace/soc.tar.xz

cd ${ORIGINAL_DIR}
