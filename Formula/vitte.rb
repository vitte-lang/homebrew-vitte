class Vitte < Formula
  desc "Langage de programmation moderne inspiré de Rust"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte.git",
      tag:      "v0.1.0",
      revision: "0ae6d7f41ed060a0e7321e2356353d6818033b6c"
  version "0.1.0"
  license "MIT"
  head "https://github.com/vitte-lang/vitte.git", branch: "main"



  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      Le binaire 'vitte' a été installé dans :
        #{HOMEBREW_PREFIX}/bin/vitte

      Pour vérifier :
        vitte --version

      Pour mettre à jour :
        brew update && brew upgrade vitte
    EOS
  end

  test do
    assert_match "vitte", shell_output("#{bin}/vitte --version")
  end
end