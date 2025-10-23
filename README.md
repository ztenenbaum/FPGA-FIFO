# FPGA-FIFO
A parameterized synchronous/asynchronous FIFO (First-In-First-Out) buffer written in Verilog for FPGA or ASIC design.
Includes simulation testbenches and waveform verification.

## Features
* Configurable width and depth 
* Supports synchronous and asynchronous versions 
* Overflow and underflow protection 
* Simple testbench with Verilator or Icarus Verilog 

## Directory Structure
* src — Verilog source files
* sim — Testbench for simulation and waveform creation  

## To run the testbench using Icarus Verilog:
* cd sim
* ./run.sh
