{ ... }:
{
  flake.nixosModules.greeter = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.glib ];
  };
}
