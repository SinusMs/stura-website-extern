#!/bin/bash

docker compose down
docker compose -f compose.yaml -f compose.override.prod.yaml up -d --build