#!/bin/bash
# Utility script to initialize Application in production mode without enforcing SSL for local testing purposes
# Running the Application in production mode with forced SSL would cause issues when running locally

docker compose down
docker compose -f compose.yaml -f compose.override.nosslprod.yaml up --build