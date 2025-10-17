class Vitte < Formula
  desc "Langage de programmation Vitte"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte/releases/download/v0.1.0/vitte-0.1.0.tar.gz"
  sha256 "2e6a3cc46d873999b6700e5083bb0335c55baa567ecd956ff9ad088a9bef458b"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end