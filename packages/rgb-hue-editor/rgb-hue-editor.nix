# a mutation that initiated from https://github.com/nix-community/stylix/blob/e084d011e7ee9302aceaaf6c1fc28a9ace09e16a/modules/glance/rgb-to-hsl.nix#L4
{ lib, config, ... }:
let

  roundFloatToNearestInt =
    floatToRound:
    let
      floored_float = builtins.floor floatToRound;
      int_out = if floatToRound - floored_float < 0.5 then floored_float else builtins.ceil floatToRound;
    in
    int_out;

  colors = config.lib.stylix.colors;
  hueToRgb =
    {
      h,
      s,
      l,
    }:
    n:

    let
      # n_val = builtins.trace "Called with ${toString n}, h is: ${toString h}" n;
      a = s * lib.min l (1 - l);
      # a_debug = builtins.trace "a is ${toString a}" a;
      temp_val = n + (h / 30);
      k = if temp_val > 12.0 then lib.mod (roundFloatToNearestInt temp_val) 12 else temp_val; # WARN: This may break things
      # k_debug = builtins.trace "k is ${toString k}" k;
      f = l - (a * (lib.max (lib.min (lib.min (k - 3) (9 - k)) 1) (-1)));

    in
    f * 255.0;
  convertToHex =
    valueToHexify:
    let
      initial_value = lib.toHexString (roundFloatToNearestInt valueToHexify);
      padded_string =
        if (builtins.stringLength initial_value) == 1 then "0${initial_value}" else initial_value;
    in
    padded_string;
in
{
  hue_change,
  saturation_change,
  light_change,
}:
color:
let
  r = ((lib.toInt colors."${color}-rgb-r") * 100.0) / 255;
  g = ((lib.toInt colors."${color}-rgb-g") * 100.0) / 255;
  b = ((lib.toInt colors."${color}-rgb-b") * 100.0) / 255;
  max = lib.max r (lib.max g b);
  min = lib.min r (lib.min g b);
  delta = max - min;
  fmod = base: int: base - (int * builtins.floor (base / int));
  h =
    if delta == 0 then
      0
    else if max == r then
      60 * (fmod ((g - b) / delta) 6)
    else if max == g then
      60 * (((b - r) / delta) + 2)
    else if max == b then
      60 * (((r - g) / delta) + 4)
    else
      0;

  new_h = (h + hue_change);

  l = (((max + min) / 2));
  new_l = (l + light_change) / 100.0;
  s =
    if delta == 0 then 0 else ((100 * delta / (100 - lib.max (2 * l - 100) (100 - (2 * l)))) / 100.0);
  new_s = ((s + saturation_change) / 100.0);
  hueToRgbForOurColour =
    # builtins.trace
    #   "OLD - RGB: ${toString colors."${color}-rgb-r"}, ${toString colors."${color}-rgb-g"}, ${
    #     toString colors."${color}-rgb-b"
    #   } - HSL: ${toString h}, ${toString (s)}, ${toString (l)}"
    hueToRgb {
      h = new_h;
      s = new_s;
      l = new_l;
    };
  new-r = hueToRgbForOurColour 0;
  new-g = hueToRgbForOurColour 8;
  new-b = hueToRgbForOurColour 4;

  roundToString =
    value:
    # builtins.trace
    #   "NEW - RGB: ${toString new-r}, ${toString new-g}, ${toString new-b} - HSL: ${toString new_h}, ${toString (new_s)}, ${toString (new_l)} - HEX: ${convertToHex new_h}${convertToHex new_s}${convertToHex new_l}  "
    convertToHex value;
  # roundToString = value: lib.strings.floatToString value;
  # roundToString = value: toString (builtins.floor (value + 0.5));
in
lib.concatMapStringsSep "" roundToString [
  new-r
  new-g
  new-b
]
