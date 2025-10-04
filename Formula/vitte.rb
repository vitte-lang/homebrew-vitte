class Vitte < Formula
  desc "Vitte programming language (Rust implementation)"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte/releases/download/v0.1.0/vitte-full-v0.1.0.tar.gz"
  sha256 "3b67a51f3ab5e061e55cc3b91510a5e83c748e328343f78bbe062ceb955038f1"
  license "MIT"

  head "https://github.com/vitte-lang/vitte.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "bin/vitte"
    pkgshare.install "share/vitte-src" => "vitte-src"
  end

  test do
    output = shell_output("#{bin}/vitte --version")
    assert_match version.to_s, output
  end
end