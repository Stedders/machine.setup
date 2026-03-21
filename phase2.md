# Phase 2: System Stabilization

After bootstrap, the system has Claude Code and GitHub access. Phase 2 stabilizes the foundations before any dotfiles or personal config is deployed.

Claude Code should follow these steps on handoff, detecting the specific system and adapting accordingly.

### General rules

- **Scripts over inline commands:** When steps require sudo or multi-part commands, create numbered executable scripts in `scripts/` (e.g., `scripts/01-enable-rpmfusion.sh`). This avoids copy-paste errors with line breaks and spaces, and gives the user a clear run order.
- **Detection first:** Always detect the current system state before prescribing fixes. Don't assume OS, GPU vendor, display manager, or desktop environment.
- **Explain then execute:** Each script should include a comment explaining what it does. The user reviews and runs them — Claude Code prepares and verifies.

---

## A. Detect and install GPU drivers

**Goal:** Ensure hardware GPU acceleration is working.

**Detection:**
- Identify GPU vendor: `lspci | grep -i 'vga\|3d\|display'`
- Check if driver modules are loaded: `lsmod | grep -i 'nvidia\|nouveau\|amdgpu\|radeon\|i915'`
- Check for software rendering: `glxinfo | grep "OpenGL renderer"` (look for llvmpipe, zink, swrast = software)
- Check boot params for `nomodeset`: `cat /proc/cmdline`

**Hints:**
- **NVIDIA** → Usually needs proprietary driver installed via OS package manager (e.g., RPM Fusion on Fedora, PPA on Ubuntu). Check for `akmod-nvidia` / `nvidia-driver` packages. May need build tools (`gcc`, `kernel-devel`).
- **AMD** → `amdgpu` usually loads automatically. Check `mesa` packages are installed.
- **Intel** → `i915` usually loads automatically. Check `mesa` packages are installed.
- `nomodeset` in boot params prevents kernel modesetting — GPU drivers won't load. Must be removed after driver is installed.
- On Wayland with NVIDIA, ensure `nvidia_drm modeset=1` is set (e.g., via modprobe.d config) and initramfs is rebuilt.

**Success criteria:**
- [ ] `lsmod` shows appropriate driver module loaded
- [ ] `glxinfo` shows hardware renderer (actual GPU name, not software fallback)
- [ ] No GPU errors in `journalctl -b -p err`

---

## B. Check and fix system errors

**Goal:** Review system logs and resolve errors that indicate broken foundations.

**Detection:**
- System-level errors: `journalctl -b -p err --no-pager`
- User-level errors: `journalctl --user -b -p err --no-pager`
- Kernel messages: `dmesg` (may require root)
- Desktop environment logs: `journalctl -b --grep='plasma\|gnome\|kwin\|mutter'`

**Hints:**
- GPU cascades are common — one GPU failure causes many desktop environment failures. Fix GPU first (Step A), then re-check.
- Categorize errors: GPU-related, desktop environment, hardware (USB, Bluetooth), services. Prioritize root causes.
- Some errors are cosmetic/firmware-level (e.g., Bluetooth ACPI warnings) and can be documented rather than fixed.

**Success criteria:**
- [ ] No unexpected errors in system journal
- [ ] Desktop environment running without errors
- [ ] Known cosmetic warnings documented

---

## C. Post-install common fixes checklist

**Goal:** Check for and fix common post-install usability issues.

### Numlock on login
- **Detection:** Check display manager config for numlock setting
  - SDDM: `/etc/sddm.conf` or `/etc/sddm.conf.d/` → `Numlock=` under `[General]`
  - GDM: `dconf` or `gsettings` for `org.gnome.settings-daemon.peripherals.keyboard numlock-state`
  - LightDM: `/etc/lightdm/lightdm.conf` → `greeter-setup-script`
- **Fix:** Set numlock to enabled in the display manager config

### Sleep/wake
- **Detection:** `systemctl suspend` → attempt to wake with keyboard/mouse
- **Hints:** Sleep issues are often GPU-driver related. Verify GPU driver supports power management. Check `cat /sys/power/state` for available states and `cat /sys/power/mem_sleep` for current mode.
- **Fix:** Usually resolves with proper GPU driver. If not, check kernel params, ACPI settings, or try `s2idle` vs `deep` sleep.

### Display scaling
- **Detection:** Check monitor resolution and physical size. Look for HiDPI or mixed-DPI setups.
- **Hints:** KDE and GNOME handle scaling differently. Wayland generally handles fractional scaling better than X11.

### Bluetooth
- **Detection:** `journalctl -b --grep=bluetooth`, `bluetoothctl show`
- **Hints:** Firmware warnings are usually cosmetic. Verify pairing works if Bluetooth devices are available.

### Audio
- **Detection:** `wpctl status` (PipeWire) or `pactl info` (PulseAudio), check for output devices
- **Fix:** Ensure correct output device is selected and not muted

### Time/timezone
- **Detection:** `timedatectl`, check NTP sync status
- **Fix:** `timedatectl set-timezone <zone>`, enable NTP if not syncing

### Firewall
- **Detection:** `firewall-cmd --state` (firewalld) or `ufw status` (ufw)
- **Hints:** Ensure firewall is enabled. Check that required ports are open for development tools.

**Success criteria:**
- [ ] Numlock on at login
- [ ] Sleep/wake cycle works
- [ ] Display renders correctly (no scaling issues)
- [ ] No hardware usability issues

---

## D. Verify system stability

**Goal:** Confirm the system is stable enough for dotfiles deployment.

**Verification checklist:**
- [ ] GPU hardware acceleration working
- [ ] Desktop environment stable (no crashes, no portal errors)
- [ ] Sleep/wake works
- [ ] All user-reported issues resolved
- [ ] System journal clean of foundation errors

---

## E. Document and commit

**Goal:** Record what was done, update this repo.

- Note any improvements to bootstrap.md discovered during phase 2
- Commit results to the setup repo
- Push to GitHub
