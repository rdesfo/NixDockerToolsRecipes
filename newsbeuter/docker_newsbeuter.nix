{ pkgs ? import <nixpkgs> {} }:

# I'm doing something wrong this repo is 185.3 MB
# if I use alpine its 35.63 MB
#
# built by running:
#   > nix-build newsbeuter.nix
#   > docker load < result

with pkgs;

dockerTools.buildImage {
  name = "rdesfo/newsbeuter";
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    groupadd -g 1000 users
    useradd -r -g users -d /home/user -u 1000 -M user
    mkdir -p /home/user
    chown user:users /home/user
  '';

  contents = [ newsbeuter ];

  config = {
    Entrypoint = [ "newsbeuter" ];
    WorkingDir = "/home/user";
    User = "user";
  };
}
