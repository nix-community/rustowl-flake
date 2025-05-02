{
  self,
  inputs,
}: final: prev: {
  inherit (inputs) rust-manifest;

  rustowl = final.callPackage ./package.nix {rustowl-src = inputs.rustowl;};

  rustowl-nvim = final.vimUtils.buildVimPlugin {
    pname = "rustowl";
    version = "${((final.lib.importTOML "${inputs.rustowl}/Cargo.toml").package).version}-unstable";
    src = inputs.rustowl;
  };
}
