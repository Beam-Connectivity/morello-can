#!/bin/bash

# Fetch script directory
ORIGINAL_DIR="$(pwd)"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd ${SCRIPT_DIR}/..

# Connect to adb using one of the following command if needed
# adb devices
# adb connect <ip_address>:5555

adb push docker_shared/bin /storage/primary/
adb shell chmod -R +x /storage/primary/bin

cd ${ORIGINAL_DIR}
