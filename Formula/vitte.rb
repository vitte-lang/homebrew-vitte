class Vitte < Formula
  desc "Vitte programming language"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte.git", branch: "main"
  version "1.0.1"
  license "MIT"

  depends_on "rust" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    ENV["CARGO_TERM_PROGRESS_WHEN"] = "always"
    ENV["CARGO_TERM_COLOR"] = "always"
    ENV["CARGO_TERM_PROGRESS_WIDTH"] = "80"
    system "cargo", "build", "--release"
    ohai "Installing..."
    system "cargo", "install", "--path", ".", "--root", prefix
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end