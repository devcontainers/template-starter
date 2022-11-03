#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "greeting" [ $(cat /tmp/greeting.txt | grep hey) ]

# Report result
reportResults
