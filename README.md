# Coderex Homebrew tap

Official Homebrew recipes for [Coderex](https://coderex.com) — the terminal for
AI coding agents, reachable from any browser.

## Install

```bash
brew install --cask coderexapp/tap/coderex   # the desktop app (macOS, Apple Silicon)
brew install coderexapp/tap/coderex          # the headless daemon + CLI, no GUI
```

The full name is intentional — it taps and trusts in a single command. Homebrew
refuses to load a cask from an untrusted third-party tap, so the shorter
`brew install --cask coderex` would need three steps (`tap`, `trust`, install).

Both can be installed side by side: the cask gives you `Coderex.app`, the formula
puts a `coderex` binary on your `PATH`. The app already bundles that same binary,
so you only need the formula if you want the control surface *without* the GUI.

## On a server?

If you only want the headless daemon — a Mac mini running agents, a CI box, or a
**Linux server** — the installer is a better fit than Homebrew. It needs no
package manager and works the same everywhere:

```bash
curl -fsSL https://coderex.com/install.sh | sh
```

It verifies the download's SHA-256 against a published checksum before unpacking,
installs a single binary to `~/.local/bin`, and uses no sudo.

**Linux is supported on x86_64 and arm64** — Ampere and Graviton VPSes, ARM
Docker hosts, and Raspberry Pi included. The binaries need **glibc 2.35 or
newer**: Ubuntu 22.04+, Debian 12+, RHEL 9+, Fedora 38+, Raspberry Pi OS
bookworm. Not Ubuntu 20.04, Debian 11, RHEL 8, or Amazon Linux 2.

## After installing

```bash
coderex login            # link this machine to your account (headless-friendly)
coderex serve            # start the headless daemon (local socket only)
coderex serve --remote   # also join the end-to-end-encrypted relay
coderex status           # what every agent is doing
coderex --help           # full command list
```

On a server with no GUI, run `coderex remote pair` in an SSH session **before**
opening the browser: it shows the 6-digit code to compare and approves the
device. Approvals are pushed events that expire after 120 seconds, so start it
first. Once a device is paired it reconnects without prompting.

Docs: <https://coderex.com/docs>

## Notes

- **The cask (desktop app) is Apple Silicon, macOS 14+.** The **formula**
  (headless daemon + CLI) is macOS today; on Linux use the installer above.
  Windows is not supported yet.
- The cask declares `auto_updates true` because Coderex ships its own signed
  updater. `brew upgrade` is a no-op for the app — it updates itself. The
  **formula** does not self-update, so `brew upgrade` is how you update that one.
- Both recipes `livecheck` against the same release feed the in-app updater
  reads, so `brew outdated` stays accurate.

## Contributing

This tap is generated. Recipes are maintained in the Coderex client repo under
`packaging/homebrew/`, and `version` + `sha256` are bumped automatically by CI on
every release — please don't hand-edit them here.
