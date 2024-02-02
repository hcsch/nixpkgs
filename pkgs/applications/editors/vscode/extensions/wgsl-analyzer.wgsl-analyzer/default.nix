# Keep pkgs/by-name/wg/wgsl-analyzer/package.nix in sync with this extension

{
  vscode-utils,
  lib,
  jq,
  moreutils,
  wgsl-analyzer,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "wgsl-analyzer";
    publisher = "wgsl-analyzer";
    version = "0.8.1";
    sha256 = "sha256-ckclcxdUxhjWlPnDFVleLCWgWxUEENe0V328cjaZv+Y=";
  };

  nativeBuildInputs = [
    jq
    moreutils
  ];

  postInstall = ''
    cd "$out/$installPrefix"
    jq '.contributes.configuration.properties."wgsl-analyzer.server.path".default = "${wgsl-analyzer}/bin/wgsl_analyzer"' package.json | sponge package.json
    jq '.contributes.configuration.properties."wgsl-analyzer.diagnostics.nagaVersion".default = "0.14"' package.json | sponge package.json
  '';

  meta = {
    description = "A language server implementation for the WGSL shading language";
    homepage = "https://github.com/wgsl-analyzer/wgsl-analyzer";
    changelog = "https://marketplace.visualstudio.com/items/wgsl-analyzer.wgsl-analyzer/changelog";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ hcsch ];
  };
}
