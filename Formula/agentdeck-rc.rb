# typed: strict
# frozen_string_literal: true

# Installs the versioned AgentDeck macOS binary and shell completions.
class AgentdeckRc < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  url "https://github.com/kitdine/agent-deck/releases/download/v0.2.1-rc.1/" \
      "agentdeck_v0.2.1-rc.1_darwin_#{on_arch_conditional arm: "arm64", intel: "amd64"}.tar.gz"
  version "0.2.1-rc.1"
  sha256 on_arch_conditional(
    arm:   "6e23471303954254a3a5bea10a2e722417b21fa32752d8ca51301a3260356bf2",
    intel: "39bc88ebb2db6e668118cf14b421f3c20e2536019a8be4a7717ad23ccab48d6a",
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
    assert_match "Release Version: v0.2.1-rc.1", output
    refute_match "dev", output
    assert_path_exists bash_completion/"agentdeck"
    assert_path_exists zsh_completion/"_agentdeck"
    assert_path_exists fish_completion/"agentdeck.fish"
  end
end
