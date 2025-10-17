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
    # Isoler Cargo pour empêcher l’écriture dans ~/.cargo
    ENV["CARGO_HOME"]  = (buildpath/"cargo_home").to_s
    ENV["RUSTUP_HOME"] = (buildpath/"rustup_home").to_s

    # Compiler et installer depuis le crate CLI
    cd "crates/vitte-cli" do
      args = ["install", "--root", prefix, "--path", ".", "-vv"]
      args.insert(1, "--locked") if File.exist?("Cargo.lock")
      system "cargo", *args
    end

    # Créer le lien symbolique vitte -> vitte-bin si présent
    bin.install_symlink "vitte-bin" => "vitte" if (bin/"vitte-bin").exist?
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end