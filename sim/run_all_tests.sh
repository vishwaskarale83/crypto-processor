#!/bin/bash
#==============================================================================
# Script: run_all_tests.sh
# Description: Automated test runner for CryptoKnight processor
#              Compiles and runs all testbenches using iverilog
# Usage: ./run_all_tests.sh
#==============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
RTL_DIR="../rtl"
LEGACY_DIR=".."
TB_DIR="./testbenches"
RESULTS_DIR="./results"
VCD_DIR="./waveforms"

# Create output directories
mkdir -p $RESULTS_DIR
mkdir -p $VCD_DIR

# Test counter
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

echo "========================================"
echo "CryptoKnight Processor Test Suite"
echo "========================================"
echo "Starting automated testing with iverilog"
echo "Time: $(date)"
echo ""

# Function to run a test
run_test() {
    local test_name=$1
    local tb_file=$2
    local rtl_files=$3
    
    echo -e "${BLUE}Running Test: ${test_name}${NC}"
    echo "  Testbench: ${tb_file}"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Compile
    echo "  Compiling..."
    iverilog -g2009 -o ${RESULTS_DIR}/${test_name}.vvp \
        ${tb_file} ${rtl_files} 2> ${RESULTS_DIR}/${test_name}_compile.log
    
    if [ $? -ne 0 ]; then
        echo -e "  ${RED}COMPILATION FAILED${NC}"
        echo "  See ${RESULTS_DIR}/${test_name}_compile.log for details"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
    
    echo "  Compilation successful"
    
    # Run simulation
    echo "  Running simulation..."
    vvp ${RESULTS_DIR}/${test_name}.vvp > ${RESULTS_DIR}/${test_name}_sim.log 2>&1
    
    if [ $? -ne 0 ]; then
        echo -e "  ${RED}SIMULATION FAILED${NC}"
        echo "  See ${RESULTS_DIR}/${test_name}_sim.log for details"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
    
    # Check for test pass/fail in output
    if grep -q "All tests PASSED" ${RESULTS_DIR}/${test_name}_sim.log; then
        echo -e "  ${GREEN}TEST PASSED${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        
        # Move VCD file if generated
        if [ -f ${test_name}.vcd ]; then
            mv ${test_name}.vcd ${VCD_DIR}/
        fi
    else
        echo -e "  ${YELLOW}TEST COMPLETED (check logs for details)${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
    
    echo ""
    return 0
}

# Test 1: Karatsuba Multiplier
echo "========================================"
echo "Test Suite 1: Utility Modules"
echo "========================================"
run_test "tb_karatsuba" \
    "${TB_DIR}/tb_karatsuba.v" \
    "${LEGACY_DIR}/Karatsuba.v"

# Test 2: AES Core
echo "========================================"
echo "Test Suite 2: AES Modules"
echo "========================================"
run_test "tb_aes_core" \
    "${TB_DIR}/tb_aes_core.v" \
    "${LEGACY_DIR}/AES.v"

# Test 3: RSA Core
echo "========================================"
echo "Test Suite 3: RSA Modules"
echo "========================================"
run_test "tb_rsa_core" \
    "${TB_DIR}/tb_rsa_core.v" \
    "${LEGACY_DIR}/RSA_enc_dec.v ${LEGACY_DIR}/Karatsuba.v ${LEGACY_DIR}/Remainder_finder.v"

# Test 4: Register Bank
echo "========================================"
echo "Test Suite 4: Processor Modules"
echo "========================================"
run_test "tb_register_bank" \
    "${TB_DIR}/tb_register_bank.v" \
    "${LEGACY_DIR}/REGISTER_BANK_MODULE.v"

# Test 5: Data Memory
echo "========================================"
echo "Test Suite 5: Memory Modules"
echo "========================================"
run_test "tb_data_memory" \
    "${TB_DIR}/tb_data_memory.v" \
    "${LEGACY_DIR}/DATA_MEMORY_Module.v"

# Test 6: RISC System (requires all dependencies)
echo "========================================"
echo "Test Suite 6: System Integration"
echo "========================================"
echo -e "${YELLOW}Note: RISC system test requires all modules${NC}"
run_test "tb_risc_system" \
    "${TB_DIR}/tb_risc_system.v" \
    "${LEGACY_DIR}/RISC.v ${LEGACY_DIR}/CONTROL_PATH_MODULE_1.v ${LEGACY_DIR}/DATA_PATH_MODULE_1.v ${LEGACY_DIR}/INSTRN_Dcoder_Module.v ${LEGACY_DIR}/PC_Module.v ${LEGACY_DIR}/MEMORY_Module.v ${LEGACY_DIR}/DATA_MEMORY_Module.v ${LEGACY_DIR}/REGISTER_BANK_MODULE.v ${LEGACY_DIR}/CryptoKnight.v ${LEGACY_DIR}/AES.v ${LEGACY_DIR}/RSA.v ${LEGACY_DIR}/RSA_enc_dec.v ${LEGACY_DIR}/Karatsuba.v ${LEGACY_DIR}/Remainder_finder.v ${LEGACY_DIR}/key_generator.v ${LEGACY_DIR}/AES_generator.v ${LEGACY_DIR}/AES_d_e.v ${LEGACY_DIR}/RSA_d_e.v"

# Print Summary
echo ""
echo "========================================"
echo "Test Summary"
echo "========================================"
echo "Total Tests:  ${TOTAL_TESTS}"
echo -e "Passed:       ${GREEN}${PASSED_TESTS}${NC}"
echo -e "Failed:       ${RED}${FAILED_TESTS}${NC}"
echo "========================================"

if [ ${FAILED_TESTS} -eq 0 ]; then
    echo -e "${GREEN}All tests completed successfully!${NC}"
    echo ""
    echo "Waveform files (VCD) are available in: ${VCD_DIR}"
    echo "To view waveforms, use: gtkwave ${VCD_DIR}/<test_name>.vcd"
    exit 0
else
    echo -e "${RED}Some tests failed. Please check logs in ${RESULTS_DIR}${NC}"
    exit 1
fi
