{
  pkgs,
  lib,
  rustowl-src,
  makeRustPlatform,
}: let
  toolchain = pkgs.rust-bin.fromRustupToolchainFile "${rustowl-src}/rust-toolchain.toml";
  toolchainTOML = lib.importTOML "${rustowl-src}/rust-toolchain.toml";
  cargoTOML = lib.importTOML "${rustowl-src}/Cargo.toml";
  rustPlatform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "rustowl";
    version = "${cargoTOML.package.version}-unstable";

    src = rustowl-src;

    cargoDeps = rustPlatform.importCargoLock {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = [
      toolchain
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.openssl
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
