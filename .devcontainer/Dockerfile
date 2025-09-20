ARG CUDA_VERSION=12.9.0
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu22.04

ENV PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies.
ARG UBUNTU_MIRROR=mirrors.aliyun.com
RUN sed -i 's/archive.ubuntu.com/${UBUNTU_MIRROR}/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/${UBUNTU_MIRROR}/g' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y \
    build-essential curl ca-certificates wget tree unzip bzip2 xz-utils zip nano vim-tiny less jq lsb-release apt-transport-https sudo tmux ffmpeg libsm6 libxext6 libxrender-dev libssl3 git git-lfs gdb rsync aria2 && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
ARG USER_NAME=qi7876
ARG USER_UID=1000
ARG USER_GID=1000
RUN addgroup --gid ${USER_GID} ${USER_NAME} && \
    adduser --disabled-password --gecos "" --uid ${USER_UID} --gid ${USER_GID} ${USER_NAME} && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USER_NAME}
USER ${USER_NAME}

ARG HUGGINGFACE_MIRROR=https://hf-mirror.com
ENV HF_ENDPOINT=${HUGGINGFACE_MIRROR}

# Install Starship.
RUN curl -sS https://starship.rs/install.sh | sh -s -- --yes && \
    echo 'eval "$(starship init bash)"' >> /root/.bashrc

# Install uv.
ARG PYPI_MIRROR=https://mirrors.aliyun.com/pypi/simple/
ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"
ENV UV_DEFAULT_INDEX=${PYPI_MIRROR}
ENV UV_LINK_MODE=copy
RUN curl -LsSf https://astral.sh/uv/install.sh | sh