# EGCP 447 — Hamming (7,4) ECC on the Arty Z7

Registered Hamming (7,4) encoder and decoder with single-bit error correction,
error injection from push buttons, and a syndrome display on RGB LED4.

## Layout

| Folder | Contents |
|---|---|
| `src/` | `hamming_encoder.v`, `hamming_decoder.v`, `hamming_system.v`, `hamming_top.v` |
| `sim/` | Self-checking testbenches for the encoder, decoder and full system |
| `constraints/` | `arty_z7_hamming.xdc` (clk, sw, btn, led, RGB LED4) |
| `vivado/` | Vivado project (not tracked by git) |

## Conventions

- `data[3:0] = {d1, d2, d3, d4}`
- `codeword[6:0] = {p1, p2, d1, p3, d2, d3, d4}`; position k (1..7, left to right) is bit `7-k`
- `syndrome[2:0] = {s3, s2, s1}`; its value is the error position
- BTN2 flips position 1 (p1), BTN3 flips position 5 (d2)

## Vivado setup

1. Create the project inside `vivado/`. Part: `xc7z020clg400-1` (Z7-20) or `xc7z010clg400-1` (Z7-10).
2. Add `src/*.v` as design sources and `constraints/arty_z7_hamming.xdc` as constraints,
   with **Copy sources into project unchecked** so edits land in this repo.
3. Add `sim/*.v` as simulation sources. Set a testbench as top and run Behavioral Simulation;
   each prints `TEST PASSED` in the Tcl console.
