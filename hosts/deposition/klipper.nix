{ inputs, ... }:
{
  services.klipper = {
    user = "root";
    group = "root";
    enable = true;
    # firmwares = {
    #   mcu = {
    #     enable = true;
    #     # Generate this config by running klipper-genconf
    #     # Currently broken: https://github.com/NixOS/nixpkgs/pull/200228
    #     # Workaround: Run nix-shell -p python3 --command klipper-genconf instead
    #     # configFile = ./avr.cfg;
    #     serial = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AK06VNAB-if00-port0"; # May need to change this
    #   };
    # };
    settings = {
      printer = {
        kinematics = "cartesian";
        max_velocity = 300;
        max_accel = 2500;
        max_z_velocity = 5;
        max_z_accel = 100;
      };
      mcu = {
        serial = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AK06VNAB-if00-port0"; # May need to change this
      };

      stepper_x = {
        step_pin = "PF0";
        dir_pin = "PF1";
        enable_pin = "!PD7";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PE5";
        position_endstop = 350;
        position_max = 350;
        homing_speed = 100;
      };
      stepper_y = {
        step_pin = "PF6";
        dir_pin = "PF7";
        enable_pin = "!PF2";
        microsteps = 16;
        rotation_distance = 40;
        endstop_pin = "^PJ1";
        position_endstop = 350;
        position_max = 350;
        homing_speed = 100;
      };

      stepper_z = {
        step_pin = "PL3";
        dir_pin = "PL1";
        enable_pin = "!PK0";
        microsteps = 16;
        rotation_distance = 4;
        endstop_pin = "probe;z_virtual_endstop";
        position_max = 400;
        position_min = 0;
        homing_speed = 10.0;

      };
      extruder = {
        step_pin = "PA4";
        dir_pin = "PA6";
        enable_pin = "!PA2";
        microsteps = 16;
        rotation_distance = 33.683;
        nozzle_diameter = 0.400;
        filament_diameter = 1.750;
        heater_pin = "PB4";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PK5";
        control = "pid";
        pid_Kp = 22.2;
        pid_Ki = 1.08;
        pid_Kd = 114;
        min_temp = 0;
        max_temp = 260;

      };
      heater_bed = {
        heater_pin = "PH5";
        sensor_type = "EPCOS 100K B57560G104F";
        sensor_pin = "PK6";
        control = "pid";
        pid_Kp = 690.34;
        pid_Ki = 111.47;
        pid_Kd = 1068.83;
        min_temp = 0;
        max_temp = 130;
      };

      bltouch = {
        sensor_pin = "^PD3";
        control_pin = "PB5";
        x_offset = -45;
        y_offset = 0;
        z_offset = 0;
        speed = 3.0;
        pin_up_touch_mode_reports_triggered = false;

      };
      bed_mesh = {
        speed = 100;
        horizontal_move_z = 8;
        mesh_min = "50, 50";
        mesh_max = "300, 300";
        probe_count = "3, 3";

      };
      "filament_switch_sensor filament_sensor" = {
        switch_pin = "PE4";
      };
      safe_z_home = {
        home_xy_position = "180, 180";
        speed = 100;
        z_hop = 10;
        z_hop_speed = 5;
      };
    };
  };
}
