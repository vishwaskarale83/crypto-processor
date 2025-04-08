#!/bin/bash
#==============================================================================
# Script: run_individual_test.sh
# Description: Run a single testbench with iverilog
# Usage: ./run_individual_test.sh <test_name>
#        Example: ./run_individual_test.sh tb_aes_core
#==============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check argument
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No test name provided${NC}"
    echo "Usage: $0 <test_name>"
    echo ""
    echo "Available tests:"
    echo "  - tb_karatsuba"
    echo "  - tb_aes_core"
    echo "  - tb_rsa_core"
    echo "  - tb_register_bank"
    echo "  - tb_data_memory"
    echo "  - tb_risc_system"
    echo "  - tb_cryptoknight_system"
    exit 1
fi

TEST_NAME=$1
TB_DIR="./testbenches"
LEGACY_DIR=".."
RESULTS_DIR="./results"
VCD_DIR="./waveforms"

mkdir -p $RESULTS_DIR
mkdir -p $VCD_DIR

echo "========================================"
echo "Running Individual Test: ${TEST_NAME}"
echo "========================================"

# Determine required files based on test name
case ${TEST_NAME} in
    "tb_karatsuba")
        RTL_FILES="${LEGACY_DIR}/Karatsuba.v"
        ;;
    "tb_aes_core")
        RTL_FILES="${LEGACY_DIR}/AES.v"
        ;;
    "tb_rsa_core")
        RTL_FILES="${LEGACY_DIR}/RSA_enc_dec.v ${LEGACY_DIR}/Karatsuba.v ${LEGACY_DIR}/Remainder_finder.v"
        ;;
    "tb_register_bank")
        RTL_FILES="${LEGACY_DIR}/REGISTER_BANK_MODULE.v"
        ;;
    "tb_data_memory")
        RTL_FILES="${LEGACY_DIR}/DATA_MEMORY_Module.v"
        ;;
    "tb_risc_system")
        RTL_FILES="${LEGACY_DIR}/RISC.v ${LEGACY_DIR}/CONTROL_PATH_MODULE_1.v ${LEGACY_DIR}/DATA_PATH_MODULE_1.v ${LEGACY_DIR}/INSTRN_Dcoder_Module.v ${LEGACY_DIR}/PC_Module.v ${LEGACY_DIR}/MEMORY_Module.v ${LEGACY_DIR}/DATA_MEMORY_Module.v ${LEGACY_DIR}/REGISTER_BANK_MODULE.v ${LEGACY_DIR}/CryptoKnight.v ${LEGACY_DIR}/AES.v ${LEGACY_DIR}/RSA.v ${LEGACY_DIR}/RSA_enc_dec.v ${LEGACY_DIR}/Karatsuba.v ${LEGACY_DIR}/Remainder_finder.v ${LEGACY_DIR}/key_generator.v ${LEGACY_DIR}/AES_generator.v ${LEGACY_DIR}/AES_d_e.v ${LEGACY_DIR}/RSA_d_e.v"
        ;;
    "tb_cryptoknight_system")
        RTL_FILES="${LEGACY_DIR}/*.v"
        ;;
    *)
        echo -e "${RED}Unknown test: ${TEST_NAME}${NC}"
        exit 1
        ;;
esac

# Compile
echo "Compiling..."
iverilog -g2009 -o ${RESULTS_DIR}/${TEST_NAME}.vvp \
    ${TB_DIR}/${TEST_NAME}.v ${RTL_FILES} \
    2> ${RESULTS_DIR}/${TEST_NAME}_compile.log

if [ $? -ne 0 ]; then
    echo -e "${RED}COMPILATION FAILED${NC}"
    echo "Error log:"
    cat ${RESULTS_DIR}/${TEST_NAME}_compile.log
    exit 1
fi

echo -e "${GREEN}Compilation successful${NC}"

# Run simulation
echo "Running simulation..."
vvp ${RESULTS_DIR}/${TEST_NAME}.vvp | tee ${RESULTS_DIR}/${TEST_NAME}_sim.log

# Move VCD file
if [ -f ${TEST_NAME}.vcd ]; then
    mv ${TEST_NAME}.vcd ${VCD_DIR}/
    echo ""
    echo -e "${GREEN}Waveform saved to: ${VCD_DIR}/${TEST_NAME}.vcd${NC}"
    echo "View with: gtkwave ${VCD_DIR}/${TEST_NAME}.vcd"
fi

echo ""
echo "Simulation output saved to: ${RESULTS_DIR}/${TEST_NAME}_sim.log"
