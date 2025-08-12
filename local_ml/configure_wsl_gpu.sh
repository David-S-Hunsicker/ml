#!/bin/bash

# This script configures the WSL2 environment for CUDA, NVIDIA Toolkit, and GCC.
# It assumes WSL2 is already set up and Docker Desktop is using the WSL2 backend.

echo "Starting WSL2 GPU configuration script..."

# --- Check and Install NVIDIA Drivers (Usually handled by Windows Update/Docker Desktop) ---
# Docker Desktop with WSL2 integration often handles the necessary drivers in the WSL2 kernel.
# We will primarily focus on the CUDA toolkit and utilities within the user space.
echo "Checking for NVIDIA driver presence (via nvidia-smi)..."
if command -v nvidia-smi &> /dev/null
then
    echo "nvidia-smi found. NVIDIA driver appears to be accessible."
    nvidia-smi
else
    echo "nvidia-smi not found. Ensure Docker Desktop with WSL2 GPU support is correctly installed and configured."
    echo "You might need to install NVIDIA drivers for WSL directly from NVIDIA's website if automatic setup failed."
    # Note: Installing drivers manually in WSL2 can be complex and is often unnecessary with recent Docker Desktop versions.
fi

# --- Check and Install CUDA Toolkit ---
# We'll check if nvcc (CUDA compiler) is available as a proxy for the toolkit installation.
echo "Checking for CUDA Toolkit (via nvcc)..."
if command -v nvcc &> /dev/null
then
    echo "nvcc found. CUDA Toolkit appears to be installed."
    nvcc --version
else
    echo "nvcc not found. Attempting to install CUDA Toolkit utilities."
    # This command installs the CUDA user-space components needed for development and running CUDA applications.
    # It does NOT install the driver (that comes from Windows/Docker Desktop).
    # This example uses the NVIDIA CUDA apt repository. You might need to add it first
    # if you haven't already. Instructions vary slightly by Ubuntu version.
    # See https://developer.nvidia.com/cuda-downloads for official instructions.

    # Example commands (adapt as needed for your specific WSL2 distro version):
    # sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntuXX04/x86_64/3bf863cc.pub
    # sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntuXX04/x86_64/ /"
    # sudo apt-get update

    echo "Attempting to install cuda-toolkit-on-wsl..."
    sudo apt-get update && sudo apt-get install -y cuda-toolkit-on-wsl
    if command -v nvcc &> /dev/null
    then
        echo "CUDA Toolkit installation successful."
        nvcc --version
    else
        echo "CUDA Toolkit installation failed. Please check your apt sources and try again."
    fi
fi

# --- Check and Install GCC ---
echo "Checking for GCC..."
if command -v gcc &> /dev/null
then
    echo "GCC found."
    gcc --version
else
    echo "GCC not found. Attempting to install build-essential."
    sudo apt-get update && sudo apt-get install -y build-essential
    if command -v gcc &> /dev/null
    then
        echo "GCC installation successful."
        gcc --version
    else
        echo "GCC installation failed. Please check your package manager."
    fi
fi

echo "WSL2 GPU configuration script finished."
echo "You should now be able to use Docker containers with GPU support."
