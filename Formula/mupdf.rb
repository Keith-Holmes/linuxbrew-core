class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.18.0-source.tar.xz"
  sha256 "592d4f6c0fba41bb954eb1a41616661b62b134d5b383e33bd45a081af5d4a59a"
  license "AGPL-3.0-or-later"
  revision OS.mac? ? 1 : 2
  head "https://git.ghostscript.com/mupdf.git"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b656ec4a7c2cbb3b55b52678e5129bbeb27215c793cd6e3876d40a51d293bd84" => :catalina
    sha256 "5b06c1203b68608f64d082b83db659a46d98a849d79530bfa83f28adb970e17e" => :mojave
    sha256 "32dc7277f5dce0762c695ecf15f3ec745ec7767afec09f6acefc4aea86386873" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freeglut"
  depends_on "mesa"
  depends_on "openssl@1.1"
  depends_on "openssl@1.1"

  unless OS.mac?
    depends_on "linuxbrew/xorg/glu"
    depends_on "linuxbrew/xorg/xinput"
  end

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    glut_cflags = `pkg-config --cflags glut gl`.chomp
    glut_libs = `pkg-config --libs glut gl`.chomp
    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "SYS_GLUT_CFLAGS=#{glut_cflags}",
           "SYS_GLUT_LIBS=#{glut_libs}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
