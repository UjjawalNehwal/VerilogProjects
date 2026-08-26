# Digital Design with Verilog (Vivado)

# Verilog & FPGA Projects

A repository containing my Verilog HDL modules, testbenches, and Vivado project files as I learn digital circuit design.

## Tools Used
* HDL Language: Verilog
* IDE & Simulator: Xilinx Vivado

## Repository Structure

### Basics
* TEST - Logic Gates implementation and testbench.
* HalfAdder_GateLevel - Half Adder implementation along with testbench using the Gate Level Modelling.
* HalfAdder_DataFlow - Half Adder implementation along with testbench using the Data Flow Modelling.
* HalfAdder_Behavioural - Half Adder implementation along with testbench using the Behavioural Modelling.

### Combinational Logic
* **Mux21** - 2-to-1 Multiplexer implemented using the ternary operator (`assign Y = Sel ? B : A`).
* **Mux21Case** - 2-to-1 Multiplexer implemented using a `case` statement inside `always @(*)`.
* **PriorityEncoder42** - 4-to-2 Priority Encoder with an external `Valid` control input; resolves priority using an `if-else if` chain, gated so input checks only occur when `Valid` is high. Includes a `casez`/`casex` based alternative using wildcard matching.
* **Decoder38** - 3-to-8 Decoder with an `Enable` control input; implemented via a `case` statement, with an alternate elegant version using the left-shift operator (`Y = 8'b00000001 << Sel`).
* **FullAdder** - 1-bit Full Adder using Data Flow modelling (`Sum = A^B^Cin`, `Cout = majority function`).
* **RippleCarryAdder** - 4-bit Ripple Carry Adder. Implemented in two ways:
  * Structural version: four `FullAdder` instances chained together, each stage's carry-out feeding the next stage's carry-in.
  * Behavioural version: single-line arithmetic (`assign {Cout, Sum} = A + B + Cin`), letting the tool infer the adder logic.
* **CarryLookaheadAdder** - 4-bit Carry Lookahead Adder. Computes Generate (`G = A & B`) and Propagate (`P = A ^ B`) signals for all bits in parallel, then derives every carry bit directly from `G`, `P`, and `Cin` (no stage waits on a previous stage), trading extra gate logic for significantly lower propagation delay compared to the ripple carry version.
* **ParaALU** - Parametrized Arithmetic Logic Unit (default `WIDTH = 4`, overridable at instantiation). Supports:
  * Add, Subtract (with `Carry`/borrow output to prevent silent overflow truncation)
  * Bitwise AND, OR, XOR, XNOR
  * NOT (`~A` and `~B` computed simultaneously, output via `Result` and `ResultHigh`)
  * Multiply (full `2×WIDTH`-bit product split across `ResultHigh`/`Result`)
  * `Zero` flag, asserted whenever `Result` is all-zero — mirrors how real CPUs reuse ALU subtraction for equality/branch checks.
* **Comparator4Bit** - 4-bit Magnitude Comparator using Verilog's relational operators (`>`, `==`, `<`) to produce mutually exclusive `GT`, `EQ`, `LT` outputs.
* **ParityGenerator** - Computes an even-parity bit for 4-bit data using the reduction XOR operator (`ParityBit = ^Data`), which evaluates to 1 whenever the data contains an odd number of 1s.
* **ParityChecker** - Verifies received data + parity bit for corruption by recomputing reduction XOR over the concatenated pair (`Error = ^{Data, ParityBit}`); flags an error whenever an odd number of bits (data or parity) have been corrupted. Cannot detect an even number of simultaneous bit-flips, a known limitation of simple parity schemes.

## How to Run
1. Open Vivado.
2. Go to File -> Open Project and select the .xpr file from any project directory.
3. Run Simulation or Synthesis directly from the Flow Navigator.
