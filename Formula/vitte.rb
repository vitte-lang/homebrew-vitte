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

    md = JSON.parse(Utils.safe_popen_read("cargo", "metadata", "--format-version=1", "--no-deps"))
    workspace_ids = md["workspace_members"] || md.fetch("packages", []).map { |p| p["id"] }
    pkgs = md["packages"].select { |p|
      workspace_ids.include?(p["id"]) &&
      p["targets"].any? { |t| t["kind"].include?("bin") }
    }
    odie "Aucun package binaire dans le workspace" if pkgs.empty?

    all_installed = []

    pkgs.each do |pkg|
      manifest_dir = File.dirname(pkg["manifest_path"])
      bin_targets = pkg["targets"].select { |t| t["kind"].include?("bin") }.map { |t| t["name"] }
      next if bin_targets.empty?

      ohai "Building package: #{pkg["name"]} (#{manifest_dir})"
      Dir.chdir(manifest_dir) do
        system "cargo", "build", "--release", "--locked", "--bins"
        bin_targets.each do |tname|
          path = File.join("target", "release", tname)
          next unless File.exist?(path)
          bin.install path
          all_installed << tname
        end
      end
    end

    odie "Aucun binaire construit dans le workspace" if all_installed.empty?
    ohai "Installed binaries: #{all_installed.uniq.join(", ")}"

    # Fournir une commande 'vitte' stable si inexistante
    unless all_installed.include?("vitte")
      primary = all_installed.first
      (bin/"vitte").write <<~SH
        #!/bin/sh
        exec "#{bin}/#{primary}" "$@"
      SH
      (bin/"vitte").chmod 0755
      ohai "Created shim 'vitte' -> #{primary}"
    end
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end