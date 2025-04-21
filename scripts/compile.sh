#!/bin/bash
#==============================================================================
# Script: compile.sh
# Description: Compiles all Verilog modules in the correct dependency order
# Usage: ./compile.sh [simulator]
#   simulator: modelsim, vcs, iverilog (default: iverilog)
#==============================================================================

# Configuration
SIMULATOR=${1:-iverilog}
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RTL_DIR="$PROJECT_ROOT/rtl"
SIM_DIR="$PROJECT_ROOT/sim"
BUILD_DIR="$PROJECT_ROOT/build"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create build directory
mkdir -p "$BUILD_DIR"

echo "======================================"
echo "  CryptoKnight Processor Compilation"
echo "  Simulator: $SIMULATOR"
echo "======================================"
echo ""

# Function to compile with ModelSim
compile_modelsim() {
    echo "${YELLOW}Compiling with ModelSim...${NC}"
    
    cd "$BUILD_DIR" || exit 1
    
    # Create library
    vlib work
    
    # Compile files in order
    vlog "$RTL_DIR/common/crypto_pkg.v" || exit 1
    
    # Utilities
    vlog "$RTL_DIR/utils/remainder_calc.v" || exit 1
    vlog "$RTL_DIR/utils/rsa_operation_decoder.v" || exit 1
    vlog "$RTL_DIR/utils/aes_operation_decoder.v" || exit 1
    
    # AES modules
    vlog "$RTL_DIR/crypto/aes/aes_sbox.v" || exit 1
    vlog "$RTL_DIR/crypto/aes/aes_key_expansion.v" || exit 1
    vlog "$RTL_DIR/crypto/aes/aes_core.v" || exit 1
    
    # RSA modules
    vlog "$RTL_DIR/crypto/rsa/karatsuba_mult.v" || exit 1
    vlog "$RTL_DIR/crypto/rsa/rsa_core.v" || exit 1
    
    # Key generation
    vlog "$RTL_DIR/keygen/aes_keygen.v" || exit 1
    vlog "$RTL_DIR/keygen/key_manager.v" || exit 1
    
    # Memory modules
    vlog "$RTL_DIR/memory/instruction_memory.v" || exit 1
    vlog "$RTL_DIR/memory/data_memory.v" || exit 1
    
    # Processor modules
    vlog "$RTL_DIR/processor/program_counter.v" || exit 1
    vlog "$RTL_DIR/processor/instruction_decoder.v" || exit 1
    vlog "$RTL_DIR/processor/register_bank.v" || exit 1
    vlog "$RTL_DIR/processor/data_path.v" || exit 1
    vlog "$RTL_DIR/processor/control_path.v" || exit 1
    
    # Top-level crypto
    vlog "$RTL_DIR/crypto/crypto_controller.v" || exit 1
    
    # Top-level processor
    vlog "$RTL_DIR/processor/risc_top.v" || exit 1
    
    echo "${GREEN}✓ ModelSim compilation complete${NC}"
}

# Function to compile with VCS
compile_vcs() {
    echo "${YELLOW}Compiling with VCS...${NC}"
    
    cd "$BUILD_DIR" || exit 1
    
    vcs -full64 -sverilog -timescale=1ns/1ps \
        "$RTL_DIR/common/crypto_pkg.v" \
        "$RTL_DIR/utils/*.v" \
        "$RTL_DIR/crypto/aes/*.v" \
        "$RTL_DIR/crypto/rsa/*.v" \
        "$RTL_DIR/keygen/*.v" \
        "$RTL_DIR/memory/*.v" \
        "$RTL_DIR/processor/*.v" \
        "$RTL_DIR/crypto/crypto_controller.v" \
        -o crypto_processor_sim || exit 1
    
    echo "${GREEN}✓ VCS compilation complete${NC}"
}

# Function to compile with Icarus Verilog
compile_iverilog() {
    echo "${YELLOW}Compiling with Icarus Verilog...${NC}"
    
    cd "$BUILD_DIR" || exit 1
    
    # Create file list (excluding sub-modules that are included in aes_core.v)
    # Note: Using key_manager_stub.v instead of full keygen (requires Xilinx IP)
    cat > files.list << EOF
$RTL_DIR/common/crypto_pkg.v
$RTL_DIR/utils/remainder_calc.v
$RTL_DIR/utils/rsa_operation_decoder.v
$RTL_DIR/utils/aes_operation_decoder.v
$RTL_DIR/crypto/aes/aes_core.v
$RTL_DIR/crypto/rsa/karatsuba_mult.v
$RTL_DIR/crypto/rsa/rsa_core.v
$RTL_DIR/keygen/key_manager_stub.v
$RTL_DIR/memory/instruction_memory.v
$RTL_DIR/memory/data_memory.v
$RTL_DIR/processor/program_counter.v
$RTL_DIR/processor/instruction_decoder.v
$RTL_DIR/processor/register_bank.v
$RTL_DIR/processor/data_path.v
$RTL_DIR/processor/control_path.v
$RTL_DIR/crypto/crypto_controller.v
$RTL_DIR/processor/risc_top.v
EOF
    
    # Compile with include path (using Verilog-2005 to avoid "new" keyword conflict)
    iverilog -g2005 -I"$PROJECT_ROOT" -o crypto_processor.vvp -c files.list || exit 1
    
    echo "${GREEN}✓ Icarus Verilog compilation complete${NC}"
    echo "   Output: $BUILD_DIR/crypto_processor.vvp"
}

# Main compilation based on simulator choice
case "$SIMULATOR" in
    modelsim|vsim)
        compile_modelsim
        ;;
    vcs)
        compile_vcs
        ;;
    iverilog|icarus)
        compile_iverilog
        ;;
    *)
        echo "${RED}Error: Unknown simulator '$SIMULATOR'${NC}"
        echo "Supported: modelsim, vcs, iverilog"
        exit 1
        ;;
esac

echo ""
echo "${GREEN}======================================"
echo "  Compilation Successful!"
echo "======================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Run simulation: ./scripts/simulate.sh"
echo "  2. Or synthesize for FPGA"
echo ""

exit 0
