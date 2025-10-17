class Vitte < Formula
  desc "Unified Vitte language toolchain and CLI"
  homepage "https://vitte-lang.github.io/vitte/"
  url "https://github.com/vitte-lang/vitte.git",
      branch:   "main",
      revision: "ba073abc56c9fa28e9d79ee84306dc1c0f07e4a9"
  version "0.1.0"
  license "Apache-2.0"
  head "https://github.com/vitte-lang/vitte.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "generate-lockfile" unless File.exist?("Cargo.lock")

    # Détecte le dossier du crate CLI
    cli_dirs = %w[crates/vitte-cli cli src .]
    cli_dir = cli_dirs.find { |d| Dir.exist?(d) && File.exist?(File.join(d, "Cargo.toml")) }
    odie "CLI crate introuvable (cherché: #{cli_dirs.join(", ")})" unless cli_dir

    cd cli_dir do
      # Installe avec std_cargo_args dans le bon dossier
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end