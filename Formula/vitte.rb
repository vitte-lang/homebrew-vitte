class Vitte < Formula
  desc "Unified Vitte language toolchain and CLI"
  homepage "https://vitte-lang.github.io/vitte/"
  url "https://github.com/vitte-lang/vitte.git",
      branch: "main",
      revision: "ba073abc56c9fa28e9d79ee84306dc1c0f07e4a9"
  version "0.1.0"
  license "Apache-2.0"
  head "https://github.com/vitte-lang/vitte.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix
    bin.install_symlink "vitte-bin" => "vitte" if (bin/"vitte-bin").exist?
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end