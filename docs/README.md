# Developer Guide for the MorphoSysII Reconfigurable Domain-Specific Processor Generator

Note: as the project is under active development, this guide is not finalized and subjects to change.

> I'm not making another MorphoSys. I'm not making another Gemmini. I'm going beyond these two.

## Introduction

### Goal

The MorphoSysII project is **a reconfigurable domain-sprcific accelerator generator** written in Chisel hardware construction language and targeted at data-parallel and computation-intensive applications.

Being a highly parameterized generator, MorphoSysII allows user to customize the components and generate synthesizable RTL code to meet their unique and specific requirements.

Though being developed initially as a general-purpose architecture, MorphoSysII can be configured as a domain-specific coprocessor for many data-parallel applications such as:

- Systolic Array-based Deep Learning Accelerator
- Discrete Cosine Transform Accelerator
- H265/HEVC Motion Estimation Accelerator

### Principles

MorphoSysII adopts an **agile hardware development** methodology to build energy-efficient, cost-effective, and competitive high-performance domain-specific accelerators. The project follows the principles to meet the requirements of agile hardware design:

- Reusability: MorphoSysII focuses on reusable components instead of a single instance.
- Modularity: The modules are decoupled as possible, allowing great flexibility of customization.
- Standardized Interface: MorphoSysII uses standardized data types and width to eliminate compatilibity problems and conversion overhead.

## History

### The Original HPDLA Project

Actually the MorphoSysII is iterated from a previous project - the High-Precision Deep Learning Accelerator aiming at build a systolic array-based processor that can accelerate matrix multiplication operations.

### The Original MorphoSys SoC

Being published in 2000, the original MorphoSys Reconfigurable COmputing Processor has a history of 20 years! The design of MorphoSys is stylish, foresighted, and future-proof. The design of MorphoSysII is greatly inspired by the original MorphoSys SoC.

The original MorphoSys SoC consists of 5 major components:

#### RC Array

It's an array of erconfigurable cells (RCs) or processing elements (PEs). The shape of the original design is fixed to (8, 8) arranged as a two-dimentional matrix. The RC Array follows the SIMD model of computation. All RCs in the same row/column share same instruction (context) but operate on different data.

#### TinyRISC Control Processor

It's a 4-stage scalar MIPS-like processor featuring a 32-bit ALU. It uses modified TinyRISC ISA.

#### High-speed Memory Interface

It consists of a streaming buffer and a DMA controller to transfer data to the RC Array.

#### Context Memory

It stores context for RC array. MorphoSys supports single-cycle dynamic reconfiguration.

## Microarchitecture

### ALU

Context format:
(From LSB)
| Field       | Width (bit)   | Type         | Depends on      | Comments                    |
|-------------|---------------|--------------|-----------------|-----------------------------|
| Weight      | 16/32         | UInt/SInt/FP |                 | Input*Weight+PartialSum     |
| ALU_OP      | 4             | UInt         |                 |                             |
| MUX_B       | #Reg+#Conn     | UInt         | Interconnection | Select the source of B      |
| MUX_A       | #Reg+#Conn | UInt         | Interconnection | Select the source of A      |
| ALU_SFT     | 1             | Boolean      |                 | Whether to shift the result |
| SFT_Left    | 1             | Boolean      |                 | Shift left, otherwise right |
| Reg_File | TDB             | UInt      | TBD             | TBD                         |
| Write_RF_En | 1             | Boolean      | TBD             | TBD                         |
| Write_EXPR  | 1             | UInt         | TBD             | TBD                         |

RC functions:

| Instruction     | Description            | Apply to     |
|-----------------|------------------------|--------------|
| OR, AND, XOR    | Two-operand Logic      | A, B, Weight |
| + -             | Two-operand Arithmetic | A, B, Weight |
| *               | Two-operand Mult       | A, B, Weight |
| A*Weight+B      | Multiply-accumulate    | A, B, Weight |
| abs(A-B)        | Absolute difference    | A, B, Weight |
| A if A>0 else 0 | ReLU                   | A, B, Weight |
| Max(A,B)        | Max Pooling            | A, B, Weight |

Shift is NOT done by ALU!

### Tile: Reconfigurable Cell Array

### TileLink: Interconnection
