#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" cat /etc/os-release | grep -i kali
check "python3" python3 --version
check "pip3" pip3 --version
check "curl" curl --version
check "git" git --version
check "sudo" sudo --version

# Report result
reportResults
