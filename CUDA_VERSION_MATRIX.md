# CUDA Version Matrix

Image tags = Julia versions

Topmost entry = Tag `latest`

| Julia   | Python  | CUDA   | cuBLAS    | cuDNN     | NCCL   | TensorRT[^1]             | Linux distro |
|:--------|:--------|:-------|:----------|:----------|:-------|:-------------------------|:-------------|
| 1.11.6  | 3.12.11 | 13.0.0 | 13.0.0.19 | 9.12.0.46 | 2.27.7 | n/a                      | Ubuntu 24.04 |
| 1.10.10 | 3.12.11 | 12.9.1 | 12.9.1.4  | 8.9.7.29  | 2.27.3 | 10.12.0.36/<br>10.3.0.26 | Ubuntu 22.04 |
| 1.11.5  | 3.12.11 | 12.9.1 | 12.9.1.4  | 8.9.7.29  | 2.27.3 | 10.12.0.36/<br>10.3.0.26 | Ubuntu 22.04 |
| 1.10.9  | 3.12.11 | 12.9.1 | 12.9.1.4  | 8.9.7.29  | 2.27.3 | 10.12.0.36/<br>10.3.0.26 | Ubuntu 22.04 |
| 1.11.4  | 3.12.10 | 12.8.1 | 12.8.4.1  | 8.9.7.29  | 2.25.1 | 10.9.0.34/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.11.3  | 3.12.9  | 12.8.0 | 12.8.3.14 | 8.9.7.29  | 2.25.1 | 10.8.0.43/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.10.8  | 3.12.9  | 12.8.0 | 12.8.3.14 | 8.9.7.29  | 2.25.1 | 10.8.0.43/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.10.7  | 3.12.8  | 12.6.3 | 12.6.4.1  | 8.9.7.29  | 2.23.4 | 10.7.0.23/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.11.2  | 3.12.8  | 12.6.3 | 12.6.4.1  | 8.9.7.29  | 2.23.4 | 10.7.0.23/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.11.1  | 3.12.7  | 12.6.3 | 12.6.4.1  | 8.9.7.29  | 2.23.4 | 10.7.0.23/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.10.6  | 3.12.7  | 12.6.2 | 12.6.3.3  | 8.9.7.29  | 2.23.4 | 10.6.0.26/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.10.5  | 3.12.7  | 12.6.2 | 12.6.3.3  | 8.9.7.29  | 2.23.4 | 10.5.0.18/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.11.0  | 3.12.7  | 12.6.2 | 12.6.1.4  | 8.9.7.29  | 2.23.4 | 10.5.0.18/<br>10.3.0.26  | Ubuntu 22.04 |
| 1.10.4  | 3.12.5  | 12.6.0 | 12.6.0.22 | 8.9.7.29  | 2.22.3 | 10.3.0.26                | Ubuntu 22.04 |
| 1.10.3  | 3.12.3  | 12.5.0 | 12.5.2.13 | 8.9.7.29  | 2.21.5 | 10.0.1.6                 | Ubuntu 22.04 |
| 1.10.2  | 3.12.3  | 12.4.1 | 12.4.5.8  | 8.9.7.29  | 2.21.5 | 10.0.1.6                 | Ubuntu 22.04 |
| 1.10.1  | 3.11.8  | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2]                | Ubuntu 22.04 |
| 1.10.0  | 3.11.8  | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2]                | Ubuntu 22.04 |
| 1.9.4   | 3.11.7  | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2]                | Ubuntu 22.04 |
| 1.9.3   | 3.11.6  | 11.8.0 | 11.11.3.6 | 8.9.6.50  | 2.15.5 | 8.5.3[^2]                | Ubuntu 22.04 |
| 1.9.2   | 3.11.5  | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^2]                | Ubuntu 22.04 |
| 1.9.1   | 3.11.4  | 11.8.0 | 11.11.3.6 | 8.9.0.131 | 2.15.5 | 8.5.3[^2]                | Ubuntu 22.04 |
| 1.9.0   | 3.11.4  | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.15.5 | 8.5.3[^2]                | Ubuntu 22.04 |
| 1.8.5   | 3.11.3  | 11.8.0 | 11.11.3.6 | 8.7.0.84  | 2.16.2 | 8.5.3                    | Ubuntu 20.04 |

