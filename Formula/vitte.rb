class Vitte < Formula
  desc "Vitte language CLI"
  homepage "https://github.com/vitte-lang/vitte"
  url "https://github.com/vitte-lang/vitte/releases/download/v0.1.0/vitte-0.1.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "Apache-2.0"

  def install
    bin.install "bin/vitte"
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end