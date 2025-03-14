# CryptoKnight Processor

[![CI - Compile and Test](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/ci.yml)
[![Nightly Build](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/nightly.yml/badge.svg)](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/nightly.yml)
[![Release Build](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/release.yml/badge.svg)](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/release.yml)

A hardware cryptographic processor combining a custom RISC processor with AES-128 and RSA-512 encryption/decryption accelerators.

## Overview

The CryptoKnight processor is a Verilog-based system-on-chip that provides:
- Custom RISC processor with crypto-specific instruction set
- Hardware-accelerated AES-128 encryption/decryption
- Hardware-accelerated RSA-512 encryption/decryption  
- Dynamic key generation for both algorithms
- Buffered operation queue for concurrent crypto requests

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      RISC Processor Top                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Control     │  │   Data       │  │  Instruction │      │
│  │  Path FSM    │──│   Path       │──│  Decoder     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         │                 │                   │              │
│         └─────────────────┴───────────────────┘              │
│                           │                                  │
│  ┌────────────────────────┴────────────────────────┐        │
│  │             CryptoKnight Controller              │        │
│  │   ┌────────────┐              ┌────────────┐    │        │
│  │   │    AES     │              │    RSA     │    │        │
│  │   │   Engine   │              │   Engine   │    │        │
│  │   └────────────┘              └────────────┘    │        │
│  │                                                  │        │
│  │   ┌─────────────────────────────────┐          │        │
│  │   │      Key Generator              │          │        │
│  │   │  (AES-128 & RSA-512 keys)       │          │        │
│  │   └─────────────────────────────────┘          │        │
│  └──────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

## Directory Structure

```
crypto-processor/
├── README.md                    # This file
├── docs/                        # Documentation
│   ├── architecture.md          # System architecture details
│   ├── api_reference.md         # Module interface reference
│   ├── timing_diagrams/         # Timing diagrams
│   └── state_machines/          # FSM documentation
├── rtl/                         # RTL source code
│   ├── common/                  # Shared definitions
│   │   └── crypto_pkg.v         # Global parameters & constants
│   ├── processor/               # RISC processor modules
│   │   ├── risc_top.v           # Top-level RISC module
│   │   ├── control_path.v       # Control FSM
│   │   ├── data_path.v          # Data path
│   │   ├── instruction_decoder.v # Instruction decoder
│   │   ├── program_counter.v    # PC management
│   │   └── register_bank.v      # Register file
│   ├── memory/                  # Memory modules
│   │   ├── instruction_memory.v # Instruction storage
│   │   └── data_memory.v        # Data storage
│   ├── crypto/                  # Cryptographic modules
│   │   ├── crypto_controller.v  # Main crypto controller
│   │   ├── aes/                 # AES implementation
│   │   │   ├── aes_core.v       # Main AES module
│   │   │   ├── aes_key_expansion.v
│   │   │   └── aes_sbox.v       # S-box tables
│   │   └── rsa/                 # RSA implementation
│   │       ├── rsa_core.v       # Unified RSA enc/dec
│   │       ├── rsa_legacy.v     # Original implementation
│   │       └── karatsuba_mult.v # Fast multiplication
│   ├── keygen/                  # Key generation
│   │   ├── key_manager.v        # Key management
│   │   └── aes_keygen.v         # AES key generator
│   └── utils/                   # Utility modules
│       ├── rsa_operation_decoder.v
│       ├── aes_operation_decoder.v
│       └── remainder_calc.v
├── sim/                         # Simulation files
│   ├── testbenches/             # Test benches
│   └── test_vectors/            # Test data
├── scripts/                     # Build & simulation scripts
│   ├── compile.sh               # Compilation script
│   └── simulate.sh              # Simulation script
├── synthesis/                   # Synthesis files
│   ├── constraints/             # Timing constraints
│   └── reports/                 # Synthesis reports
└── legacy/                      # Original files (archived)
```

## Features

### Supported Algorithms
- **AES-128**: Standard AES encryption/decryption with 128-bit keys
- **RSA-512**: RSA encryption/decryption with 512-bit keys
- **Key Generation**: Dynamic generation of cryptographic keys

### Performance
- **AES Latency**: ~12 clock cycles per operation
- **RSA Latency**: ~500 clock cycles per operation
- **Operation Buffering**: Up to 9 concurrent operations
- **Key Generation**: On-demand or automatic refresh

## CI/CD Pipeline

This project uses GitHub Actions for automated continuous integration and deployment:

### Workflows

#### 1. **CI - Compile and Test** (`.github/workflows/ci.yml`)
Runs on every push and pull request to main branches:
- **Compile Job**: Compiles all RTL modules using Icarus Verilog
- **Test Job**: Runs all testbenches and generates test reports
- **Syntax Check**: Validates Verilog syntax for all files
- **Lint Job**: Runs Verilator linting for code quality

#### 2. **Nightly Build** (`.github/workflows/nightly.yml`)
Scheduled comprehensive testing every night:
- Full test suite execution with detailed logging
- Performance benchmarking of all modules
- Code quality analysis and statistics
- Documentation verification

#### 3. **Release Build** (`.github/workflows/release.yml`)
Triggered on version tags (e.g., `v1.0.0`):
- Complete test validation before release
- Automatic package creation (tar.gz and zip)
- Synthesis compatibility checks
- GitHub release creation with artifacts

### Docker Images Used

The CI/CD pipeline uses the following Docker images:
- **`hdlc/sim:osvb`**: Open-source Verilog tools (Icarus Verilog, VVP, GTKWave)
- **`verilator/verilator:latest`**: Verilator for advanced linting and analysis

### Running Locally with Docker

To replicate the CI environment locally:

```bash
# Pull the simulation image
docker pull hdlc/sim:osvb

# Run compilation in Docker
docker run --rm -v $(pwd):/work -w /work hdlc/sim:osvb \
  bash -c "cd scripts && ./compile.sh iverilog"

# Run tests in Docker
docker run --rm -v $(pwd):/work -w /work/sim hdlc/sim:osvb \
  bash -c "./run_all_tests.sh"
```

### Setting Up GitHub Actions

After pushing this repository to GitHub:

1. The workflows will automatically run on push/PR
2. Update badge URLs in README.md with your repository path:
   - Replace `YOUR_USERNAME/crypto-processor` with `username/repo-name`
3. For release builds, create a tag: `git tag v1.0.0 && git push --tags`

## Getting Started

### Prerequisites
- Verilog simulator (ModelSim, VCS, Icarus Verilog, or similar)
- Synthesis tool (optional): Vivado, Quartus, or similar
- Basic understanding of Verilog and cryptography

### Compilation

```bash
# Navigate to project directory
cd crypto-processor

# Run compilation script
./scripts/compile.sh
```

### Simulation

```bash
# Run simulation with testbench
./scripts/simulate.sh
```

### Synthesis

For FPGA synthesis, refer to your specific toolchain documentation. Constraint files are provided in `synthesis/constraints/`.

## Usage

### Programming the Processor

The processor supports crypto-specific instructions:

```assembly
# Example: AES Encryption
LOAD_DATA  r0, data_addr    # Load plaintext
LOAD_KEY   r1, key_addr     # Load AES key  
AES_ENC    r0, r1           # Encrypt and store result
STORE      r0, out_addr     # Store ciphertext

# Example: RSA Decryption  
LOAD_DATA  r0, cipher_addr  # Load ciphertext
RSA_DEC    r0               # Decrypt using stored private key
STORE      r0, plain_addr   # Store plaintext
```

### Key Management

Keys can be:
1. **Pre-loaded** during initialization
2. **Dynamically generated** using the key generator
3. **Updated** on-demand via control signals

## Configuration

All system parameters are defined in `rtl/common/crypto_pkg.v`:

```verilog
`define AES_KEY_WIDTH       128   // AES key size
`define RSA_KEY_WIDTH       512   // RSA key size  
`define CRYPTO_BUFFER_DEPTH 9     // Operation queue depth
```

## Testing

Test vectors from NIST/FIPS standards are included in `sim/test_vectors/`. Run tests with:

```bash
cd sim/testbenches
# Run specific testbench with your simulator
```

## Performance Optimization

For best performance:
1. **Pipeline Operations**: Queue multiple crypto operations
2. **Async Key Generation**: Generate new keys during computation
3. **Buffer Management**: Monitor operation queue status

## Security Considerations

⚠️ **Important Security Notes**:
- This is a reference implementation for educational purposes
- Production use requires additional hardening:
  - Side-channel attack protections
  - Secure key storage mechanisms
  - Random number generator validation
  - Timing attack countermeasures

## Documentation

Detailed documentation is available in the `docs/` directory:
- [Architecture Overview](docs/architecture.md)
- [API Reference](docs/api_reference.md)
- State Machine Diagrams
- Timing Diagrams

## Version History

### Version 2.0 (March 2026) - Restructured
- Reorganized directory structure
- Centralized parameter definitions
- Improved module naming conventions
- Added comprehensive documentation
- Created build automation scripts

### Version 1.0 (Original)
- Initial implementation
- AES-128 and RSA-512 support
- Basic RISC processor integration

## Contributing

Improvements and contributions are welcome! Areas for enhancement:
- Additional crypto algorithms (Triple-DES, ECC)
- Enhanced side-channel protections
- Performance optimizations
- Expanded test coverage

## License

[Specify your license here]

## Authors

CryptoKnight Team:
- Riya
- Atharva  
- Vishwas

## Acknowledgments

- NIST for AES and RSA standards
- Academic community for crypto algorithm implementations

## Contact

For questions or issues, please open an issue in the repository or contact the maintainers.

---

**Note**: This is hardware description language (HDL) code intended for FPGA/ASIC implementation. It requires appropriate synthesis and simulation tools for use.
