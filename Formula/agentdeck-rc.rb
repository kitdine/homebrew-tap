# typed: strict
# frozen_string_literal: true

# Installs the versioned AgentDeck macOS binary and shell completions.
class AgentdeckRc < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  url "https://github.com/kitdine/agent-deck/releases/download/v0.2.0-rc.2/" \
      "agentdeck_v0.2.0-rc.2_darwin_#{on_arch_conditional arm: "arm64", intel: "amd64"}.tar.gz"
  version "0.2.0-rc.2"
  sha256 on_arch_conditional(
    arm:   "f267f08b40b54208a64bb6e7498dd1ee99b9e93f26c0504f01b58d1c22da880c",
    intel: "37346e81be54e923ba7fcf73bde41ce92d283a3ca8c5c2ab434cb2adf2983861",
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
    assert_match "Release Version: v0.2.0-rc.2", output
    refute_match "dev", output
    assert_path_exists bash_completion/"agentdeck"
    assert_path_exists zsh_completion/"_agentdeck"
    assert_path_exists fish_completion/"agentdeck.fish"
  end
end
