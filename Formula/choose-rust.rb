class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.3.3.tar.gz"
  sha256 "336225a05d98e536f79969c2d1727c8371df3d289e4aebe15a1a476db0f84df2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "440282c50599a3d526f71bdbbac3fb4a785823feca10a87fd36e4ff27adb94c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "56d66443ce6086e2d57c859a6fac3bc2d445b86c4430d607a33c6b2071d7e141"
    sha256 cellar: :any_skip_relocation, catalina:      "406b87daee82a7cd5c1d56ec7188dbf2508ae0d7ae4471a6d1d8b2aced7f620c"
    sha256 cellar: :any_skip_relocation, mojave:        "9a0420cd48ff40827bc3ed2db756b4a926eaa9422236e00aba05cb68c9232d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "323931303dbfe68d7b25e2aeaa3c0f96f70b27b68761ee69df235c8493d99607" # linuxbrew-core
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
