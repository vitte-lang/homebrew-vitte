require "json"

class Vitte < Formula
  desc "Vitte programming language"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte.git", branch: "main"
  version "1.0.1"
  license "MIT"

  depends_on "rust" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    ENV["CARGO_TERM_PROGRESS_WHEN"] = "always"
    ENV["CARGO_TERM_COLOR"] = "always"
    ENV["CARGO_TERM_PROGRESS_WIDTH"] = "80"

    # Résout l’erreur du workspace : trouve le crate binaire
    metadata_json = Utils.safe_popen_read("cargo", "metadata", "--format-version=1", "--no-deps")
    metadata = JSON.parse(metadata_json)
    bin_pkg = metadata["packages"].find { |p| p["targets"].any? { |t| t["kind"].include?("bin") && t["name"] == "vitte" } } ||
              metadata["packages"].find { |p| p["targets"].any? { |t| t["kind"].include?("bin") } }
    odie "Aucun package binaire trouvé dans le workspace" unless bin_pkg

    manifest_dir = File.dirname(bin_pkg["manifest_path"])
    ohai "Installing from: #{manifest_dir} (package: #{bin_pkg["name"]})"
    Dir.chdir(manifest_dir) do
      system "cargo", "install", "--locked", "--path", ".", "--root", prefix
    end
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end