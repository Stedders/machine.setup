# Phase 4: Dev Stack

Install languages, runtimes, cloud CLIs, and container tooling. Assumes Phase 2 (system stabilisation) is complete and dotfiles are deployed.

Claude Code should follow these steps on handoff, detecting the specific system and adapting accordingly.

### General rules

- Same as Phase 2: scripts over inline commands, detection first, explain then execute.
- Cross-platform installers go in `scripts/common/`. OS-specific packages go in `scripts/<system>/`.

---

## A. System build tools

**Goal:** Install C/C++ toolchain and .NET SDK via system packages (not Homebrew).

**Detection:**
- Check for compiler: `gcc --version`, `g++ --version`
- Check for build tools: `cmake --version`, `make --version`
- Check for .NET: `dotnet --version`

**Hints:**
- **Fedora:** `gcc` and `make` are usually pre-installed. `gcc-c++`, `cmake`, and `dotnet-sdk-10.0` need installing. Homebrew dotnet is broken on Fedora 43 (executable stack restriction in kernel).
- **Ubuntu/Debian:** `build-essential` covers gcc, g++, make. `cmake` is separate. .NET via Microsoft's apt repo or install script.
- **macOS:** Xcode Command Line Tools (installed in Phase 1) covers C/C++. .NET via Homebrew works fine on macOS.

**Scripts:**
- Fedora 43: `scripts/fedora-43/02-dev-toolchain.sh`

**Success criteria:**
- [ ] `gcc`, `g++`, `cmake`, `make` all available
- [ ] `dotnet --version` works

---

## B. Homebrew packages

**Goal:** Install dev tools managed by Homebrew via the Brewfile in the dotfiles repo.

The Brewfile in `machine.dotfiles` includes: `uv`, `dotnet`, `kubectl`, `kustomize`, `k9s`, `opentofu`, `awscli`, `azure-cli`, `podman-compose`.

**Steps:**
1. Ensure dotfiles are deployed (`chezmoi apply`)
2. Run `brew bundle install --file=~/.Brewfile` (or wherever chezmoi places it)

**Success criteria:**
- [ ] All Brewfile packages installed: `brew bundle check`

---

## C. Node.js (nvm)

**Goal:** Install nvm for Node.js version management.

**Detection:**
- Check if installed: `command -v nvm` (after sourcing), or `[ -d "$HOME/.nvm" ]`

**Hints:**
- nvm is a shell function, not a binary — it won't show up in `which`
- Installed via curl script from the nvm GitHub repo
- Shell integration is handled by `.zshrc` (sources `$NVM_DIR/nvm.sh`)
- After install, run `nvm install --lts` to get a working Node

**Scripts:**
- `scripts/common/01-install-nvm.sh`

**Success criteria:**
- [ ] `nvm --version` works in a new shell
- [ ] `node --version` works after installing an LTS version

---

## D. Rust (rustup)

**Goal:** Install the Rust toolchain via rustup.

**Detection:**
- Check if installed: `command -v rustup`, or `[ -d "$HOME/.cargo" ]`

**Hints:**
- Installed via curl script from rustup.rs
- Adds `~/.cargo/bin` to PATH (handled by `.zshenv`)
- Includes `rustc`, `cargo`, and `rustfmt`

**Scripts:**
- `scripts/common/02-install-rustup.sh`

**Success criteria:**
- [ ] `rustup --version` works
- [ ] `rustc --version` and `cargo --version` work

---

## E. Java (SDKMAN)

**Goal:** Install SDKMAN for Java version management.

**Detection:**
- Check if installed: `command -v sdk` (after sourcing), or `[ -d "$HOME/.sdkman" ]`

**Hints:**
- SDKMAN is a shell function, like nvm
- Installed via curl script from sdkman.io
- Shell integration is handled by `.zshrc` (sources `$SDKMAN_DIR/bin/sdkman-init.sh`)
- After install, run `sdk install java` to get the latest JDK

**Scripts:**
- `scripts/common/03-install-sdkman.sh`

**Success criteria:**
- [ ] `sdk version` works in a new shell
- [ ] `java -version` works after installing a JDK

---

## F. Google Cloud SDK

**Goal:** Install the gcloud CLI.

**Detection:**
- Check if installed: `command -v gcloud`, or `[ -d "$HOME/.local/share/google-cloud-sdk" ]`

**Hints:**
- Not available as a standard Homebrew formula on Linux
- Installed via Google's official installer to `~/.local/share/google-cloud-sdk`
- PATH is handled by `.zshenv`, completions by `.zshrc`
- After install, authenticate with `gcloud init`

**Scripts:**
- `scripts/common/04-install-gcloud.sh`

**Success criteria:**
- [ ] `gcloud --version` works in a new shell

---

## G. Containers (Podman)

**Goal:** Verify Podman is available.

**Detection:**
- Check if installed: `command -v podman`
- Check version: `podman --version`

**Hints:**
- **Fedora:** Podman comes pre-installed. No action needed.
- **Ubuntu/Debian:** Install via `apt install podman`.
- **macOS:** Install via `brew install podman`, then `podman machine init && podman machine start`.
- `podman-compose` is installed via Brewfile.

**Success criteria:**
- [ ] `podman --version` works
- [ ] `podman-compose --version` works

---

## H. Verify and document

**Goal:** Confirm all tools are installed and commit.

**Verification checklist:**
- [ ] C/C++ toolchain: `gcc`, `g++`, `cmake`, `make`
- [ ] Python: `uv --version`
- [ ] Node: `nvm --version`, `node --version`
- [ ] Rust: `rustup --version`, `rustc --version`, `cargo --version`
- [ ] Java: `sdk version`, `java -version`
- [ ] C#: `dotnet --version`
- [ ] Containers: `podman --version`, `podman-compose --version`
- [ ] Kubernetes: `kubectl version --client`, `kustomize version`, `k9s version`
- [ ] IaC: `tofu --version`
- [ ] Cloud: `aws --version`, `az --version`, `gcloud --version`

- Commit scripts and results to the setup repo
- Push to GitHub
