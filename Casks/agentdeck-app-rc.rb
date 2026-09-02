# typed: strict
# frozen_string_literal: true

# Installs the notarized AgentDeck desktop app, its embedded helper, and the
# shell completions packaged inside the bundle.
cask "agentdeck-app-rc" do
  version "0.5.0-rc.4"
  sha256 "594475b7f8c8386f2411689bf47d9d8ad4a0ff629d8e866f4c56de0faae1331a"

  url "https://github.com/kitdine/agent-deck/releases/download/v0.5.0-rc.4/" \
      "AgentDeck_v0.5.0-rc.4_universal.dmg"
  name "AgentDeck"
  desc "Menu bar app and widget for Codex/Claude usage, sessions, and providers"
  homepage "https://github.com/kitdine/agent-deck"

  depends_on macos: :tahoe

  # Exactly one installation may own the global `agentdeck` command, and the two
  # halves of that exclusion are declared differently because Homebrew supports
  # only one of them as a stanza: `Cask::DSL::ConflictsWith::VALID_KEYS` is
  # `[:cask]`, and any other key makes the whole cask unloadable rather than
  # merely inert. The other cask channel is therefore declared here, and the
  # CLI-only formulae are refused by the preflight below, which names the
  # migration instead of failing on a link collision the user cannot read.
  conflicts_with cask: ["agentdeck-app"]

  preflight do
    ["agentdeck", "agentdeck-rc"].each do |conflicting_formula|
      next unless (HOMEBREW_CELLAR/conflicting_formula).directory?

      odie <<~ERROR
        The CLI-only #{conflicting_formula} formula is installed and already owns
        the `agentdeck` command. Migrate rather than installing both:
          brew uninstall #{conflicting_formula}
          brew install --cask agentdeck-app-rc
        Your AgentDeck state in ~/.agentdeck is untouched by that migration.
      ERROR
    end
  end

  app "AgentDeck.app"
  binary "#{appdir}/AgentDeck.app/Contents/Helpers/agentdeck"
  binary "#{appdir}/AgentDeck.app/Contents/Resources/completions/agentdeck.bash",
         target: "#{HOMEBREW_PREFIX}/etc/bash_completion.d/agentdeck"
  binary "#{appdir}/AgentDeck.app/Contents/Resources/completions/agentdeck.zsh",
         target: "#{HOMEBREW_PREFIX}/share/zsh/site-functions/_agentdeck"
  binary "#{appdir}/AgentDeck.app/Contents/Resources/completions/agentdeck.fish",
         target: "#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d/agentdeck.fish"

  caveats <<~EOS
    The app and the `agentdeck` command come from one installation. If the
    CLI-only formula is already installed, migrate rather than installing both:
      brew uninstall agentdeck
      brew install --cask agentdeck-app-rc
    Your AgentDeck state in ~/.agentdeck is untouched by either direction of
    that migration, and uninstalling this cask leaves it in place.

    Project-attribution wrappers are optional and only act when a provider
    routes through a declared Headroom wrapper. To use them, configure every
    shell you use with:
      agentdeck shell setup

    To undo it later:
      agentdeck shell remove

    Command completion is already installed and needs no further action.
  EOS

  # Deliberately absent from this list: ~/.agentdeck. It holds the database,
  # the machine-bound credential key, and the operation journal, none of which
  # an app uninstall may remove.
  zap trash: [
    "~/Library/Caches/com.kitdine.agentdeck",
    "~/Library/Group Containers/N2FZ2FNRTU.group.com.kitdine.agentdeck",
    "~/Library/Preferences/com.kitdine.agentdeck.plist",
    "~/Library/Saved Application State/com.kitdine.agentdeck.savedState",
  ]
end
