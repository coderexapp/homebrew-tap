# Headless Coderex: the daemon + CLI, no GUI.
#
#   brew install coderex
#
# This is the SAME `coderex` binary that ships inside Coderex.app, published
# standalone so a server, a CI box, or anyone who just wants the control surface
# can have it without the desktop app. It pairs with the cask (Casks/coderex.rb),
# which installs the GUI; the two can be installed together.
#
# `version` and `sha256` are rewritten automatically by the `homebrew` job in
# coderex-client/.github/workflows/release.yml. Keep both at two-space indentation
# — that job anchors its sed on `^  version ` / `^  sha256 `.
class Coderex < Formula
  desc "Headless daemon and CLI for running and supervising AI coding agents"
  homepage "https://coderex.com"
  version "0.1.10"
  url "https://releases.coderex.com/#{version}/coderex-#{version}-macos-aarch64.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license :cannot_represent # proprietary — see the LICENSE in the product

  # Apple Silicon only today. Linux (x86_64 + aarch64) lands with Phase 2 of the
  # multi-platform roadmap, at which point this gains an `on_linux` block.
  depends_on arch: :arm64
  depends_on macos: :sonoma # macOS 14+

  # Track releases from the same feed the in-app updater reads, so `brew outdated`
  # stays correct without a second source of truth.
  livecheck do
    url "https://releases.coderex.com/appcast.json"
    strategy :json do |json|
      json.dig("releases", "macos-aarch64", "version")
    end
  end

  def install
    bin.install "coderex"
  end

  def caveats
    <<~EOS
      Start the headless daemon with:
        coderex serve            # local socket only
        coderex serve --remote   # also join the end-to-end-encrypted relay

      The desktop app is a separate cask:
        brew install --cask coderex
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coderex --version")
    # With no daemon running this must fail cleanly rather than hang.
    assert_match "could not reach app", shell_output("#{bin}/coderex ping 2>&1", 1)
  end
end
