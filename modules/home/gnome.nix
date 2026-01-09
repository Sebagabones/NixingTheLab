{ config, lib, pkgs, inputs, ... }: {
  imports = [ ./dconf.nix ];
  home.packages = with pkgs; [
    gnomeExtensions.blur-my-shell
    gnomeExtensions.space-bar
    gnomeExtensions.pop-shell
    gnomeExtensions.spotify-controls
    gnomeExtensions.weather-or-not
    (gnomeExtensions.buildShellExtension {
      uuid = "notification-configurator@exposedcat";
      name = "Notification Configurator";
      pname = "notification-configurator";
      description =
        "An Ultimate Notification Configurator for GNOME: notification rate limiting, timeout, positioning, fullscreen notifications, custom colors, filtering and more features upcoming. Consider leaving a review on GNOME Extensions!";
      link =
        "https://extensions.gnome.org/extension/8249/notification-configurator/";
      version = "13";
      sha256 = "1dgjr6hkkp45qx4glk759ihvm0z3fmw5yd1ggc6wx14cb6z4dpwc";
      metadata =
        "ewogICJfZ2VuZXJhdGVkIjogIkdlbmVyYXRlZCBieSBTd2VldFRvb3RoLCBkbyBub3QgZWRpdCIsCiAgImRlc2NyaXB0aW9uIjogIkFuIFVsdGltYXRlIE5vdGlmaWNhdGlvbiBDb25maWd1cmF0b3IgZm9yIEdOT01FOiBub3RpZmljYXRpb24gcmF0ZSBsaW1pdGluZywgdGltZW91dCwgcG9zaXRpb25pbmcsIGZ1bGxzY3JlZW4gbm90aWZpY2F0aW9ucywgY3VzdG9tIGNvbG9ycywgZmlsdGVyaW5nIGFuZCBtb3JlIGZlYXR1cmVzIHVwY29taW5nLiBDb25zaWRlciBsZWF2aW5nIGEgcmV2aWV3IG9uIEdOT01FIEV4dGVuc2lvbnMhIiwKICAiZ2V0dGV4dC1kb21haW4iOiAibm90aWZpY2F0aW9uLWNvbmZpZ3VyYXRvckBleHBvc2VkY2F0IiwKICAibmFtZSI6ICJOb3RpZmljYXRpb24gQ29uZmlndXJhdG9yIiwKICAic2V0dGluZ3Mtc2NoZW1hIjogIm9yZy5nbm9tZS5zaGVsbC5leHRlbnNpb25zLm5vdGlmaWNhdGlvbi1jb25maWd1cmF0b3IiLAogICJzaGVsbC12ZXJzaW9uIjogWwogICAgIjQ2IiwKICAgICI0NyIsCiAgICAiNDgiCiAgXSwKICAidXJsIjogImh0dHBzOi8vZ2l0aHViLmNvbS9FeHBvc2VkQ2F0L2dub21lLW5vdGlmaWNhdGlvbi1jb25maWd1cmF0b3IiLAogICJ1dWlkIjogIm5vdGlmaWNhdGlvbi1jb25maWd1cmF0b3JAZXhwb3NlZGNhdCIsCiAgInZlcnNpb24iOiAxMwp9";
    })

  ];

}
