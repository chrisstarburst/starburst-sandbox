#!/bin/bash

# move to wherever we are so docker things work
cd "$(dirname "${BASH_SOURCE[0]}")"
cd ..

set -exo pipefail

if [ -f "docker/starburst/etc/starburstdata.license" ]; then
    echo "Starburst license file in docker/starburst/etc/starburstdata.license exists."
else
    echo "Error: No Starburst License! Please contact your Starburst Team."
    exit 1
fi


if [ "$(uname)" = "Darwin" ]; then
    # Operating system is macOS
    echo "Operating system is macOS. Running command without sudo."
    # Insert your command here, without sudo
    docker-compose -f starburst-sandbox-config.yaml build
    docker-compose -f starburst-sandbox-config.yaml up -d
    ### SET BIAC ROLES
    sleep 30  
else
    # Operating system is not macOS
    echo "Operating system is not macOS. Running command with sudo."
    sudo docker-compose -f starburst-sandbox-config.yaml build
    sudo docker-compose -f starburst-sandbox-config.yaml up -d
    ### SET BIAC ROLES
    sleep 30
    # Insert your command here, with sudo
fi


#timeout 5m bash -c -- 'while ! docker-compose -f starburst-sandbox-config.yaml logs trino 2>&1 | tail -n 1 | grep "SERVER STARTED"; do sleep 2; done'



