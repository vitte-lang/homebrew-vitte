class Vitte < Formula
  desc "Langage de programmation Vitte"
  homepage "https://github.com/vitte-lang/vitte"
  head "https://github.com/vitte-lang/vitte.git", branch: "main"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end