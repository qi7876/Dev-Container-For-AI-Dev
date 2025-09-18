ARG CUDA_VERSION_ARG=12.9.0
FROM nvidia/cuda:${CUDA_VERSION_ARG}-devel-ubuntu22.04

# Locale and Python environment variables.
ENV PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies.
RUN apt-get update && apt-get install -y \
    build-essential curl ca-certificates wget tree unzip bzip2 xz-utils zip nano vim-tiny less jq lsb-release apt-transport-https sudo tmux ffmpeg libsm6 libxext6 libxrender-dev libssl3 git git-lfs gdb rsync aria2 \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

# Install Starship.
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes && \
    echo 'eval "$(starship init bash)"' >> /root/.bashrc

# Install uv.
ENV PATH="/root/.local/bin:${PATH}"
ENV UV_LINK_MODE=copy
RUN curl -LsSf https://astral.sh/uv/install.sh | sh