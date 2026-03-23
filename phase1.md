# Bootstrap

Minimal manual steps to go from a fresh OS install to having Claude Code running with GitHub access. After this, the LLM takes over.

## 1. Get credentials

- [ ] Retrieve your password manager master password (e.g., from another device)
- [ ] Log in to your email
- [ ] Install your password manager's browser extension and log in

## 2. Update system

<!-- OS-specific -->

**Fedora/DNF:**
```bash
sudo dnf upgrade --refresh
```

**Ubuntu/Debian/APT:**
```bash
sudo apt update && sudo apt upgrade
```

**macOS:**
```bash
softwareupdate --install --all
```

## 3. Install Homebrew prerequisites

<!-- OS-specific -->

Homebrew requires git and build tools to install.

**Fedora/DNF:**
```bash
sudo dnf install git gcc make
```

**Ubuntu/Debian/APT:**
```bash
sudo apt install git build-essential
```

**macOS:**
```bash
xcode-select --install
```

## 4. Install Homebrew

Cross-platform package manager — keeps dev tools consistent across distros and macOS.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the post-install instructions printed to the terminal to add `brew` to your PATH.

## 5. Install Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

- [ ] Launch `claude` and authenticate via browser

## 6. Get GitHub access

```bash
brew install gh
```

Configure git identity (use GitHub noreply email for privacy):
```bash
GITHUB_USER=$(gh api user --jq '.login')
GITHUB_NAME=$(gh api user --jq '.name')
GITHUB_ID=$(gh api user --jq '.id')
git config --global user.name "${GITHUB_NAME:-$GITHUB_USER}"
git config --global user.email "${GITHUB_ID}+${GITHUB_USER}@users.noreply.github.com"
```

Generate SSH key:
```bash
ssh-keygen -t ed25519 -C "$(git config --global user.email)"
cat ~/.ssh/id_ed25519.pub
```

- [ ] Add the public key to [GitHub → Settings → SSH keys](https://github.com/settings/keys)

Authenticate gh CLI:
```bash
gh auth login
```
Select: GitHub.com → SSH → authenticate via browser.

## 7. Handoff

Bootstrap complete. Hand off to Claude Code for semi-automated and automated setup.
