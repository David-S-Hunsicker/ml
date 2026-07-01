#!/usr/bin/env bash
# Starts a JupyterLab container with NVIDIA GPU access on Docker Desktop.
# The notebook URL is always: http://localhost:9000/?token=localdev

set -euo pipefail

CONTAINER_NAME="gpu-notebook"
HOST_PORT=9000
IMAGE="cschranz/gpu-jupyter:v1.10_cuda-12.9_ubuntu-24.04"

# ── Preflight checks ────────────────────────────────────────────────────────

if ! command -v docker &>/dev/null; then
  echo "ERROR: docker not found. Install Docker Desktop and ensure it is running." >&2
  exit 1
fi

if ! docker info &>/dev/null; then
  echo "ERROR: Docker daemon is not running. Start Docker Desktop first." >&2
  exit 1
fi

# ── Tear down any existing container ────────────────────────────────────────

if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  echo "Stopping and removing existing container '${CONTAINER_NAME}'..."
  docker rm -f "${CONTAINER_NAME}"
fi

# ── Pull latest image ────────────────────────────────────────────────────────

echo "Pulling image ${IMAGE}..."
docker pull "${IMAGE}"

# ── Start via docker-compose ─────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Starting container '${CONTAINER_NAME}'..."
docker compose -f "${SCRIPT_DIR}/docker-compose.yml" up -d

# ── Wait for Jupyter to be ready ─────────────────────────────────────────────

echo "Waiting for Jupyter to start..."
MAX_WAIT=60
ELAPSED=0
until curl -sf "http://localhost:${HOST_PORT}/api" &>/dev/null; do
  if [ "${ELAPSED}" -ge "${MAX_WAIT}" ]; then
    echo "ERROR: Jupyter did not become ready within ${MAX_WAIT}s." >&2
    echo "Container logs:" >&2
    docker logs "${CONTAINER_NAME}" >&2
    exit 1
  fi
  sleep 2
  ELAPSED=$((ELAPSED + 2))
done

# ── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "JupyterLab is ready."
echo ""
echo "  URL:   http://localhost:${HOST_PORT}/lab?token=localdev"
echo "  Token: localdev"
echo ""
echo "Connect from VS Code:"
echo "  1. Open the Command Palette → 'Jupyter: Specify Jupyter Server for Connections'"
echo "  2. Choose 'Existing' and paste: http://localhost:${HOST_PORT}/?token=localdev"
echo ""
echo "To stop:  docker rm -f ${CONTAINER_NAME}"
echo "To logs:  docker logs -f ${CONTAINER_NAME}"
