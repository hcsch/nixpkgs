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
    version = "5.16.1";
    hash = "sha256-hlNsdD+p1JaC8b8rtBjR2cFtwWRoblF6xre4ut8TBWY=";
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
