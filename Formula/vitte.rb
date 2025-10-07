require "pty"
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
    ohai "Starting Cargo build..."
    start_time = Time.now
    puts "Build started at: #{start_time}"
    total_steps = 0
    completed_steps = 0
    PTY.spawn({"CARGO_TERM_PROGRESS_WHEN"=>"always", "CARGO_TERM_COLOR"=>"always"}, "cargo", "build", "--release") do |r, _w, _pid|
      r.each do |line|
        if line.include?("Compiling") || line.include?("Building")
          total_steps += 1
        elsif line.include?("Finished")
          completed_steps = total_steps
        end
        percent = total_steps.zero? ? 0 : (completed_steps.to_f / total_steps * 100).clamp(0, 100)
        bar = ("#" * (percent / 2)).ljust(50)
        print "\r[#{bar}] #{percent.round(1)}%  #{line.strip}"
        $stdout.flush
      end
    end
    puts "\nBuild completed."
    ohai "Installing..."
    total_steps = 0
    completed_steps = 0
    PTY.spawn({"CARGO_TERM_PROGRESS_WHEN"=>"always", "CARGO_TERM_COLOR"=>"always"}, "cargo", "install", "--path", ".", "--root", prefix) do |r, _w, _pid|
      r.each do |line|
        if line.include?("Compiling") || line.include?("Installing")
          total_steps += 1
        elsif line.include?("Finished")
          completed_steps = total_steps
        end
        percent = total_steps.zero? ? 0 : (completed_steps.to_f / total_steps * 100).clamp(0, 100)
        bar = ("#" * (percent / 2)).ljust(50)
        print "\r[#{bar}] #{percent.round(1)}%  #{line.strip}"
        $stdout.flush
      end
    end
    puts "\nInstallation completed."
    puts "Build finished at: #{Time.now}"
  end

  test do
    system "#{bin}/vitte", "--version"
  end
end