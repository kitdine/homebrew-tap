# typed: strict
# frozen_string_literal: true

# Installs the versioned AgentDeck macOS binary and shell completions.
class Agentdeck < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  url "https://github.com/kitdine/agent-deck/releases/download/v0.2.0/" \
      "agentdeck_v0.2.0_darwin_#{on_arch_conditional arm: "arm64", intel: "amd64"}.tar.gz"
  version "0.2.0"
  sha256 on_arch_conditional(
    arm:   "1c1fe19709337d80d3aaeb0feec37291d63397a077dedc6fb31479bc3ac67cf5",
    intel: "23c8bf49b5f51e4f4e9ace5f500816d5768d728f5ca9c86a733c2d49655545a2",
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
    assert_match "Release Version: v0.2.0", output
    refute_match "dev", output
    assert_path_exists bash_completion/"agentdeck"
    assert_path_exists zsh_completion/"_agentdeck"
    assert_path_exists fish_completion/"agentdeck.fish"
  end
end
