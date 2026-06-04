{
  lib,
  ...

}:
{
  programs.ssh = {
    settings = {
      pandemonium = lib.mkForce {
        hostname = "mahoosively.gay";
        port = 7656;
      };
      insanity = lib.mkForce {
        proxyJump = "pandemonium";
        hostname = "insanity.lab.mahoosively.gay";
        port = 22;
      };
    };
  };
}
