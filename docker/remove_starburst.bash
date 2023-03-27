#!/bin/bash

# move to wherever we are so docker things work
cd "$(dirname "${BASH_SOURCE[0]}")"
cd ..
docker-compose -f docker-starburst-sandbox-config.yaml down
