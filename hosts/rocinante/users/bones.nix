{
  inputs,
  ...
}:

{
  imports = [
    inputs.self.homeModules.bones
    inputs.self.homeModules.server
  ];
}
