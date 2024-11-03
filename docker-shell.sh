#!/bin/bash

# Usage: ./docker-shell.sh <container name>

name="${1?needs one argument}"
containerId=$(docker ps | grep $name | cut -c1-12)

if [[ -n "$containerId" ]]; then
    echo "Container ID: $containerId"
    docker exec -it $containerId bash
else
    echo "No docker container with name: $name is running"
fi
