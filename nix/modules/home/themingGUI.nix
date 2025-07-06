{ pkgs, ... }: {
  stylix = {

    image = ../../assests/background.png;

    cursor = {
      package = pkgs.banana-cursor;
      name = "banana-cursor";
      size = 24;
    };
  };
}
