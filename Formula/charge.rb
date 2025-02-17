require "language/node"

class Charge < Formula
  desc "Opinionated, zero-config static site generator"
  homepage "https://charge.js.org"
  url "https://registry.npmjs.org/@static/charge/-/charge-1.7.0.tgz"
  sha256 "477e6eb2a5d99854b4640017d85ee5f4ea09431a2ff046113047764f64d21ab5"
  license "MIT"
  head "https://github.com/brandonweiss/charge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cfacd98af0f9c2293eef24cb7610a5d2cf60ff237cf790b1ad5ff6cad018a855"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d23d1330af8394dc65fd857829da237d45ffabe57f2e59019f0564a0b2c7d95"
    sha256 cellar: :any_skip_relocation, catalina:      "b6b02c7658ca9d8c8211554a74d399f5a9188f516e152fb7eee5a2b879d050d3"
    sha256 cellar: :any_skip_relocation, mojave:        "f2d73159f3331a3c7a6126eb7054fb987abf89598521fad3dece201f06cbf79d"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2dcccfe026217c62a72db3ff501ee56c1c8216e5f00e567ca12706aaddb6ea8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cad826732c97a901a3afb65e8585d5272736acbd5f1182bf91b3d91096fab5e4" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"src/index.html.jsx").write <<~EOS
      import Component from "./component.html.jsx"

      export default () => {
        return <Component message="Hello!" />
      }
    EOS

    (testpath/"src/component.html.jsx").write <<~EOS
      export default (props) => {
        return <p>{props.message}</p>
      }
    EOS

    system bin/"charge", "build", "src", "out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
