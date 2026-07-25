# Coderex Homebrew tap

Official Homebrew recipes for [Coderex](https://coderex.com) — the terminal for
AI coding agents, reachable from any browser.

## Install

```bash
brew tap coderexapp/tap

brew install --cask coderex   # the desktop app (macOS, Apple Silicon)
brew install coderex          # the headless daemon + CLI, no GUI
```

Both can be installed side by side: the cask gives you `Coderex.app`, the formula
puts a `coderex` binary on your `PATH`. The app already bundles that same binary,
so you only need the formula if you want the control surface *without* the GUI.

## On a server?

If you only want the headless daemon — a Mac mini running agents, a CI box, or
(soon) a Linux server — the installer is a better fit than Homebrew. It needs no
package manager and works the same everywhere:

```bash
curl -fsSL https://coderex.com/install.sh | sh
```

It verifies the download's SHA-256 against a published checksum before unpacking,
installs a single binary to `~/.local/bin`, and uses no sudo.

## After installing

```bash
coderex serve            # start the headless daemon (local socket only)
coderex serve --remote   # also join the end-to-end-encrypted relay
coderex status           # what every agent is doing
coderex --help           # full command list
```

Docs: <https://coderex.com/docs>

## Notes

- **Apple Silicon, macOS 14+.** Linux support is planned; Windows after that.
- The cask declares `auto_updates true` because Coderex ships its own signed
  updater. `brew upgrade` is a no-op for the app — it updates itself. The
  **formula** does not self-update, so `brew upgrade` is how you update that one.
- Both recipes `livecheck` against the same release feed the in-app updater
  reads, so `brew outdated` stays accurate.

## Contributing

This tap is generated. Recipes are maintained in the Coderex client repo under
`packaging/homebrew/`, and `version` + `sha256` are bumped automatically by CI on
every release — please don't hand-edit them here.
