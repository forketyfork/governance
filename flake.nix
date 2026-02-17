{
  description = "Governance – Federated governance framework for AI-assisted software projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      git-hooks,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in
    {
      checks = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              markdownlint-cli2 = {
                enable = true;
                name = "markdownlint-cli2";
                entry = "${pkgs.markdownlint-cli2}/bin/markdownlint-cli2";
                files = "\\.md$";
                language = "system";
              };
              prettier = {
                enable = true;
                files = "\\.md(\\.template)?$";
              };
              ls-lint = {
                enable = true;
                name = "ls-lint";
                entry = "${pkgs.ls-lint}/bin/ls_lint";
                language = "system";
                pass_filenames = false;
              };
              shellcheck.enable = true;
              shfmt.enable = true;
              check-conventions = {
                enable = true;
                name = "check-conventions";
                entry = "./scripts/check-conventions.sh";
                files = "\\.(md|sh|md\\.template)$";
                language = "system";
                pass_filenames = false;
              };
            };
          };
        }
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (self.checks.${system}.pre-commit-check) shellHook enabledPackages;
        in
        {
          default = pkgs.mkShell {
            inherit shellHook;
            buildInputs = enabledPackages ++ [ pkgs.markdownlint-cli2 ];
          };
        }
      );
    };
}
