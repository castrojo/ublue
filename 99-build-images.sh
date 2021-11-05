#!/bin/bash
# build toolbox images
set -eu

# Scan the images we have available

IMAGES=$(find images -type f -name Containerfile | awk -F/ '{printf "%s-%s\n", $2, $3}')

# mapfile -t test $IMAGES 

# echo $IMAGES


find images/ -type f -name Containerfile -print0 | 
    while IFS= read -r -d '' line; do
        image=$(echo $line | awk -F/ '{printf "%s-%s\n", $2, $3}')

        echo "Building $image..."


        # Think about where to redirect the output. Maybe a temp log?

        podman build -t $image -f $line > /dev/null


        # echo "$line ($image)"
        # Error: container debian-sid already exists
        echo "To create a container using this image, run:"
        echo "toolbox create --image $image -c my-project"

    done