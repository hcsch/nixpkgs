# Keep pkgs/development/tools/misc/texlab/default.nix in sync with this extension

{
  vscode-utils,
  lib,
  jq,
  moreutils,
  texlab,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "texlab";
    publisher = "efoerster";
    version = "5.25.1";
    hash = "sha256-bAW8dcPSM4nDiEd4hsi7Vz8l7r7xI0K53FOjXUYn/4M=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration[0].properties."texlab.server.path".default = "${lib.getExe texlab}"' package.json | sponge package.json
  '';

  meta = {
    description = "A Visual Studio Code extension that provides rich editing support for the LaTeX typesetting system powered by the TexLab language server";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=efoerster.texlab";
    homepage = "https://github.com/latex-lsp/texlab-vscode";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.hcsch ];
  };
}
