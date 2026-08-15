# The Coderex desktop app.
#
#   brew install --cask coderex
#
# `version` and `sha256` are rewritten automatically by the `homebrew` job in
# coderex-client/.github/workflows/release.yml. Keep both at two-space indentation
# — that job anchors its sed on `^  version ` / `^  sha256 `.
cask "coderex" do
  version "0.2.14"
  sha256 "b1aa59c66668c87168d3225d33fbdbeeb2780eba09ef3849c6dd6242487642da"

  # Matches scripts/make-dmg.sh: coderex-<version>-aarch64.dmg, published to the
  # immutable versioned path by the release workflow.
  url "https://releases.coderex.com/#{version}/coderex-#{version}-aarch64.dmg"
  name "Coderex"
  desc "Terminal for AI coding agents, reachable from any browser"
  homepage "https://coderex.com/"

  livecheck do
    url "https://releases.coderex.com/appcast.json"
    strategy :json do |json|
      json.dig("releases", "macos-aarch64", "version")
    end
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma # macOS 14+

  # Coderex ships its own Ed25519-signed updater (appcast.json). Declaring this
  # stops Homebrew trying to upgrade the app underneath it, which would fight the
  # in-app updater. `brew upgrade` becomes a no-op; the app updates itself.
  auto_updates true

  app "Coderex.app"

  # The CLI ships INSIDE the bundle. Without this stanza nothing put `coderex`
  # on PATH for a Homebrew install, while the docs said installing the app was
  # enough. Homebrew symlinks it into its own bin (already on PATH) and removes
  # it on uninstall, so brew owns this link rather than the app.
  binary "#{appdir}/Coderex.app/Contents/MacOS/coderex"

  # `brew uninstall --zap` removes user state too. Paths verified against
  # coderex_core::persistence::config_dir() and BUNDLE_ID in scripts/bundle.sh.
  zap trash: [
    "~/.config/coderex",
    "~/Library/Preferences/com.coderex.app.plist",
    "~/Library/Saved Application State/com.coderex.app.savedState",
    "~/Library/Caches/com.coderex.app",
  ]
end
