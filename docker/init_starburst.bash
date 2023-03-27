#!/bin/bash

# move to wherever we are so docker things work
cd "$(dirname "${BASH_SOURCE[0]}")"
cd ..

set -exo pipefail

docker-compose -f starburst-sandbox-config.yaml build
docker-compose -f starburst-sandbox-config.yaml up -d
#timeout 5m bash -c -- 'while ! docker-compose -f starburst-sandbox-config.yaml logs trino 2>&1 | tail -n 1 | grep "SERVER STARTED"; do sleep 2; done'
sleep 30
### SET BIAC ROLES
pwd
bash docker/starburst/biac/setup-biac-roles.sh
