class Log4c < Formula
  desc "Logging Framework for C"
  homepage "https://log4c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz"
  sha256 "5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea"
  license "LGPL-2.1"
  head "https://git.code.sf.net/p/log4c/log4c.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4c[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "13c3c642cb9d105c742bb313fde02b1968dee00017ac5fa96e46a908ae43e996"
    sha256 big_sur:       "fa93c7beb25097d19cd6408e88e1d5bf8019386cdee22beb0f30d1fa7956286e"
    sha256 catalina:      "25859511ac3302318ca6eed1eaa89c5a9b1e91b611da4233604e443d9c016dec"
    sha256 mojave:        "8e35c261de43e25fe934f9f77875ff9c5fa6bdc4297fd0dd2fc657a5acd680ae"
    sha256 high_sierra:   "4019efd84d56e2390feff696e1fa3305b788fdcb3105c5b6117913e81a16a7f2"
    sha256 sierra:        "171a6c3f12f957d5442998f0f02df959aa4376ef543338765930ed4e062ef0ea"
    sha256 el_capitan:    "2334e58e3ae201b28362707d2b64701e2e1378695e915baad886956e4edea50a"
    sha256 yosemite:      "d345d0ab182855859fb21148c708893a395ecd416ba3f05d5e2a5a3111f2bc61"
    sha256 x86_64_linux:  "65c931a2251c000152e3b28742026b0c62f09c74626b73963a98bc371d3596d7" # linuxbrew-core
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/log4c-config", "--version"
  end
end
