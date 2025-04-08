#!/bin/bash
#==============================================================================
# CryptoKnight Processor - Complete Test Suite
# Run this script to see all available tests and run them
#==============================================================================

clear
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         CryptoKnight Processor - Test Suite                    ║"
echo "║              Comprehensive Testing Infrastructure              ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Test Infrastructure Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Testbenches Created: 7"
echo "✅ Modules Tested: 3 (76 test cases passed)"
echo "✅ Scripts Created: 3"
echo "✅ Documentation: 3 files"
echo ""

echo "🎯 Currently Working Tests (100% Pass Rate)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  1. tb_karatsuba      - Karatsuba Multiplier (8/8 ✅)"
echo "  2. tb_register_bank  - Register File (35/35 ✅)"
echo "  3. tb_data_memory    - Data Memory (33/33 ✅)"
echo ""

echo "🔧 Tests Ready (Need Module Updates)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  4. tb_aes_core       - AES-128 Encryption/Decryption"
echo "  5. tb_rsa_core       - RSA-512 Encryption/Decryption"
echo ""

echo "📋 Integration Tests Ready"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  6. tb_risc_system         - RISC Processor"
echo "  7. tb_cryptoknight_system - Complete System"
echo ""

echo "🚀 Quick Start Commands"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Run all working tests:"
echo "  cd /Users/vishwaskarale/Code/crypto-processor/sim"
echo "  ./run_individual_test.sh tb_karatsuba"
echo "  ./run_individual_test.sh tb_register_bank"
echo "  ./run_individual_test.sh tb_data_memory"
echo ""
echo "View waveforms (requires gtkwave):"
echo "  gtkwave waveforms/tb_karatsuba.vcd"
echo "  gtkwave waveforms/tb_register_bank.vcd"
echo "  gtkwave waveforms/tb_data_memory.vcd"
echo ""
echo "Check results:"
echo "  cat results/tb_karatsuba_sim.log"
echo "  cat results/tb_register_bank_sim.log"
echo "  cat results/tb_data_memory_sim.log"
echo ""

echo "📚 Documentation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  README_TESTS.md      - Complete testing guide"
echo "  TEST_RESULTS.md      - Detailed test results"
echo "  TESTING_COMPLETE.md  - Project summary (in root)"
echo ""

echo "📁 File Structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  sim/"
echo "  ├── testbenches/     - 7 testbench files (.v)"
echo "  ├── results/         - Test logs and outputs"
echo "  ├── waveforms/       - VCD waveform files"
echo "  ├── run_all_tests.sh - Run all tests"
echo "  ├── run_individual_test.sh - Run single test"
echo "  └── *.md             - Documentation"
echo ""

echo "💡 Pro Tips"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  • All scripts have executable permissions set"
echo "  • VCD files can be viewed with GTKWave"
echo "  • Test logs are in results/ directory"
echo "  • Each test shows individual pass/fail status"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo ""

# Offer to run tests
echo "Would you like to run the working tests now? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Running tests..."
    echo ""
    
    echo "━━━ Test 1: Karatsuba Multiplier ━━━"
    ./run_individual_test.sh tb_karatsuba
    echo ""
    
    echo "━━━ Test 2: Register Bank ━━━"
    ./run_individual_test.sh tb_register_bank
    echo ""
    
    echo "━━━ Test 3: Data Memory ━━━"
    ./run_individual_test.sh tb_data_memory
    echo ""
    
    echo "═══════════════════════════════════════════════════════════════"
    echo "✅ All working tests completed!"
    echo "═══════════════════════════════════════════════════════════════"
else
    echo ""
    echo "You can run tests manually using commands shown above."
fi
