class Vitte < Formula
  desc "Vitte programming language (Rust implementation)"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "2e6a3cc46d873999b6700e5083bb0335c55baa567ecd956ff9ad088a9bef458b"
  license "MIT"
  head "https://github.com/vitte-lang/vitte.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    # build du CLI
    cd "crates/vitte-cli" do
      system "cargo", "install", *std_cargo_args
    end

    # copie dans ~/vitte/bin
    vitte_dir = Pathname.new(Dir.home)/"vitte/bin"
    vitte_dir.mkpath
    (vitte_dir/"vitte").write <<~EOS
      #!/bin/sh
      exec "#{bin}/vitte" "$@"
    EOS
    (vitte_dir/"vitte").chmod 0755
  end

  test do
    system bin/"vitte", "--version"
  end
end