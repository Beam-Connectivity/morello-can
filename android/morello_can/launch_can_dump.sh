#!/bin/sh

# Need to be root to mount devices
su

# Go to can binaries directory
cd /storage/primary/bin

# Set up interface
./slcan_attach -f -s6 -o /dev/ttyACM0
./slcand ttyACM0 slcan0
ifconfig slcan0 up

# Monitor canbus
./candump slcan0
