class Vitte < Formula
  desc "Langage de programmation Vitte"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte/releases/download/v0.1.0/vitte-0.1.0.tar.gz"
  sha256 "A_REMPLACER_PAR_TA_SHA256"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end