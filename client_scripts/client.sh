#!/bin/bash

# Simulates $_GET request 
# that covers TCP only - UDP wont be done via browser (or tricky, chrome with extensions only)

server="$1"
port="$2"
curl --max-time 1 --silent "http://${server}:${port}"
