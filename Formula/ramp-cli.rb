class RampCli < Formula
  desc "CLI for Ramp's Developer API"
  homepage "https://github.com/ramp-public/ramp-cli"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-darwin-arm64.tar.gz"
      sha256 "13751e35edaac3bb709107b9afca02b33eaebc27a1627ba65f3ea318f874bb0e"
    else
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-darwin-amd64.tar.gz"
      sha256 "45bdee265018c9f687f25c50ef8c3f4a4c762333ad4d0d874c4d1796c627565c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-linux-arm64.tar.gz"
      sha256 "28b2386d0c08f581928ed7219fed747b15d4be8f9241f03f4707a88ef4c04a1a"
    else
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-linux-amd64.tar.gz"
      sha256 "c07a39007ec06c05545bb2e7a134a437806d1168f064fb68feaa106ca2e55360"
    end
  end

  def install
    # The tarball contains main.dist/ with the Nuitka standalone binary and
    # bundled shared libraries. Install everything into libexec/ and symlink
    # the binary into bin/.
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    binary_name = "ramp-#{os}-#{arch}"

    # Find the standalone distribution directory (main.dist/)
    dist_dir = buildpath / "main.dist"
    if dist_dir.exist?
      libexec.install dist_dir.children
    else
      # Fallback: install everything in the current directory
      libexec.install buildpath.children
    end

    bin.install_symlink libexec / binary_name => "ramp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ramp --version")
  end
end
