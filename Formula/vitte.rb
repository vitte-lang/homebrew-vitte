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
    # Installe le binaire principal
    bin.install "bin/vitte"

    # Facultatif : installe les sources dans /usr/local/share/vitte-src
    pkgshare.install "share/vitte-src" if Dir.exist?("share/vitte-src")

    # Documentation optionnelle
    doc.install "README.md" if File.exist?("README.md")
    doc.install "LICENSE" if File.exist?("LICENSE")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vitte --version")
  end
end