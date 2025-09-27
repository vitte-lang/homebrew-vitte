class Vitte < Formula
  desc "Vitte programming language (Rust implementation)"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2e6a3cc46d873999b6700e5083bb0335c55baa567ecd956ff9ad088a9bef458b"
  license "MIT"
  head "https://github.com/vitte-lang/vitte.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    # Nettoie le membre "tests" si présent dans le tarball
    inreplace "Cargo.toml", /"tests"\s*,?\s*/m, "" if File.read("Cargo.toml").include?("\"tests\"")

    # Installe le CLI avec la VM activée
    system "cargo", "install",
           *std_cargo_args(path: "crates/vitte-cli"),
           "--features", "vm"
  end

  test do
    system bin/"vitte", "--version"
  end
end