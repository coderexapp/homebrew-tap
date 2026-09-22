# Headless Coderex: the daemon + CLI, no GUI.
#
#   brew install coderexapp/tap/coderex
#
# This is the SAME `coderex` binary that ships inside Coderex.app, published
# standalone so a server, a CI box, or anyone who just wants the control surface
# can have it without the desktop app. It pairs with the cask (Casks/coderex.rb),
# which installs the GUI; the two can be installed together.
#
# macOS (Apple Silicon) and Linux (x86_64 + arm64) are all supported. On a
# SERVER, prefer the installer — `curl -fsSL https://coderex.com/install.sh | sh`
# — which needs no package manager. Homebrew on Linux is for workstations that
# already use it.
#
# `version` and every `sha256` are rewritten automatically by the `homebrew` job
# in coderex-client/.github/workflows/release.yml. That job anchors each checksum
# on its trailing `# <platform>` comment, so DO NOT remove those comments and do
# not give two platforms the same marker.
class Coderex < Formula
  desc "Headless daemon and CLI for running and supervising AI coding agents"
  homepage "https://coderex.com"
  version "0.3.14"
  license :cannot_represent # proprietary — see the LICENSE in the product

  # `livecheck` must precede the on_* blocks (brew audit enforces the ordering).
  # Tracks the same feed the in-app updater reads, so `brew outdated` stays
  # correct without a second source of truth. Every platform ships at the same
  # version from one tag, so reading any one key gives the right answer.
  livecheck do
    url "https://releases.coderex.com/appcast.json"
    strategy :json do |json|
      json.dig("releases", "macos-aarch64", "version")
    end
  end

  # `url`/`sha256` cannot sit directly inside `on_macos` — only an arch block may
  # hold them — so the single macOS build still needs an `on_arm` wrapper.
  on_macos do
    depends_on macos: :sonoma # macOS 14+
    on_arm do
      url "https://releases.coderex.com/#{version}/coderex-#{version}-macos-aarch64.tar.gz"
      sha256 "0a8e3ed8324286db027fa0fc827d7a694a758966513dc89ea2c953d2e872be86" # macos-aarch64
    end
    # No x86_64 macOS build exists; fail at install with a clear reason rather
    # than 404 on a URL that was never published.
    on_intel do
      odie "Coderex requires Apple Silicon on macOS. Intel Macs are not supported."
    end
  end

  on_linux do
    # The binaries are built on Ubuntu 22.04 and link glibc 2.35, so they run on
    # Ubuntu 22.04+, Debian 12+, RHEL 9+ and newer — not on Ubuntu 20.04, Debian
    # 11, RHEL 8, or Amazon Linux 2. Homebrew cannot express a glibc floor, so an
    # older host fails at exec with "version `GLIBC_2.35' not found" rather than
    # at install time.
    on_intel do
      url "https://releases.coderex.com/#{version}/coderex-#{version}-linux-x86_64.tar.gz"
      sha256 "07f98d119a38296b55154583a89b3a0038a94d2b6dd0bb122d7b395babafda14" # linux-x86_64
    end
    on_arm do
      url "https://releases.coderex.com/#{version}/coderex-#{version}-linux-aarch64.tar.gz"
      sha256 "18e01b72e0e0cf7b758f4d424827126e20f0bfed6dfa891804b92275d3310da9" # linux-aarch64
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

      On a machine with no GUI, approve a remote device with:
        coderex remote pair      # run this BEFORE connecting the browser

      The desktop app is a separate cask (macOS only):
        brew install --cask coderexapp/tap/coderex
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coderex --version")
    # With no daemon running this must fail cleanly rather than hang.
    assert_match "could not reach app", shell_output("#{bin}/coderex ping 2>&1", 1)
  end
end
