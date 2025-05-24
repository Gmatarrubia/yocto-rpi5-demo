#!/bin/sh

# Create session-perssistent sockets directory
export XDG_RUNTIME_DIR="/tmp/xdg-runtime-$(id -u)"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# Create volume mount point
export CONFIG_PATH="${HOME}/homeassistant"
mkdir -p "${CONFIG_PATH}"

# Container info
IMAGE_CONTAINER="ghcr.io/home-assistant/home-assistant"
VERSION="stable"

# Run the container
/usr/bin/podman run \
  --cgroup-manager=cgroupfs \
  --cgroups=no-conmon --rm \
  --sdnotify=conmon --replace --detach \
  --label "io.containers.autoupdate=registry" \
  --name=homeassistant \
  --volume="${CONFIG_PATH}":/config:z \
  --network=host \
  "${IMAGE_CONTAINER}:${VERSION}"
