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
    ohai "Starting Cargo build..."
    IO.popen(["cargo", "build", "--release", "--verbose"], err: [:child, :out]) do |io|
      io.each { |line| puts line }
    end
    ohai "Installing..."
    IO.popen(["cargo", "install", "--path", ".", "--root", prefix, "--verbose"], err: [:child, :out]) do |io|
      io.each { |line| puts line }
    end
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end