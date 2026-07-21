class Agentdeck < Formula
  desc "CLI for managing multiple Codex/Claude providers, usage, and credentials"
  homepage "https://github.com/kitdine/agent-deck"
  version "0.1.0"
  license "MIT"

  on_arm do
    url "https://github.com/kitdine/agent-deck/releases/download/v0.1.0/agentdeck_v0.1.0_darwin_arm64.tar.gz"
    sha256 "5ea9690be9c5bd76c15f4bb867d7f531758b71a3413e09ac078401c18af8db3f"
  end

  on_intel do
    url "https://github.com/kitdine/agent-deck/releases/download/v0.1.0/agentdeck_v0.1.0_darwin_amd64.tar.gz"
    sha256 "e53f18f3d1958b37622704aa941b58a0751e4455cb14291a38600d2e974b4bfc"
  end

  def install
    bin.install "agentdeck"
  end

  test do
    output = shell_output("#{bin}/agentdeck version")
    assert_match "Release Version: v0.1.0", output
    refute_match "dev", output
  end
end
