class RampCli < Formula
  desc "CLI for Ramp's Developer API"
  homepage "https://github.com/ramp-public/ramp-cli"
  version "0.2.27"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-darwin-arm64.tar.gz"
      sha256 "59951463c17e1dacdaf4b96f2e432410fe2d8b83c03da98b5f2f5d4e79e366d3"
    else
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-darwin-amd64.tar.gz"
      sha256 "d24680195c8cc56eb45efe0310d39e021f23d4af5c0eb60b0a4465f70f6cb55b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-linux-arm64.tar.gz"
      sha256 "4f91ce66724a039b5c4ba9f3135bd475a65c1dd64ac641d39adb765e7261774a"
    else
      url "https://github.com/ramp-public/ramp-cli/releases/download/v#{version}/ramp-linux-amd64.tar.gz"
      sha256 "c5c7086cb5dd0c03e65854730ff7c60b80a8f3d8af828ebcf75fd0f191b92757"
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
