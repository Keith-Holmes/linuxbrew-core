class Ndenv < Formula
  desc "Node version manager"
  homepage "https://github.com/riywo/ndenv"
  url "https://github.com/riywo/ndenv/archive/v0.4.0.tar.gz"
  sha256 "1a85e4c0c0eee24d709cbc7b5c9d50709bf51cf7fe996a1548797a4079e0b6e4"
  license "MIT"
  head "https://github.com/riywo/ndenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d36486433ad28c722a9d0e3b6e780e369beea2855a126c91abae2c1e83384c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "11134806587add67781fb03d7be2fd2322029e77e4b744d927fba9afbe6e1b82"
    sha256 cellar: :any_skip_relocation, catalina:      "11134806587add67781fb03d7be2fd2322029e77e4b744d927fba9afbe6e1b82"
    sha256 cellar: :any_skip_relocation, mojave:        "11134806587add67781fb03d7be2fd2322029e77e4b744d927fba9afbe6e1b82"
  end

  depends_on "node-build"

  def install
    inreplace "libexec/ndenv" do |s|
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/ndenv.d", \
            ":#{HOMEBREW_PREFIX}/etc/ndenv.d\\0"
      end
    end

    if build.head?
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/, \
          %Q(\\1"\\2-g#{Utils.git_short_head}")
    end

    prefix.install "bin", "completions", "libexec"
    system "#{bin}/ndenv", "rehash"
  end

  test do
    shell_output "eval \"$(#{bin}/ndenv init -)\" && ndenv versions"
  end
end
