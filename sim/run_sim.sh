#!/bin/bash
# =============================================================================
# run_sim.sh -- Icarus Verilog simulation script for RV32I pipeline
#
# Usage:
#   chmod +x run_sim.sh
#   ./run_sim.sh
#
# Requirements:
#   - Icarus Verilog (iverilog) version 10+ in PATH
#   - GTKWave for waveform viewing (optional)
#
# Output:
#   rv32i_pipeline.vcd  -- waveform dump (open with GTKWave)
#   sim.log             -- simulation console output
# =============================================================================

set -e

echo "Compiling..."
iverilog -o rv32i_sim.vvp \
    -g2005 \
    ../rtl/alu.v \
    ../rtl/control.v \
    ../rtl/forward_unit.v \
    ../rtl/hazard_unit.v \
    ../rtl/regfile.v \
    ../rtl/rv32i_pipeline.v \
    ../tb/rv32i_pipeline_tb.v

echo "Running simulation..."
vvp rv32i_sim.vvp | tee sim.log

echo ""
echo "Done. Check sim.log for register/memory output."
echo "To view waveform: gtkwave rv32i_pipeline.vcd"
