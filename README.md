# Deep Learning Accelerator Generator

The project is developing a deep learning accelerator generator based on systolic array architecture. It is inspired by recent trends in machine learning accelerators for edge and mobile SoCs.

It currently supports unsigned integer and signed integer, and support run-time selection. You are also free to config which type to support at RTL code.
It is planned to support floating-point in the future.

This repo contains the Chisel code for generating the RTL. We plan to write our customized PyTorch backend in the future.

At the heart of the accelerator lies a systolic array (called Tile) which performs matrix multiplications. The processing elements support weight-stationary dataflows.

## Test Tile

```shell
make test-tile
```

## Test Processing Element

```shell
make test-pe
```

## Generate Verilog Code

```shell
make run
```
