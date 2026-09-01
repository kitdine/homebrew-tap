# typed: strict
# frozen_string_literal: true

# Installs the versioned AgentDeck macOS binary and shell completions.
class AgentdeckRc < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  url "https://github.com/kitdine/agent-deck/releases/download/v0.5.0-rc.2/" \
      "agentdeck_v0.5.0-rc.2_darwin_#{on_arch_conditional arm: "arm64", intel: "amd64"}.tar.gz"
  version "0.5.0-rc.2"
  sha256 on_arch_conditional(
    arm:   "cb5d564a0cada0862459afe4f8aeb068c967fac560dff09a3cb47280c98ef8b8",
    intel: "7ce75746562b19b09a80178498350c39f95af0f696d042eb5fee46bceb9af33f",
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
    assert_match "Release Version: v0.5.0-rc.2", output
    refute_match "dev", output
    assert_path_exists bash_completion/"agentdeck"
    assert_path_exists zsh_completion/"_agentdeck"
    assert_path_exists fish_completion/"agentdeck.fish"
  end
end
