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
    # Isoler Cargo pour éviter les conflits d'environnement
    ENV["CARGO_HOME"] = (buildpath/"cargo_home").to_s
    ENV["RUSTUP_HOME"] = (buildpath/"rustup_home").to_s

    # Crée le lockfile si inexistant
    system "cargo", "generate-lockfile" unless File.exist?("Cargo.lock")

    # Compilation complète depuis la racine (Cargo détecte les bins automatiquement)
    system "cargo", "install", *std_cargo_args

    # Si le binaire s'appelle vitte-bin, créer un alias vitte
    Dir.chdir(bin) do
      ln_s "vitte-bin", "vitte" if File.exist?("vitte-bin") && !File.exist?("vitte")
    end
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end