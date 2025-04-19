{
  pkgs,
  lib,
  rustowl-src,
  makeRustPlatform,
}: let
  toolchain = pkgs.rust-bin.fromRustupToolchainFile "${rustowl-src}/rustowl/rust-toolchain.toml";
  toolchainTOML = lib.importTOML "${rustowl-src}/rustowl/rust-toolchain.toml";
  cargoTOML = lib.importTOML "${rustowl-src}/rustowl/Cargo.toml";
  rustPlatform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "rustowl";
    version = "${cargoTOML.package.version}-unstable";

    src = rustowl-src;

    sourceRoot = "source/rustowl";

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${src}/rustowl/Cargo.lock";
    };

    nativeBuildInputs = [
      toolchain
    ];

    RUSTOWL_TOOLCHAIN = toolchainTOML.toolchain.channel;
    RUSTOWL_TOOLCHAIN_DIR = "${toolchain}";

    meta = with lib; {
      description = "Visualize ownership and lifetimes in Rust for debugging and optimization";
      longDescription = ''
        RustOwl visualizes ownership movement and lifetimes of variables.
        When you save Rust source code, it is analyzed, and the ownership and
        lifetimes of variables are visualized when you hover over a variable or function call.
      '';
      homepage = "https://github.com/cordx56/rustowl";
      license = licenses.mpl20;
      maintainers = [lib.maintainers.mrcjkb];
      platforms = platforms.all;
      mainProgram = "cargo-owlsp";
    };
  }
