{ ... }:
{
  enable = true;
  config = {
    # profile = "gpu-hq";
    # gpu-api = "vulkan";

    idle = "yes";

    volume = 90;
    volume-max = 100;

    screenshot-directory = "~/screenshots";
    screenshot-format = "png";
    screenshot-png-compression = 8;

    audio-pitch-correction = "no";

    alang  = "jpn,jp,eng,en";
    slang  = "eng,en,enUS";

    # deband = "yes";
    # deband-iterations = 2;
    # deband-threshold = 35;
    # deband-range = 20;
    # deband-grain = 5;

    # dither-depth = "auto";

    # scale = "ewa_lanczossharp";
    # dscale = "mitchell";
    # cscale = "spline36";
  };
  bindings = {
    WHEEL_UP = "ignore";
    WHEEL_DOWN = "ignore";
    MOUSE_BTN3 = "ignore";
    MOUSE_BTN4 = "ignore";
    AXIS_UP = "ignore";
    AXIS_DOWN = "ignore";
    AXIS_LEFT = "ignore";
    AXIS_RIGHT = "ignore";
  };
}
