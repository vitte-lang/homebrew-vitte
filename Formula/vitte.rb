class Vitte < Formula
  desc "Vitte programming language (Rust implementation)"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2e6a3cc46d873999b6700e5083bb0335c55baa567ecd956ff9ad088a9bef458b"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--path", "crates/vitte-cli"
  end
end