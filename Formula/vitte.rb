class Vitte < Formula
  desc "Langage de programmation Vitte"
  homepage "https://github.com/vitte-lang/vitte"

  # Stable depuis un tag Git (pas de tar.gz nécessaire)
  url "https://github.com/vitte-lang/vitte.git",
      tag:      "v0.1.0",
      revision: "0ae6d7f41ed060a0e7321e2356353d6818033b6c"
  version "0.1.0"
  license "MIT"

  head "https://github.com/vitte-lang/vitte.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end