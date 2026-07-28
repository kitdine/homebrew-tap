# typed: strict
# frozen_string_literal: true

# Installs the versioned AgentDeck macOS binary and shell completions.
class AgentdeckRc < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  url "https://github.com/kitdine/agent-deck/releases/download/v0.2.0-rc.1/" \
      "agentdeck_v0.2.0-rc.1_darwin_#{on_arch_conditional arm: "arm64", intel: "amd64"}.tar.gz"
  version "0.2.0-rc.1"
  sha256 on_arch_conditional(
    arm:   "4f108233f15399dc6054a135f9da7002b980c3db60efdc0e919dd53d0ef909da",
    intel: "c0b1ff622d489c3b8b64a27be9e9bd51ef915d6efe4be5f4abf505007d3c4d2d",
  )
  license "MIT"
  conflicts_with "agentdeck", because: "both formulae install the agentdeck binary and shell completions"

  def install
    bin.install "agentdeck"
    generate_completions_from_executable(
      bin/"agentdeck",
      shell_parameter_format: :cobra,
      shells:                 [:bash, :zsh, :fish],
    )
  end

  test do
    output = shell_output("#{bin}/agentdeck version")
    assert_match "Release Version: v0.2.0-rc.1", output
    refute_match "dev", output
    assert_path_exists bash_completion/"agentdeck"
    assert_path_exists zsh_completion/"_agentdeck"
    assert_path_exists fish_completion/"agentdeck.fish"
  end
end
