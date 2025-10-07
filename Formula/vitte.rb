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
    start_time = Time.now
    puts "Build started at: #{start_time}"
    IO.popen(["cargo", "build", "--release", "--verbose"], err: [:child, :out]) do |io|
      io.each do |line|
        puts "[#{Time.now.strftime("%H:%M:%S")}] #{line}"
        $stdout.flush
      end
    end
    ohai "Installing..."
    IO.popen(["cargo", "install", "--path", ".", "--root", prefix, "--verbose"], err: [:child, :out]) do |io|
      io.each do |line|
        puts "[#{Time.now.strftime("%H:%M:%S")}] #{line}"
        $stdout.flush
      end
    end
    puts "Build finished at: #{Time.now}"
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end