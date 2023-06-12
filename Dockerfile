FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

ENV DEBIAN_FRONTEND noninteractive

RUN \
    --mount=type=cache,target=/var/cache/apt \
    apt update && apt upgrade -y

RUN \
    --mount=type=cache,target=/var/cache/apt \
   apt install nvidia-cuda-toolkit -y

RUN \
    --mount=type=cache,target=/var/cache/apt \
    apt install wget -y


# facexlib and gfpgan are for face enhancement
RUN \
    --mount=type=cache,target=/root/.cache \
  pip install facexlib

RUN \
    --mount=type=cache,target=/root/.cache \
    pip install gfpgan

#Firt download
WORKDIR /opt/conda/lib/python3.10/site-packages/gfpgan/weights

RUN wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth

RUN pip uninstall torch &> /dev/null
WORKDIR /install
COPY requirements.txt .

RUN \
    --mount=type=cache,target=/root/.cache \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu117


RUN \
    --mount=type=cache,target=/root/.cache \
    pip install -r requirements.txt




COPY get_torch_version.py .
RUN python get_torch_version.py && sleep 3


WORKDIR /work

