# Xinchen Branch - KIRA Run Results

This branch contains the successfully generated kira_run directories for 2L electroweak-QCD box calculations.

## Directory Structure

- **2L_Box_A_G/kira_run/** - Box diagram with photon
- **2L_Box_A_Z_G/kira_run/** - Box diagram with photon and Z-boson
- **2L_Box_Z_G/kira_run/** - Box diagram with Z-boson

## Scalar Integrals Summary

| Directory | Scalar Integrals | Topologies |
|-----------|------------------|------------|
| 2L_Box_A_G | 1411 | 4 (A1$134, C1$37, D1$196, D1$37) |
| 2L_Box_A_Z_G | 908 | 4 (A2$4642, C2$1717, D2$1717, D2$6094) |
| 2L_Box_Z_G | 908 | 4 (A2$4642, C2$1717, D2$1717, D2$6094) |

## Generation Details

- **Process**: u ū → t t̄ (two-loop electroweak-QCD box diagrams)
- **Framework**: ABISS (Amplitudes Builder, Interference Solver and Simplifier)
- **Parameter range**: i=[1,31], j=[1,2]
- **Generation date**: December 2025

## Usage

Each kira_run directory contains:
- Individual topology folders with KIRA configuration files
- master_integrals configuration
- Shell scripts for running KIRA reduction

To run KIRA reduction:
```bash
cd 2L_Box_A_G/kira_run/
bash run_kira.sh
```

## Notes

- These results correspond to three successfully completed box diagram calculations
- The 2L_Box_W_G diagram was excluded due to ABISS framework limitations with dimensional counter-terms
