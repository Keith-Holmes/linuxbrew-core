class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://downloads.sourceforge.net/project/calc/calc/2.13.0.1/calc-2.13.0.1.tar.bz2"
  sha256 "6ae538f57785c5701a70112ccf007ab5553abd332ae2deaadaf564f401c734ad"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "20a69341f5baf00f5c9fa73998ce3f02939af44146d6eee3177854488e474df4"
    sha256 big_sur:       "cdc2b4bce30dccf2193ea5a457dfa02e4ae1ba0af97fce660221c5d3882e79a3"
    sha256 catalina:      "95bce9b12aab68a4d8e30121e0a0be5e0e7447e09bcc11d9d7e371956c724433"
    sha256 mojave:        "57ac9fb9353e5bd4dd6bf6f62aca96252a064e51d102fd89389934fefa999b2c"
    sha256 x86_64_linux:  "71bf85560fa4ab29c1929b7225b7630a7f02b05cfd446a3bb5d027b0c7787e89" # linuxbrew-core
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
