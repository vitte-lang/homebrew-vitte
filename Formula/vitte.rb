def install
  ENV["CARGO_HOME"] = (buildpath/"cargo_home").to_s
  ENV["RUSTUP_HOME"] = (buildpath/"rustup_home").to_s
  system "cargo", "generate-lockfile" unless File.exist?("Cargo.lock")

  cd "crates/vitte-cli" do
    system "cargo", "install", *std_cargo_args
  end

  bin.install_symlink "vitte-bin" => "vitte" if (bin/"vitte-bin").exist?
end