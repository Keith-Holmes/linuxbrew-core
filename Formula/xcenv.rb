class Xcenv < Formula
  desc "Xcode version manager"
  homepage "https://github.com/xcenv/xcenv"
  url "https://github.com/xcenv/xcenv/archive/v1.2.0.tar.gz"
  sha256 "bbb47394f9edbdabba886e5ca0155f0ef6aeae07b8a7564c652c8e260fac6d9f"
  license "MIT"
  head "https://github.com/xcenv/xcenv.git", branch: "master"

  depends_on :macos

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    shell_output("eval \"$(#{bin}/xcenv init -)\" && xcenv versions")
  end
end
