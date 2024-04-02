# CUDA Version Matrix

Topmost entry = Tag `latest`

| Julia  | Python  | CUDA   | cuBLAS    | cuDNN | NCCL   | TensorRT  | Linux distro |
|:-------|:--------|:-------|:----------|:------|:-------|:----------|:-------------|
| 1.10.2 | 3.11.8  | 11.8.0 | 11.11.3.6 | 8.9.6 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.10.1 | 3.11.8  | 11.8.0 | 11.11.3.6 | 8.9.6 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.10.0 | 3.11.8  | 11.8.0 | 11.11.3.6 | 8.9.6 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.9.4  | 3.11.7  | 11.8.0 | 11.11.3.6 | 8.9.6 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.9.3  | 3.11.6  | 11.8.0 | 11.11.3.6 | 8.9.6 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.9.2  | 3.11.5  | 11.8.0 | 11.11.3.6 | 8.9.0 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.9.1  | 3.11.4  | 11.8.0 | 11.11.3.6 | 8.9.0 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.9.0  | 3.11.4  | 11.8.0 | 11.11.3.6 | 8.7.0 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |
| 1.8.5  | 3.11.3  | 11.8.0 | 11.11.3.6 | 8.7.0 | 2.16.2 | 8.5.3     | Ubuntu 20.04 |

[^1]: `amd64` only

## PyTorch/TensorFlow compatibility

| Python | CUDA | PyTorch[^2]   | TensorFlow            |
|:-------|:-----|:--------------|:----------------------|
| 3.11   | 11.8 | 2.0 ≤ version | 2.12 ≤ version < 2.15 |

[^2]: Installs its own CUDA binaries

## Recommended NVIDIA driver

| CUDA   | NVIDIA Linux driver | NVIDIA Windows driver[^3] |
|:-------|:--------------------|:--------------------------|
| 11.8.0 | ≥ 520.61.05         | ≥ 520.06                  |

[^3]: [GPU support in Docker Desktop | Docker Docs](https://docs.docker.com/desktop/gpu/),
[Nvidia GPU Support for Windows · Issue #19005 · containers/podman](https://github.com/containers/podman/issues/19005)
