class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/v3.3.tar.gz"
  sha256 "3caf14731313c99967f6e4e11ff261b061e4e3d0c7ef7565e89b12e0307814ca"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f310aad5e98a7cf3c6fca8a1ddcda9af425cb7b442512b5c540619de0312cb60"
    sha256 cellar: :any,                 big_sur:       "8db3861063efc1a5e53703b41993328968aa637ae4fed60112ac8ff4e364a422"
    sha256 cellar: :any,                 catalina:      "6a80f6cbc858fbc942c5845492ca6bfefdf2dd4f0746f97e28704301585f19aa"
    sha256 cellar: :any,                 mojave:        "34f8c691f2c2d23fc65bc84429f0282c96d47f88036ada6d6f44761287a88441"
  end

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", "-DECM_DIR=#{Formula["extra-cmake-modules"].opt_share}/ECM/cmake", *std_cmake_args
    system "make", "install"
  end

  test do
    on_macos do
      system "#{bin}/icemon", "--version"
    end
    on_linux do
      assert_match("qt.qpa.xcb: could not connect to display",
                   shell_output("#{bin}/icemon --version 2>&1", 134))
    end
  end
end
