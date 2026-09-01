# Single-Cycle RISC-V Core (RV32I subset)

A single-cycle RISC-V processor implemented in Verilog, verified in
simulation and synthesized/implemented for the Digilent Basys 3
(Xilinx Artix-7, xc7a35tcpg236-1).

This is a baseline implementation, built as a reference point for
future performance comparisons (multicycle, pipelined).

## Supported Instructions

- `ADDI` — add immediate
- `ADD`  — register-register add
- `SW`   — store word
- `LW`   — load word

## Module Overview

| File                     | Description                                  |
|--------------------------|-----------------------------------------------|
| `riscv_top.v`            | Top-level datapath, wires all modules together|
| `program_counter.v`      | PC register and next-PC logic                 |
| `instruction_memory.v`   | 256-word instruction ROM                      |
| `control_unit.v`         | Decodes opcode into control signals           |
| `register_file.v`        | 32x32-bit register file, x0 hardwired to 0    |
| `immediate_generator.v`  | Sign-extends I/S/B-type immediates            |
| `alu_control.v`          | Decodes funct3/funct7 into ALU operation      |
| `alu.v`                  | Arithmetic/logic unit                         |
| `data_memory.v`          | Data memory for load/store                    |
| `basys3_top.v`           | Board wrapper mapping to Basys 3 I/O          |

## Simulation

Testbench: `single_cycle_tb.v`

Test program (hardcoded in `instruction_memory.v`):
```
ADDI x1, x0, 5      // x1 = 5
ADDI x2, x0, 10     // x2 = 10
ADD  x3, x1, x2     // x3 = 15
SW   x3, 0(x0)      // Memory[0] = 15
LW   x4, 0(x0)      // x4 = 15
NOP
```

Expected result, verified in Vivado behavioral simulation:
```
x1 = 5
x2 = 10
x3 = 15
Memory[0] = 15
x4 = 15
```

## Hardware Results (Basys 3)

- Target device: xc7a35tcpg236-1
- Clock: 100 MHz (10 ns period)
- Timing: **Meets timing** — WNS = 0.224 ns, WHS = 0.332 ns, 0 failing endpoints
- Utilization: 330 LUTs (1.59%), 158 registers (0.38%)
- Output: `write_back_data_out[15:0]` displayed on the 16 onboard LEDs
  (expected to show `0000000000001111` = 15, matching `x4`)
- Bitstream generated and ready to program

## Status

- [x] RTL design complete
- [x] Functional simulation verified
- [x] Synthesis clean
- [x] Implementation meets timing
- [x] Bitstream generated
- [ ] **Programmed and verified on physical Basys 3 board** (pending — hardware not yet available)

## Roadmap

- [x] Single-cycle implementation (this repo)
- [ ] Multicycle implementation (FSM-based control, shared instruction/data memory)
- [ ] Pipelined implementation (next major goal)
- [ ] Performance comparison across all three (CPI, clock period, throughput)
