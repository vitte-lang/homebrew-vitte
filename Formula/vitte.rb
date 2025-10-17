class Vitte < Formula
  desc "Unified Vitte language toolchain and CLI"
  homepage "https://vitte-lang.github.io/vitte/"
  url "https://github.com/vitte-lang/vitte/releases/download/v0.1.0/vitte-0.1.0.tar.gz"
  sha256 "29591c1b413398b9497210a7884508c3e2a1638ccb6c0a85232acdc138066dbf"
  license "Apache-2.0"
  head "https://github.com/vitte-lang/vitte.git", branch: "main"

  depends_on "rust" => :build

  def install
    ENV["CARGO_HOME"]  = (buildpath/"cargo_home").to_s
    ENV["RUSTUP_HOME"] = (buildpath/"rustup_home").to_s

    cd "crates/vitte-cli" do
      args = ["install", "--root", prefix, "--path", "."]
      args.insert(1, "--locked") if File.exist?("Cargo.lock")
      system "cargo", *args
    end

    bin.install_symlink "vitte-bin" => "vitte" if (bin/"vitte-bin").exist?
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end