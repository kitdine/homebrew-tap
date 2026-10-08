# typed: strict
# frozen_string_literal: true

# Installs the versioned AgentDeck macOS binary and shell completions.
class Agentdeck < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  url "https://github.com/kitdine/agent-deck/releases/download/v0.6.5/" \
      "agentdeck_v0.6.5_darwin_#{on_arch_conditional arm: "arm64", intel: "amd64"}.tar.gz"
  version "0.6.5"
  sha256 on_arch_conditional(
    arm:   "c8f598280e0e391c93493436936f71955a8c1cdad3760c1e1149e02d944e9c42",
    intel: "7f7bca4eb2e4f624e71a3fe7e9bf2495dd19209a617663d1a9672cbb718ece56",
  )
  license "MIT"

  def install
    bin.install "agentdeck"
    generate_completions_from_executable(
      bin/"agentdeck",
      shell_parameter_format: :cobra,
      shells:                 [:bash, :zsh, :fish],
    )
  end

  def caveats
    <<~EOS
      Project-attribution wrappers are optional and only act when a provider
      routes through a declared Headroom wrapper. With no eligibility marker,
      wrappers invoke the real client without starting AgentDeck. When the
      marker exists, each invocation starts one AgentDeck process and performs
      one read-only database access. On the measured Intel macOS 26.6 host,
      marker-present paths added roughly 0.1-0.2 seconds per invocation; this is
      an environment-specific order of magnitude, not a performance guarantee.
      To use this, configure every shell you use with:
        agentdeck shell setup

      To undo it later:
        agentdeck shell remove

      Command completion is already installed and needs no further action.
      Skipping shell setup leaves shell-based project attribution disabled and
      does not affect normal AgentDeck use.
    EOS
  end

  test do
    output = shell_output("#{bin}/agentdeck version")
    assert_match "Release Version: v0.6.5", output
    refute_match "dev", output
    assert_path_exists bash_completion/"agentdeck"
    assert_path_exists zsh_completion/"_agentdeck"
    assert_path_exists fish_completion/"agentdeck.fish"
  end
end
