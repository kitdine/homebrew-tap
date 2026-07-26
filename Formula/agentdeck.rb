# typed: strict
# frozen_string_literal: true

# Installs the versioned AgentDeck macOS binary and shell completions.
class Agentdeck < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  url "https://github.com/kitdine/agent-deck/releases/download/v0.1.1/" \
      "agentdeck_v0.1.1_darwin_#{on_arch_conditional arm: "arm64", intel: "amd64"}.tar.gz"
  version "0.1.1"
  sha256 on_arch_conditional(
    arm:   "b5fa4b27f3bb0fb30c497fb3823ff67f594729508cd431968a1974d93b30666d",
    intel: "f33ac2d0e2a0486d7696bb4c5b22384b6f81a58bfbcca03565083ecf1983e582",
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

  test do
    output = shell_output("#{bin}/agentdeck version")
    assert_match "Release Version: v0.1.1", output
    refute_match "dev", output
    assert_path_exists bash_completion/"agentdeck"
    assert_path_exists zsh_completion/"_agentdeck"
    assert_path_exists fish_completion/"agentdeck.fish"
  end
end
