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

    # Inspect workspace and find the first package exposing >=1 binary target
    metadata = JSON.parse(Utils.safe_popen_read("cargo", "metadata", "--format-version=1", "--no-deps"))
    bin_pkg = metadata["packages"].find { |p| p["targets"].any? { |t| t["kind"].include?("bin") } }
    odie "Aucun package binaire trouvé dans le workspace" unless bin_pkg

    manifest_dir = File.dirname(bin_pkg["manifest_path"])
    bin_targets = bin_pkg["targets"].select { |t| t["kind"].include?("bin") }.map { |t| t["name"] }
    odie "Aucune target binaire déclarée" if bin_targets.empty?

    ohai "Building in: #{manifest_dir} (package: #{bin_pkg["name"]})"
    Dir.chdir(manifest_dir) do
      # Build all binary targets for this package
      system "cargo", "build", "--release", "--locked", "--bins"

      # Install any produced binaries
      installed = []
      bin_targets.each do |tname|
        path = File.join("target", "release", tname)
        if File.exist?(path)
          bin.install path
          installed << tname
        end
      end

      odie "Aucun binaire construit dans target/release (#{bin_targets.join(", ")})" if installed.empty?
      ohai "Installed binaries: #{installed.join(", ")}"
    end
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end