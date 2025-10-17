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
    # Environnement cargo isolé
    ENV["CARGO_HOME"] = (buildpath/"cargo_home").to_s
    ENV["RUSTUP_HOME"] = (buildpath/"rustup_home").to_s

    # Génère le lockfile si absent
    system "cargo", "generate-lockfile" unless File.exist?("Cargo.lock")

    # Compile et installe depuis le dossier src/
    cd "src" do
      system "cargo", "install", *std_cargo_args
    end

    # Crée le lien vitte -> vitte-bin
    cd bin do
      ln_s "vitte-bin", "vitte" unless File.exist?("vitte")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vitte --version")
  end
end