[^1]: amd64/arm64
[^2]: `amd64` only

## PyTorch/TensorFlow compatibility

| Python | CUDA | PyTorch[^3]   | TensorFlow[^4]        |
|:-------|:-----|:--------------|:----------------------|
| 3.12   | 13.0 | version ≥ 2.4 | n/a                   |
| 3.12   | 12.8 | version ≥ 2.4 | 2.18 > version ≥ 2.16 |
| 3.12   | 12.6 | version ≥ 2.4 | 2.18 > version ≥ 2.16 |
| 3.12   | 12.5 | version ≥ 2.4 | 2.18 > version ≥ 2.16 |
| 3.12   | 12.4 | version ≥ 2.4 | 2.18 > version ≥ 2.16 |
| 3.11   | 11.8 | version ≥ 2.0 | 2.16 > version ≥ 2.12 |

[^3]: Installs its own CUDA dependencies  
[^4]: The expected TensorRT version is symlinked to the installed TensorRT
version.  
❗️ This relies on backwards compatibility of TensorRT, which may not always be
given.

## Recommended NVIDIA driver (Regular)

| CUDA   | Linux driver version | Windows driver version[^5] |
|:-------|:---------------------|:---------------------------|
| 13.0.0 | ≥ 580.65.06          | n/a                        |
| 12.9.1 | ≥ 575.57.08          | ≥ 576.57                   |
| 12.9.0 | ≥ 575.51.03          | ≥ 576.02                   |
| 12.8.1 | ≥ 570.124.06         | ≥ 572.61                   |
| 12.8.0 | ≥ 570.117            | ≥ 572.30                   |
| 12.6.3 | ≥ 560.35.05          | ≥ 561.17                   |
| 12.6.2 | ≥ 560.35.03          | ≥ 560.94                   |
| 12.6.1 | ≥ 560.35.03          | ≥ 560.94                   |
| 12.6.0 | ≥ 560.28.03          | ≥ 560.76                   |
| 12.5.0 | ≥ 555.42.02          | ≥ 555.85                   |
| 12.4.1 | ≥ 550.54.15          | ≥ 551.78                   |
| 11.8.0 | ≥ 520.61.05          | ≥ 520.06                   |

[^5]: [GPU support in Docker Desktop | Docker Docs](https://docs.docker.com/desktop/gpu/)  
[Nvidia GPU Support for Windows · Issue #19005 · containers/podman](https://github.com/containers/podman/issues/19005)

## Supported NVIDIA drivers (LTSB)

Only works with
[NVIDIA Data Center GPUs](https://resources.nvidia.com/l/en-us-gpu) or
[select NGC-Ready NVIDIA RTX boards](https://docs.nvidia.com/certification-programs/ngc-ready-systems/index.html).

| CUDA   | Driver version 535[^6] | Driver version 470[^7] |
|:-------|:----------------------:|:----------------------:|
| 13.0.0 | 🔵                      | 🔴                      |
| 12.9.1 | 🟢                      | 🔵                      |
| 12.9.0 | 🟢                      | 🔵                      |
| 12.8.1 | 🟢                      | 🔵                      |
| 12.8.0 | 🟢                      | 🔵                      |
| 12.6.3 | 🟢                      | 🔵                      |
| 12.6.2 | 🟢                      | 🔵                      |
| 12.6.1 | 🟢                      | 🔵                      |
| 12.6.0 | 🟢                      | 🔵                      |
| 12.5.0 | 🟢                      | 🔵                      |
| 12.4.1 | 🟢                      | 🔵                      |
| 11.8.0 | 🟡                      | 🟢                      |

🔴: Not supported
🔵: Supported with the CUDA forward compat package only  
🟢: Supported due to minor-version compatibility[^8]  
🟡: Supported due to backward compatibility

[^6]: EOL: June 2026  
[^7]: EOL: July 2024
[^8]: or the CUDA forward compat package
