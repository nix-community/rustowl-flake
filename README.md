# A Nix flake for [rustowl](https://github.com/cordx56/rustowl)

rustowl requires a very specific nightly Rust toolchain to build.
This flake uses [rust-overlay](https://github.com/oxalica/rust-overlay) to build that toolchain.

This flake provides:

  - A `rustowl` output, which can be executed with the `cargo-owlsp` binary.
  - A `rustowl-nvim` output, with the Neovim plugin.
  - An overlay with the same packages.

> [!NOTE]
>
> PRs for packaging more editor plugins are welcome :)
