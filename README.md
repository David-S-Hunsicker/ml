# ml
learning about machines learning about people

## Local GPU Notebook

Run a JupyterLab container with NVIDIA GPU access on Docker Desktop. Uses [`cschranz/gpu-jupyter`](https://github.com/iot-salzburg/gpu-jupyter) — a full JupyterLab stack on CUDA 12.9 + Ubuntu 24.04 with PyTorch and multithreading support.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running
- Docker Desktop configured to use the **WSL2 backend** (Settings → General → Use WSL2 based engine)
- WSL2 GPU passthrough enabled (Settings → Resources → WSL Integration)
- NVIDIA drivers installed on Windows (the WSL2 kernel handles passthrough — no separate Linux driver needed)

### Start the notebook

```sh
bash local_ml/start_gpu_notebook.sh
```

The script will pull the latest Colab runtime image, start the container, and wait until Jupyter is ready.

### Connect from VS Code

1. Install the **Jupyter** extension in VS Code
2. Open the Command Palette → `Jupyter: Specify Jupyter Server for Connections`
3. Choose **Existing** and paste:

```
http://localhost:9000/?token=localdev
```

Or open JupyterLab directly in a browser at `http://localhost:9000/lab?token=localdev`.

This URL never changes — the token is fixed so you don't need to fetch it from the container.

### Stop the notebook

```sh
docker rm -f colab-gpu-notebook
```

### Files

| File | Purpose |
|------|---------|
| `local_ml/start_gpu_notebook.sh` | Start script — run this |
| `local_ml/docker-compose.yml` | Compose config (used by the start script) |
