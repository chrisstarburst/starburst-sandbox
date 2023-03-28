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


docker-compose -f starburst-sandbox-config.yaml build
docker-compose -f starburst-sandbox-config.yaml up -d
#timeout 5m bash -c -- 'while ! docker-compose -f starburst-sandbox-config.yaml logs trino 2>&1 | tail -n 1 | grep "SERVER STARTED"; do sleep 2; done'
sleep 30
### SET BIAC ROLES
pwd
#bash docker/starburst/biac/setup-biac-roles.sh
