#!/bin/bash

docker compose down
docker compose -f compose.yaml -f compose.override.dev.yaml up --build