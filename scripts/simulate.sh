#!/bin/bash
#==============================================================================
# Script: simulate.sh
# Description: Runs simulation with specified testbench
# Usage: ./simulate.sh [testbench] [simulator]
#   testbench: name of test (default: all)
#   simulator: modelsim, vcs, iverilog (default: iverilog)
#==============================================================================

# Configuration
TESTBENCH=${1:-all}
SIMULATOR=${2:-iverilog}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build"
SIM_DIR="$PROJECT_ROOT/sim"
TB_DIR="$SIM_DIR/testbenches"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "======================================"
echo "  CryptoKnight Processor Simulation"
echo "  Testbench: $TESTBENCH"
echo "  Simulator: $SIMULATOR"
echo "======================================"
echo ""

# Check if compilation has been done
if [ ! -d "$BUILD_DIR" ]; then
    echo "${YELLOW}Build directory not found. Running compilation first...${NC}"
    "$PROJECT_ROOT/scripts/compile.sh" "$SIMULATOR" || exit 1
fi

# Function to run ModelSim simulation
simulate_modelsim() {
    echo "${YELLOW}Running ModelSim simulation...${NC}"
    
    cd "$BUILD_DIR" || exit 1
    
    if [ "$TESTBENCH" = "all" ]; then
        echo "Running all testbenches..."
        # Add testbench compilation and simulation here
        echo "${BLUE}Note: Testbenches need to be implemented${NC}"
    else
        echo "Running testbench: $TESTBENCH"
        # vsim -do "run -all; quit" "$TESTBENCH"
        echo "${BLUE}Note: Testbench $TESTBENCH needs to be implemented${NC}"
    fi
}

# Function to run VCS simulation
simulate_vcs() {
    echo "${YELLOW}Running VCS simulation...${NC}"
    
    cd "$BUILD_DIR" || exit 1
    
    if [ -f "./crypto_processor_sim" ]; then
        ./crypto_processor_sim || exit 1
        echo "${GREEN}✓ VCS simulation complete${NC}"
    else
        echo "${RED}Error: Simulation executable not found${NC}"
        echo "Run ./scripts/compile.sh vcs first"
        exit 1
    fi
}

# Function to run Icarus Verilog simulation
simulate_iverilog() {
    echo "${YELLOW}Running Icarus Verilog simulation...${NC}"
    
    cd "$BUILD_DIR" || exit 1
    
    if [ -f "./crypto_processor.vvp" ]; then
        vvp crypto_processor.vvp || exit 1
        echo "${GREEN}✓ Icarus Verilog simulation complete${NC}"
    else
        echo "${RED}Error: Compiled VVP file not found${NC}"
        echo "Run ./scripts/compile.sh iverilog first"
        exit 1
    fi
}

# Main simulation based on simulator choice
case "$SIMULATOR" in
    modelsim|vsim)
        simulate_modelsim
        ;;
    vcs)
        simulate_vcs
        ;;
    iverilog|icarus)
        simulate_iverilog
        ;;
    *)
        echo "${RED}Error: Unknown simulator '$SIMULATOR'${NC}"
        echo "Supported: modelsim, vcs, iverilog"
        exit 1
        ;;
esac

echo ""
echo "${GREEN}======================================"
echo "  Simulation Complete!"
echo "======================================${NC}"
echo ""

# Check for waveform files
if [ -f "$BUILD_DIR/dump.vcd" ]; then
    echo "Waveform file generated: $BUILD_DIR/dump.vcd"
    echo "View with: gtkwave $BUILD_DIR/dump.vcd"
    echo ""
fi

exit 0
