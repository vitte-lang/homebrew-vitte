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
    # Corrige le workspace si le tarball référence "tests"
    inreplace "Cargo.toml", /"tests"\s*,?\s*/m, "" if File.read("Cargo.toml").include?("\"tests\"")

    # Construire et installer le binaire avec la VM activée
    system "cargo", "install",
           *std_cargo_args(path: "crates/vitte-cli"),
           "--features", "vm"

    # Conserver tout le projet comme le fait la formule rust (dans libexec/share)
    (libexec/"src").install Dir["*"]
  end

  def caveats
    <<~EOS
      Le binaire 'vitte' est installé dans #{HOMEBREW_PREFIX}/bin.
      Le code source complet est conservé dans :
        #{libexec}/src
    EOS
  end

  test do
    system bin/"vitte", "--version"
    (testpath/"main.vitte").write('fn main() { println("ok"); }')
    system bin/"vitte", "run", "main.vitte"
  end
end