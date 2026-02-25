{
  inputs,
  ...
}:

{
  imports = [
    inputs.self.homeModules.bones
    inputs.self.homeModules.gui
    inputs.self.homeModules.pc
  ];
}
