# CUDA Version Matrix

Until Julia 1.9.0 is released:

| Julia  | CUDA   | cuBLAS    | cuDNN | NCCL   | TensorRT  | Linux distro |
|:-------|:-------|:----------|:------|:-------|:----------|:-------------|
| 1.8.5  | 11.8.0 | 11.11.3.6 | 8.7.0 | 2.15.5 | 8.5.3[^1] | Ubuntu 22.04 |

After Julia 1.9.0 is released:

| Julia  | CUDA   | cuBLAS    | cuDNN | NCCL   | TensorRT  | Linux distro |
|:-------|:-------|:----------|:------|:-------|:----------|:-------------|
| 1.8.5  | 11.8.0 | 11.11.3.6 | 8.7.0 | 2.16.2 | 8.5.3     | Ubuntu 20.04 |
| 1.9.0  | tbd    | tbd       | tbd   | tbd    | tbd[^1]   | Ubuntu 22.04 |

[^1]: `amd64` only
