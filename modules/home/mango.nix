{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  terminal = lib.getExe config.programs.foot.package;
  firefox = lib.getExe config.programs.firefox.package;
in
{
  imports = [
    inputs.noctalia.homeModules.default
    inputs.mangowm.hmModules.mango
  ];
  programs.bemenu.enable = false;
  home.file.".face".source = ../../assests/Parrot.png; # https://www.pexels.com/photo/red-blue-and-green-bird-on-tree-1331819/
  wayland.windowManager.mango =
    let
      lock-screen = pkgs.writeShellScript "lock-screen.sh" ''
        systemctl suspend
      '';
    in
    # TODO: Sometime look into Axis Bindings with mouse
    {
      enable = true;
      autostart_sh = ''
        env QT_QPA_PLATFORMTHEME=qt6ct noctalia-shell &
        wlr-randr --output eDP-1 --scale 1.25 &
        # echo "Xft.dpi: 140" | xrdb -merge &
        # gsettings set org.gnome.desktop.interface text-scaling-factor 1.4 &
      '';
      topPrefixes = [ "exec-once" ];
      # extraConfig = "exec-once=${pkgs.swaybg}/bin/swaybg -c 11111b ";
      extraConfig = ''
        exec-once=${pkgs.swaybg}/bin/swaybg -c ${config.lib.stylix.colors.base00}
        exec-once=noctalia
      '';

      settings = {
        env = [
          # "BEMENU_SCALE,2.5"
        ];
        blur = 1;
        blur_layer = 0;
        blur_optimized = 1;
        blur_params = {
          num_passes = 2;
          radius = 5;
          noise = 0.02;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.0;
        };
        layer_animations = 0;
        border_radius = 10;
        focused_opacity = 0.95;
        unfocused_opacity = 0.6;
        shadows = 1;
        layer_shadows = 0;
        shadow_only_floating = 0;
        shadows_size = 4;
        shadows_blur = 12;
        shadows_position_x = 2;
        shadows_position_y = 2;
        shadowscolor = "0x000000ff";
        borderpx = 0;
        tag_num = 10;
        # Animations - use underscores for multi-part keys
        animations = 1;
        animation_type_open = "zoom";
        animation_type_close = "zoom";
        animation_duration_open = 350;
        animation_duration_close = 300;
        trackpad_natural_scrolling = 1;
        mouse_accel_profile = 2;
        mouse_accel_speed = 0.5;
        # Or use nested attrs (will be flattened with underscores)
        animation_curve = {
          open = "0.46,1.0,0.29,1";
          close = "0.08,0.92,0,1";
        };
        windowrule = [
          "tags:3,appid:emacs"
          "tags:2,appid:firefox"
          "tags:4,appid:spotify"
          "tags:5,appid:discord"
        ];
        tagrule = [
          "id:1,layout_name:dwindle"
          "id:2,layout_name:dwindle"
          "id:3,layout_name:dwindle"
          "id:4,layout_name:dwindle"
          "id:5,layout_name:dwindle"
          "id:6,layout_name:dwindle"
          "id:7,layout_name:dwindle"
          "id:8,layout_name:dwindle"
          "id:9,layout_name:vertical_scroller"
          "id:10,layout_name:scroller"
        ];

        switchbind = [
          # "HandleLidSwitch=ignore"
          "fold,spawn,${lock-screen}"
          # "unfold,spawn,${unlock-screen}"
        ];

        # circle_layout = "dwindle,monocle,floating";

        bind = [
          #"SUPER,d,spawn,bemenu-run -w -i -l 10 --counter always -w  --scrollbar always -P '|>' --prompt 'launch:' --fb '#2F3549' --ff '#CBCCD1' --nb '#1a1b2a' --nf '#CBCCD1' --tb '#1a1b2a' --hb '#11121d' --tf '#7DCFFF' --hf '#BB9AF7' --af '#CBCCD1' --ab '#2F3549' --scb '#1a1b2a' --scf '#7199EE' "
          "SUPER,Return,spawn,${terminal}"
          "SUPER,w,spawn,${firefox}"

          "ALT,R,setkeymode,resize" # Enter resize mode

          "SUPER+SHIFT,space,togglefloating"
          "SUPER+SHIFT,f,togglemaximizescreen"
          "SUPER,tab,focusstack"
          "SUPER,q,killclient"
          "SUPER+SHIFT,r,reload_config"
          "SUPER,l,spawn,${lock-screen}"
          "SUPER+SHIFT,l,quit"

          "SUPER,Left,focusdir,left"
          "SUPER,Down,focusdir,down"
          "SUPER,Up,focusdir,up"
          "SUPER,Right,focusdir,right"

          "SUPER+SHIFT,Left,exchange_client,left"
          "SUPER+SHIFT,Down,exchange_client,down"
          "SUPER+SHIFT,Up,exchange_client,up"
          "SUPER+SHIFT,Right,exchange_client,right"

          "SUPER,1,view,1"
          "SUPER,2,view,2"
          "SUPER,3,view,3"
          "SUPER,4,view,4"
          "SUPER,5,view,5"
          "SUPER,6,view,6"
          "SUPER,7,view,7"
          "SUPER,8,view,8"
          "SUPER,9,view,9"
          "SUPER,0,view,10"

          "SUPER+SHIFT,1,tag,1"
          "SUPER+SHIFT,2,tag,2"
          "SUPER+SHIFT,3,tag,3"
          "SUPER+SHIFT,4,tag,4"
          "SUPER+SHIFT,5,tag,5"
          "SUPER+SHIFT,6,tag,6"
          "SUPER+SHIFT,7,tag,7"
          "SUPER+SHIFT,8,tag,8"
          "SUPER+SHIFT,9,tag,9"
          "SUPER+SHIFT,0,tag,10"

          # noctalia
          "SUPER,d,spawn,noctalia msg panel-toggle launcher"
          "SUPER,s,spawn,noctalia msg panel-toggle control-center"
          "SUPER,comma,spawn,noctalia msg settings-toggle"
          "SUPER+SHIFT,e,spawn,noctalia msg panel-toggle session"

          # Media keys
          "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
          "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
          "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
          "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
          "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"
          "NONE,Print,spawn_shell,wayfreeze --hide-cursor & PID=$!; sleep 0.1; grim -g \"$(slurp)\" /tmp/shot.png; kill \"$PID\"; swappy -f /tmp/shot.png"

          "SUPER,Print,spawn,noctalia msg plugin alexander/screen-toolkit:service all toggle"
          # "NONE,Print,spawn,noctalia-shell ipc call plugin:screen-toolkit annotate"
          # "SUPER,Print,spawn,noctalia-shell ipc call plugin:screen-toolkit toggle"

        ];

        mousebind = [
          "SUPER,btn_left,moveresize,curmove"
          "SUPER,btn_right,moveresize,curresize"
        ];

        # Keymodes (submaps) for modal keybindings
        keymode = {
          resize = {
            bind = [
              "NONE,Left,resizewin,-10,0"
              "NONE,Escape,setkeymode,default"
            ];
          };
        };
      };
    };
  programs.noctalia = {
    enable = true;
    systemd.enable = false;

    settings = {
      accessibility = {
        high_contrast = false;
        ui_scale = 1;
      };
      audio = {
        enable_overdrive = false;
        enable_sounds = false;
        notification_sound = "";
        sound_volume = 0.5;
        volume_change_sound = "";
      };
      backdrop = {
        blur_intensity = 0.5;
        enabled = false;
        tint_intensity = 0.30000001192092896;
      };
      bar = {
        order = [
          "default"
        ];
        default = {
          auto_hide = false;
          background_opacity = 1.0;
          border = "outline";
          border_width = 0;
          capsule = false;
          capsule_fill = "surface_variant";
          capsule_opacity = 1;
          capsule_padding = 6;
          capsule_thickness = 0.7599999904632568;
          center = [
            "weather"
            "spacer_2"
            "clock"
          ];
          concave_edge_corners = true;
          contact_shadow = false;
          enabled = true;
          end = [
            "tray"
            "spacer_3"
            "group:g3"
            "group:g2"
            "group:g1"
            "battery"
            "control-center"
            "session"
          ];
          font_family = "Berkeley Mono";
          font_scale = 1;
          font_weight = 500;
          hover_highlight = true;
          layer = "top";
          margin_edge = 0;
          margin_ends = 0;
          margin_opposite_edge = 0;
          padding = 14;
          panel_overlap = 1;
          position = "top";
          radius = 12;
          radius_bottom_left = 12;
          radius_bottom_right = 12;
          radius_top_left = 12;
          radius_top_right = 12;
          reserve_space = true;
          scale = 1;
          shadow = true;
          show_on_workspace_switch = true;
          smart_auto_hide = false;
          start = [
            "workspaces"
            "media"
            "audio_visualizer"
          ];
          thickness = 34;
          widget_spacing = 6;
          capsule_group = [
            {
              accordion = true;
              accordion_direction = "end";
              enabled = true;
              fill = "surface_variant";
              id = "g1";
              members = [
                "network"
                "bluetooth"
                "volume"
                "brightness"
              ];
              opacity = 1;
              padding = 6;
            }
            {
              accordion = false;
              accordion_direction = "end";
              enabled = true;
              fill = "surface_variant";
              id = "g2";
              members = [
                "notifications"
                "clipboard"
              ];
              opacity = 1;
              padding = 6;
            }
            {
              accordion = false;
              accordion_direction = "end";
              enabled = true;
              fill = "surface_variant";
              id = "g3";
              members = [
                "sysmon"
                "ram"
                "cpu"
              ];
              opacity = 1;
              padding = 6;
            }
          ];
          dead_zone = {
          };
        };
      };
      battery = {
        warning_threshold = 20;
      };
      brightness = {
        enable_ddcutil = false;
        ignore_mmids = [
        ];
        minimum_brightness = 0;
        sync_all_monitors = false;
      };
      calendar = {
        enabled = true;
        event_date_format = "%A %e %B";
        event_time_format = "%H:%M";
        refresh_minutes = 15;
      };
      control_center = {
        hidden_tabs = [

        ];
        show_session_button = true;
        show_shortcut_labels = true;
        sidebar = "compact";
        sidebar_section = "none";
        width = 700;
        shortcuts = [
          {
            type = "wifi";
          }
          {
            type = "bluetooth";
          }
          {
            type = "caffeine";
          }
          {
            type = "nightlight";
          }
          {
            type = "notification";
          }
          {
            type = "power_profile";
          }
        ];
        calendar = {
          show_events_card = true;
          show_week_numbers = true;
        };
      };
      desktop_widgets = {
        enabled = true;
        schema_version = 2;
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
      };
      dock = {
        active_monitor_only = false;
        active_opacity = 1;
        active_scale = 1;
        auto_hide = false;
        background_opacity = 1.0;
        border = "outline";
        border_width = 0;
        concave_edge_corners = true;
        cross_axis_padding = 8;
        enabled = false;
        icon_size = 48;
        inactive_opacity = 0.8500000238418579;
        inactive_scale = 0.8500000238418579;
        item_spacing = 6;
        launcher_custom_image = "";
        launcher_custom_image_colorize = false;
        launcher_icon = "grid-dots";
        launcher_position = "none";
        layer = "top";
        magnification = true;
        magnification_scale = 1.4500000476837158;
        main_axis_padding = 16;
        margin_edge = 0;
        margin_ends = 0;
        monitors = [

        ];
        pinned = [

        ];
        position = "bottom";
        radius = 16;
        radius_bottom_left = 16;
        radius_bottom_right = 16;
        radius_top_left = 16;
        radius_top_right = 16;
        reserve_space = true;
        shadow = false;
        show_dots = false;
        show_instance_count = true;
        show_running = true;
        smart_auto_hide = false;
      };
      hooks = {
        battery_charging = [

        ];
        battery_discharging = [

        ];
        battery_percentage_changed = [

        ];
        battery_plugged = [

        ];
        bluetooth_disabled = [

        ];
        bluetooth_enabled = [

        ];
        colors_changed = [

        ];
        logging_out = [

        ];
        power_profile_changed = [

        ];
        rebooting = [

        ];
        session_locked = [

        ];
        session_unlocked = [

        ];
        shutting_down = [

        ];
        started = [

        ];
        theme_mode_changed = [

        ];
        wallpaper_changed = [

        ];
        wifi_disabled = [

        ];
        wifi_enabled = [

        ];
      };
      hot_corners = {
        delay_ms = 0;
        enabled = false;
        bottom_left = {
          action = "none";
          command = "";
        };
        bottom_right = {
          action = "none";
          command = "";
        };
        top_left = {
          action = "none";
          command = "";
        };
        top_right = {
          action = "none";
          command = "";
        };
      };
      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        pre_action_fade_seconds = 2;
        behavior = {
          lock = {
            action = "lock";
            command = "";
            enabled = false;
            locked_timeout = 0;
            resume_command = "";
            timeout = 600;
          };
          lock-and-suspend = {
            action = "lock_and_suspend";
            command = "";
            enabled = false;
            locked_timeout = 0;
            resume_command = "";
            timeout = 900;
          };
          screen-off = {
            action = "screen_off";
            command = "";
            enabled = false;
            locked_timeout = 0;
            resume_command = "";
            timeout = 660;
          };
        };
      };
      keybinds = {
        cancel = [
          "Escape"
        ];
        copy = [
          "Ctrl+c"
        ];
        delete = [
          "Delete"
        ];
        down = [
          "Down"
        ];
        left = [
          "Left"
        ];
        right = [
          "Right"
        ];
        save = [
          "Ctrl+s"
        ];
        tab_next = [
          "Tab"
        ];
        tab_previous = [
          "Shift+ISO_Left_Tab"
        ];
        up = [
          "Up"
        ];
        validate = [
          "Return"
          "KP_Enter"
          "space"
        ];
      };
      location = {
        address = "Perth, Australia";
        auto_locate = false;
        custom_schedule = false;
        sunrise = "";
        sunset = "";
      };
      lockscreen = {
        allow_empty_password = false;
        blur_intensity = 0.5;
        blurred_desktop = false;
        enabled = true;
        fingerprint = false;
        lock_before_suspend = true;
        monitors = [

        ];
        tint_intensity = 0.30000001192092896;
        wallpaper = "";
      };
      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@HDMI-A-1"
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@HDMI-A-1" = {
            box_height = 196;
            box_width = 810;
            cx = 960;
            cy = 1018;
            enabled = true;
            output = "HDMI-A-1";
            placement_height = 1200;
            placement_width = 1920;
            rotation = 0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12;
              center_password_text = false;
              input_opacity = 1;
              input_radius = 6;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          "lockscreen-login-box@eDP-1" = {
            box_height = 196;
            box_width = 720;
            cx = 819.2000122070312;
            cy = 928.7999877929688;
            enabled = true;
            output = "eDP-1";
            placement_height = 1280;
            placement_width = 2048;
            rotation = 0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12;
              center_password_text = false;
              input_opacity = 1;
              input_radius = 6;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          lockscreen-widget-0000000000000001 = {
            box_height = 64;
            box_width = 192;
            cx = 1100.800048828125;
            cy = 132.8000030517578;
            enabled = true;
            output = "eDP-1";
            placement_height = 1280;
            placement_width = 2048;
            rotation = 0;
            type = "weather";
            settings = {
            };
          };
          lockscreen-widget-0000000000000002 = {
            box_height = 64;
            box_width = 192;
            cx = 537.6000366210938;
            cy = 132.8000030517578;
            enabled = true;
            output = "eDP-1";
            placement_height = 1280;
            placement_width = 2048;
            rotation = 0;
            type = "clock";
            settings = {
            };
          };
        };
      };
      nightlight = {
        enabled = false;
        force = false;
        temperature_day = 6500;
        temperature_night = 4000;
      };
      notification = {
        background_opacity = 1.0;
        border = true;
        collapse_on_dismiss = true;
        enable_daemon = true;
        history_retention_hours = 0;
        layer = "top";
        max_visible = 0;
        monitors = [

        ];
        offset_x = 20;
        offset_y = 8;
        position = "top_right";
        scale = 1;
        show_actions = true;
        show_app_name = true;
      };
      osd = {
        background_opacity = 1.0;
        border = true;
        enabled = true;
        monitors = [

        ];
        offset_x = 20;
        offset_y = 8;
        orientation = "horizontal";
        position = "top_center";
        position_vertical = "top_center";
        scale = 1;
        kinds = {
          bluetooth = true;
          brightness = true;
          caffeine = true;
          dnd = true;
          keyboard_backlight = true;
          keyboard_layout = true;
          lock_keys = true;
          media = true;
          nightlight = true;
          power_profile = true;
          privacy = true;
          volume = true;
          volume_input = true;
          volume_output = true;
          wifi = true;
        };
      };
      plugin_settings = {
      };
      plugins = {
        auto_update = "all";
        enabled = [
          "noctalia/screen_recorder"
        ];
        source = [
          {
            enabled = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            name = "official";
          }
          {
            enabled = true;
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            name = "community";
          }
        ];
      };
      shell = {
        app_icon_colorize = false;
        avatar_path = "/home/bones/.face.png";
        button_borders = true;
        card_borders = true;
        clipboard_auto_paste = "auto";
        clipboard_confirm_clear_history = true;
        clipboard_enabled = true;
        clipboard_history_max_entries = 100;
        clipboard_image_action_command = "";
        clipboard_keep_from_closed_apps = true;
        corner_radius_scale = 1;
        date_format = "%A, %x";
        disable_mipmaps = false;
        external_ip_enabled = true;
        font_family = "Berkeley Mono";
        input_borders = true;
        launch_apps_as_systemd_services = false;
        launch_apps_custom_command = "";
        niri_overview_type_to_launch_enabled = false;
        offline_mode = false;
        password_style = "random";
        polkit_agent = true;
        popup_borders = true;
        popup_shadows = true;
        screen_time_enabled = true;
        settings_show_advanced = true;
        settings_window_translucent = false;
        setup_wizard_enabled = true;
        shared_gl_context = true;
        show_location = true;
        telemetry_enabled = true;
        time_format = "{:%H:%M}";
        animation = {
          enabled = true;
          speed = 1;
        };
        greeter_sync = {
          auto_sync = true;
        };
        keyboard_layout = {
        };
        launcher = {
          app_grid = false;
          auto_paste = "auto";
          categories = true;
          compact = false;
          fetch_exchange_rates = true;
          pinned = [

          ];
          provider_prefix = "/";
          show_app_actions = false;
          show_app_origin_indicator = true;
          show_icons = false;
          sort_by_usage = true;
          dmenu = {
          };
        };
        mpris = {
          blacklist = [

          ];
        };
        panel = {
          borders = true;
          clipboard_placement = "floating";
          clipboard_position = "center";
          control_center_placement = "attached";
          control_center_position = "auto";
          floating_layer = "overlay";
          floating_offset = 8;
          launcher_placement = "floating";
          launcher_position = "center";
          list_item_background = false;
          open_near_click_clipboard = false;
          open_near_click_control_center = true;
          open_near_click_launcher = false;
          open_near_click_session = false;
          open_near_click_wallpaper = false;
          polkit_placement = "attached";
          polkit_position = "center";
          session_placement = "floating";
          session_position = "auto";
          shadow = true;
          transparency_mode = "solid";
          wallpaper_placement = "attached";
          wallpaper_position = "auto";
        };
        privacy = {
          cam_filter_regex = "";
          mic_filter_regex = "";
          screen_filter_regex = "";
        };
        screen_corners = {
          enabled = true;
          size = 32;
        };
        screenshot = {
          confirm_region = true;
          copy_to_clipboard = true;
          directory = "";
          filename_pattern = "";
          freeze_screen = true;
          pipe_command = "";
          pipe_to_command = false;
          remember_last_region = false;
          save_to_file = true;
          show_cursor = false;
        };
        session = {
          grid = false;
          grid_columns = 3;
          show_shortcuts = true;
          actions = [
            {
              action = "lock";
              command = "";
              countdown_seconds = 0;
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "1";
              variant = "default";
            }
            {
              action = "logout";
              command = "";
              countdown_seconds = 0;
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "2";
              variant = "default";
            }
            {
              action = "lock_and_suspend";
              command = "";
              countdown_seconds = 0;
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "3";
              variant = "default";
            }
            {
              action = "reboot";
              command = "";
              countdown_seconds = 0;
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "4";
              variant = "default";
            }
            {
              action = "shutdown";
              command = "";
              countdown_seconds = 0;
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "5";
              variant = "destructive";
            }
          ];
          power = {
          };
        };
        shadow = {
          alpha = 0.550000011920929;
          direction = "down";
        };
        window_switcher = {
          mru = false;
        };
      };
      storage = {
        key_file = "";
        key_source = "secret-service";
      };
      system = {
        monitor = {
          cpu_freq_activity_threshold = 2.5;
          cpu_freq_critical_threshold = 4.5;
          cpu_poll_seconds = 2;
          cpu_temp_activity_threshold = 60;
          cpu_temp_critical_threshold = 85;
          cpu_temp_sensor_path = "";
          cpu_usage_activity_threshold = 50;
          cpu_usage_critical_threshold = 90;
          disk_free_activity_threshold = 80;
          disk_free_critical_threshold = 95;
          disk_free_pct_activity_threshold = 80;
          disk_free_pct_critical_threshold = 95;
          disk_poll_seconds = 10;
          disk_used_activity_threshold = 80;
          disk_used_critical_threshold = 95;
          disk_used_pct_activity_threshold = 80;
          disk_used_pct_critical_threshold = 95;
          enabled = true;
          gpu_poll_seconds = 5;
          gpu_temp_activity_threshold = 60;
          gpu_temp_critical_threshold = 85;
          gpu_usage_activity_threshold = 50;
          gpu_usage_critical_threshold = 95;
          gpu_vram_activity_threshold = 50;
          gpu_vram_critical_threshold = 90;
          memory_poll_seconds = 2;
          net_rx_activity_threshold = 1;
          net_rx_critical_threshold = 50;
          net_tx_activity_threshold = 1;
          net_tx_critical_threshold = 50;
          network_poll_seconds = 3;
          ram_pct_activity_threshold = 60;
          ram_pct_critical_threshold = 90;
          swap_pct_activity_threshold = 20;
          swap_pct_critical_threshold = 80;
        };
      };
      theme = {
        builtin = "Catppuccin";
        community_palette = "Tokyo Night Moon";
        custom_palette = "stylix";
        mode = "dark";
        pure_black_dark = false;
        shell_mode = "follow";
        source = "custom";
        wallpaper_scheme = "m3-content";
        templates = {
          builtin_ids = [
            "foot"
            "mango"
          ];
          community_ids = [
            "spicetify"
            "fastfetch"
          ];
          enable_builtin_templates = true;
          enable_community_templates = true;
        };
      };
      wallpaper = {
        directory = "";
        directory_dark = "";
        directory_light = "";
        edge_smoothness = 0.30000001192092896;
        enabled = true;
        fill_color = "";
        fill_mode = "crop";
        per_monitor_directories = false;
        transition = [
          "honeycomb"
        ];
        transition_duration = 1500;
        transition_on_startup = true;
        automation = {
          enabled = false;
          interval_seconds = 1800;
          order = "random";
          recursive = true;
        };
      };
      weather = {
        effects = true;
        enabled = true;
        refresh_minutes = 15;
        unit = "metric";
      };
      widget = {
        active_window = {
          icon_size = 14;
          max_length = 260;
          min_length = 80;
          title_scroll = "none";
          type = "active_window";
        };
        audio_visualizer = {
          bands = 64;
          centered = false;
          color_1 = "secondary";
          mirrored = false;
          type = "audio_visualizer";
          width = 118;
        };
        cat = {
          cat_color = "on_surface";
          cat_color_mode = "custom";
          type = "dotnetrob/cat:cat";
        };
        clock = {
          format = "{:%FT%H:%M}";
          tooltip_format = "%s";
          type = "clock";
        };
        cpu = {
          highlight_color = "secondary";
          stat = "cpu_temp";
          type = "sysmon";
        };
        date = {
          format = "{:%a %d %b}";
          type = "clock";
        };
        input_volume = {
          device = "input";
          type = "volume";
        };
        keyboard_layout = {
          hide_when_single_layout = false;
          type = "keyboard_layout";
        };
        lock_keys = {
          display = "short";
          hide_when_off = false;
          show_caps_lock = true;
          show_num_lock = true;
          show_scroll_lock = false;
          type = "lock_keys";
        };
        media = {
          art_size = 16;
          hide_album_art = true;
          hide_when_no_media = true;
          max_length = 220;
          min_length = 80;
          title_scroll = "on_hover";
          type = "media";
        };
        network_rx = {
          stat = "net_rx";
          type = "sysmon";
        };
        network_tx = {
          stat = "net_tx";
          type = "sysmon";
        };
        output_volume = {
          device = "output";
          type = "volume";
        };
        ram = {
          highlight_color = "secondary";
          stat = "ram_used";
          type = "sysmon";
        };
        spacer = {
          interactive = false;
          type = "spacer";
        };
        spacer_2 = {
          type = "spacer";
        };
        spacer_3 = {
          length = 1;
          type = "spacer";
        };
        sysmon = {
          highlight_color = "secondary";
          type = "sysmon";
        };
        temp = {
          stat = "cpu_temp";
          type = "sysmon";
        };
      };
    };
  };

  home.packages = with pkgs; [
    grim
    slurp
    hyprpicker
    wl-clipboard
    tesseract
    imagemagick
    zbar
    curl
    translate-shell
    wl-screenrec
    ffmpeg
    gifski
    jq
    python3Packages.pygobject3
    xdg-desktop-portal
    evtest
    gcr
    wayland-logout
    swappy # For screenshot
    wayfreeze

    # dpms-off
    # perSystem.self.wlr-dpms
  ];
}
