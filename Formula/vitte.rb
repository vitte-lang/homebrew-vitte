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
  depends_on "git" => :build

  def install
    # Reproduit la sortie la plus détaillée possible du build Rust
    ENV["CARGO_TERM_VERBOSE"] = "true"
    ENV["CARGO_TERM_PROGRESS_WHEN"] = "always"
    ENV["RUST_BACKTRACE"] = "full"
    ENV["RUSTC_LOG"] = "rustc::codegen=info"
    ENV["RUST_LOG"] = "cargo::core::compiler::fingerprint=debug"

    odie "Erreur: cargo introuvable" unless which("cargo")

    # Affiche le commit pour le suivi
    system "git", "rev-parse", "HEAD"

    # Compilation stricte et verbeuse (-vv = logs complets rustc)
    system "cargo", "install",
           "--locked",
           "--root", prefix,
           "--path", ".",
           "-vv"

    # Lien symbolique vitte -> vitte-bin
    bin.install_symlink "vitte-bin" => "vitte" if (bin/"vitte-bin").exist?

    rm_rf buildpath
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end