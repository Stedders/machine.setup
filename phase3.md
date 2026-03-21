# Phase 3: Desktop Environment

Configure the desktop environment's look and feel. Assumes Phase 2 (system stabilisation) is complete.

Claude Code should follow these steps on handoff, detecting the specific DE and adapting accordingly.

### General rules

- Same as Phase 2: scripts over inline commands, detection first, explain then execute.
- DE config scripts go in `scripts/<de-version>/` (e.g., `scripts/kde-plasma6/`).

---

## A. Detect desktop environment

**Goal:** Identify the DE, version, and display server before configuring anything.

**Detection:**
- Desktop environment: `echo $XDG_CURRENT_DESKTOP`
- DE version: `plasmashell --version` (KDE), `gnome-shell --version` (GNOME)
- Display server: `echo $XDG_SESSION_TYPE` (wayland or x11)
- Display manager: `systemctl status display-manager`

---

## B. Install theme, icons, and fonts

**Goal:** Install the chosen global theme, icon theme, and fonts.

**Hints:**
- **KDE Plasma:** Global themes can be installed via `lookandfeeltool` or downloaded from KDE Store. Icon themes via package manager or KDE Store. Check `scripts/kde-plasma6/` for implementation.
- **GNOME:** Themes via GNOME Extensions or GTK theme packages. Icons via package manager.
- Fonts can often be installed via system package manager. For fonts not packaged, download to `~/.local/share/fonts/` and run `fc-cache -fv`.

**Success criteria:**
- [ ] Theme package installed and visible in DE settings
- [ ] Icon theme installed and visible in DE settings
- [ ] Fonts installed and visible in `fc-list`

---

## C. Apply look and feel

**Goal:** Apply the installed theme, icons, and fonts as the active configuration.

**Hints:**
- **KDE Plasma:** Use `lookandfeeltool -a <theme>`, `plasma-apply-colorscheme`, `kwriteconfig6` for fine-grained settings. See `scripts/kde-plasma6/` for implementation.
- **GNOME:** Use `gsettings` for theme, icons, fonts.
- Apply fonts for both UI and monospace/fixed-width separately.

**Success criteria:**
- [ ] Global theme applied
- [ ] Colour scheme active
- [ ] Icon theme active
- [ ] UI and monospace fonts set

---

## D. Configure dark/light switching

**Goal:** Set up the ability to switch between dark and light variants.

**Hints:**
- **KDE Plasma 6.5+:** Native day/night switching in System Settings > Appearance > Quick Settings. Configure two global themes (light and dark) and enable auto-switching or manual toggle.
- **GNOME 42+:** Dark/light style preference in Settings > Appearance. Apps that support the portal will follow.

**Success criteria:**
- [ ] Dark and light variants both configured
- [ ] Switching mechanism works (manual toggle or auto schedule)

---

## E. Verify and document

**Goal:** Confirm everything looks correct and commit.

**Verification checklist:**
- [ ] Theme renders correctly
- [ ] Icons display consistently across apps
- [ ] Fonts render clearly at all sizes
- [ ] Dark/light switch works without visual artefacts
- [ ] All user-reported issues resolved

- Commit scripts and results to the setup repo
- Push to GitHub
