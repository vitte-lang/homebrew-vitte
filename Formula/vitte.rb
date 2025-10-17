def install
  ENV["CARGO_HOME"] = (buildpath/"cargo_home").to_s
  ENV["RUSTUP_HOME"] = (buildpath/"rustup_home").to_s

  cd "crates/vitte-cli" do
    # Pas de std_cargo_args pour éviter --path en double
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  bin.install_symlink "vitte-bin" => "vitte" if (bin/"vitte-bin").exist?
end