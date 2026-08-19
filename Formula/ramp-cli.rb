class RampCli < Formula
  desc "CLI for Ramp's Developer API"
  homepage "https://github.com/ramp-public/ramp-cli"
  version "0.2.22"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-darwin-arm64.tar.gz"
      sha256 "55910c4c21d0dde1e6b7579215efd7f0467b392613adf69f4c281e0cba74c799"
    else
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-darwin-amd64.tar.gz"
      sha256 "05df960921f6d175c270ba52d80471934100e7a8b16379389949df6d6610e221"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-linux-arm64.tar.gz"
      sha256 "dcf4433ecb17217157f4fba14b21108d53dba9c38dd7d78af8db0e95e7a25d9e"
    else
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-linux-amd64.tar.gz"
      sha256 "5e74bb41fe50603da863dc9bfa40e832f34f83595548ab23916a9d65a91528f1"
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
