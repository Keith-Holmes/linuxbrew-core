class Vilistextum < Formula
  desc "HTML to text converter"
  homepage "https://bhaak.net/vilistextum/"
  url "https://bhaak.net/vilistextum/vilistextum-2.6.9.tar.gz"
  sha256 "3a16b4d70bfb144e044a8d584f091b0f9204d86a716997540190100c20aaf88d"
  license "GPL-2.0"

  livecheck do
    url "https://bhaak.net/vilistextum/download.html"
    regex(/href=.*?vilistextum[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      # Omit version with old scheme that is incorrectly treated as newest
      # NOTE: This `strategy` block can be removed in the future if/when the
      # download page only contains versions with three parts like 2.3.0.
      page.scan(regex).map { |match| (version = match.first) == "2.22" ? nil : version }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dfd4ab35a880dbac2c93e43eed5e0001093fad04c94c32f955c3f91822d84ccd"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1107f3edeb308819c5b074f1ed2072583c3bc5a7800af162ab10ef460548f18"
    sha256 cellar: :any_skip_relocation, catalina:      "cead55f6cb7e4d66d3f6ca2bf013f0cb653144a0fe79620fdd5735a1e57566a5"
    sha256 cellar: :any_skip_relocation, mojave:        "c36418e1556b9f5f9c0126811fddca3149137abfed6b36596ec4612c3806a3ec"
    sha256 cellar: :any_skip_relocation, high_sierra:   "6005ce3b4c593707dfe7ffbc10ea64f26ce6e441803a9133ab46ba0fbaee422f"
    sha256 cellar: :any_skip_relocation, sierra:        "b8fa6ddde71b9b86128e12bbc343935ca5ec58e15d28da2a1a9972a23df9becd"
    sha256 cellar: :any_skip_relocation, el_capitan:    "d46bae51c7e9a7193a735660af8583960c98e50f03aa33c8a9d81c22b2d9bf61"
    sha256 cellar: :any_skip_relocation, yosemite:      "77ab66b58db8649e9444584b5ee85e6c6c7badeb665425263c50282367eea003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e351bc8ccd19bf766514f585d1c8184ab7ad9d137dd10005e78cbd56ae9bb8" # linuxbrew-core
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/vilistextum", "-v"
  end
end
