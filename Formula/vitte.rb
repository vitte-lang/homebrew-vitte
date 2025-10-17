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
    # Active le mode verbeux complet pour Cargo et Homebrew
    ENV["CARGO_TERM_VERBOSE"] = "true"
    ENV["RUST_BACKTRACE"] = "full"
    ENV["RUST_LOG"] = "debug"
    ENV.deparallelize # pour afficher les logs séquentiellement

    odie "Erreur: cargo introuvable" unless which("cargo")

    # Affiche le commit actuel pour traçabilité
    system "git", "rev-parse", "HEAD"

    # Compilation détaillée
    system "cargo", "install",
           "--locked",
           "--root", prefix,
           "--path", ".",
           "--verbose"

    # Lien symbolique vers le binaire principal
    bin.install_symlink "vitte-bin" => "vitte" if (bin/"vitte-bin").exist?

    # Nettoyage du dossier temporaire après build
    rm_rf buildpath
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end