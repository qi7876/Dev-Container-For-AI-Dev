FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

ARG PYTHON_VERSION_ARG=3.12
ENV PYTHON_VERSION=${PYTHON_VERSION_ARG}

# Set PATH for Conda
ENV PATH=/opt/conda/bin:$PATH
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib:/opt/conda/lib"

# Locale and Python environment variables
ENV PYTHONIOENCODING=UTF-8 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive \
    CONDA_AUTO_UPDATE_CONDA=false

# Install system dependencies
RUN apt-get update && apt-get install -y \
    bash \
    build-essential \
    git \
    curl \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget -O miniconda3.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && /bin/bash miniconda3.sh -b -p /opt/conda \
    && rm miniconda3.sh \
    && /opt/conda/bin/conda init bash \
    && eval "$(/opt/conda/bin/conda shell.bash hook)"

# Install Python and other dependencies
RUN conda config --set remote_max_retries 10 \
    && conda install -y python=$PYTHON_VERSION \
    && conda install -y anaconda \
    && conda clean -afy

# Install PyTorch and upgrade pip
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir opencv-python-headless \
    && pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128

CMD ["/bin/bash"]