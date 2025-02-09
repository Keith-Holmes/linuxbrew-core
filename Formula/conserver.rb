class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/bstansell/conserver/releases/download/v8.2.6/conserver-8.2.6.tar.gz"
  sha256 "33b976a909c6bce8a1290810e26e92bfa16c39bca19e1f8e06d5d768ae940734"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "818c726d7aef2b761e3ae88b39650e01f74f757acf899f7f351bdd2815d27875"
    sha256 cellar: :any,                 big_sur:       "84d3aa85edeae0dc29cf8e9f4dded552ab0f9b82dac3b711ecdb8a2bba94115a"
    sha256 cellar: :any,                 catalina:      "59eded66b17cf4854626060c9c012efa25fe09c5fed47c0c162047a5aac1171e"
    sha256 cellar: :any,                 mojave:        "ff0421a6796b9913159a910628f97878d2b22956f18e23e8d27bd400e6b611a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dfd9e3f1afd9e5452afdabb9ee9a9952a3a345aee04fb0c26d25984b7bd65e5" # linuxbrew-core
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl", "--with-ipv6"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
