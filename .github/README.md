# GitHub Actions Workflows

This directory contains automated CI/CD workflows for the CryptoKnight Processor project.

## Workflows Overview

### 🔄 CI - Compile and Test ([ci.yml](workflows/ci.yml))

**Purpose**: Continuous Integration for every code change

**Triggers**:
- Push to `main`, `master`, or `develop` branches
- Pull requests to these branches
- Manual workflow dispatch

**Jobs**:
1. **Compile** - Compiles all RTL modules using Icarus Verilog
2. **Test** - Runs complete test suite with all testbenches
3. **Syntax Check** - Validates Verilog syntax for all files
4. **Lint** - Runs Verilator static analysis

**Duration**: ~5-10 minutes

### 🌙 Nightly Build ([nightly.yml](workflows/nightly.yml))

**Purpose**: Comprehensive testing and quality checks

**Triggers**:
- Daily at 2:00 AM UTC
- Manual workflow dispatch

**Jobs**:
1. **Comprehensive Test** - Full test suite with detailed reporting
2. **Performance Benchmark** - Execution time measurements for each test
3. **Code Quality** - LOC counts, TODO tracking, documentation checks

**Duration**: ~15-30 minutes

### 📦 Release Build ([release.yml](workflows/release.yml))

**Purpose**: Create production-ready release packages

**Triggers**:
- Push of version tags (e.g., `v1.0.0`, `v2.1.3`)
- Manual workflow dispatch with version input

**Jobs**:
1. **Build Release** - Creates distributable packages (tar.gz, zip) with checksums
2. **Synthesis Check** - Validates code synthesizability

**Duration**: ~10-15 minutes

## Docker Images Used

All workflows use containerized environments for reproducibility:

| Workflow | Container | Purpose |
|----------|-----------|---------|
| CI - Compile, Test, Syntax | `hdlc/sim:osvb` | Icarus Verilog, VVP, GTKWave |
| CI - Lint | `verilator/verilator:latest` | Verilator linting |
| Nightly | `hdlc/sim:osvb` | Full simulation environment |
| Release | `hdlc/sim:osvb` | Build and packaging |

## Quick Start

### Enabling Workflows

1. Push this repository to GitHub
2. Workflows automatically activate on first push
3. Check **Actions** tab to see workflow runs

### Updating Badge URLs

In `README.md`, replace `YOUR_USERNAME` with your GitHub username:

```markdown
[![CI - Compile and Test](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USERNAME/crypto-processor/actions/workflows/ci.yml)
```

### Creating a Release

```bash
# Tag a commit
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag to trigger release workflow
git push origin v1.0.0
```

### Manual Workflow Trigger

1. Navigate to **Actions** tab on GitHub
2. Select desired workflow from left sidebar
3. Click **Run workflow** button
4. (For release) Enter version number
5. Click green **Run workflow** button

## Artifacts Generated

Workflows preserve important outputs as artifacts:

| Artifact | Retention | Contents |
|----------|-----------|----------|
| build-artifacts | 5 days | Compiled .vvp files |
| test-results | 30 days | Test logs and waveforms |
| nightly-test-results | 90 days | Comprehensive test data |
| performance-benchmarks | 90 days | Timing measurements |
| release-package | 90 days | Distribution archives |

## Local Testing

Replicate CI environment locally using Docker:

```bash
# Pull image
docker pull hdlc/sim:osvb

# Run tests
docker run --rm -v $(pwd):/work -w /work/sim hdlc/sim:osvb \
  bash -c "chmod +x run_all_tests.sh && ./run_all_tests.sh"
```

## Workflow Status

View workflow status:
- **Actions tab**: Real-time logs and detailed results
- **Badge on README**: Quick pass/fail status
- **Email notifications**: Failure alerts (if configured)

## Requirements

**No installation required!** GitHub Actions and Docker containers handle all dependencies automatically.

For local development, you may want:
- Docker (to replicate CI environment)
- Icarus Verilog (for native simulation)
- GTKWave (for waveform viewing)

## Troubleshooting

### Workflow Fails But Works Locally

Run in Docker to match CI environment:
```bash
docker run --rm -v $(pwd):/work -w /work/sim hdlc/sim:osvb ./run_all_tests.sh
```

### Permission Errors

Ensure scripts are executable:
```bash
git ls-files --stage | grep scripts/
git update-index --chmod=+x scripts/compile.sh
git update-index --chmod=+x scripts/simulate.sh
```

### Artifact Upload Fails

Check artifact size limits (2GB max per artifact). Large waveforms may exceed limits.

## Customization

### Modify Workflow Triggers

Edit workflow YAML files to change when they run:

```yaml
on:
  push:
    branches: [ main, develop ]  # Add/remove branches
  schedule:
    - cron: '0 2 * * *'  # Change schedule
```

### Add New Jobs

Copy existing job structure and modify:

```yaml
new-job:
  name: My New Job
  runs-on: ubuntu-latest
  container:
    image: hdlc/sim:osvb
  steps:
    - uses: actions/checkout@v4
    - name: Custom step
      run: echo "Hello from new job"
```

### Change Docker Images

Update container image in workflow:

```yaml
container:
  image: different/image:tag
```

## Resources

- [Full CI/CD Documentation](../docs/ci_cd.md)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Icarus Verilog](http://iverilog.icarus.com/)
- [HDL Containers](https://github.com/hdl/containers)

## Support

For issues with workflows:
1. Check **Actions** tab for detailed logs
2. Review [CI/CD Documentation](../docs/ci_cd.md)
3. Open an issue with workflow run link
