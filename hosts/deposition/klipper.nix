{ ... }:
{
  services.klipper = {
    user = "root";
    group = "root";
    enable = true;
    firmwares = {
      mcu = {
        enable = true;
        enableKlipperFlash = true;
        # Generate this config by running klipper-genconf
        # Currently broken: https://github.com/NixOS/nixpkgs/pull/200228
        # Workaround: Run nix-shell -p python3 --command klipper-genconf instead
        configFile = ./ender5.cfg;

        serial = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AB0M3TDH-if00-port0";
      };
    };
    settings = {
      printer = {
        kinematics = "cartesian";
        max_velocity = 300;
        max_accel = 2500;
        max_z_velocity = 7;
        max_z_accel = 150;
      };
      mcu = {
        serial = "/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AB0M3TDH-if00-port0";
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
        endstop_pin = "probe:z_virtual_endstop";
        position_max = 400;
        position_min = -5;
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
        z_offset = 3.250;
        speed = 3.0;
        pin_up_touch_mode_reports_triggered = false;

      };
      bed_mesh = {
        speed = 175;
        horizontal_move_z = 5;
        mesh_min = "25, 25";
        mesh_max = "300, 300";
        probe_count = "5, 5";
        algorithm = "bicubic";
        mesh_pps = "3, 3";
      };
      bed_screws = {
        screw1 = "25, 25";
        screw2 = "325, 25";
        screw3 = "325, 325";
        screw4 = "25, 325";
      };

      "delayed_gcode bed_mesh_init" = {
        initial_duration = 0.01;
        gcode = "
        BED_MESH_PROFILE LOAD=default
          ";
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
      # fluidd parts
      virtual_sdcard.path = "/var/lib/moonraker/gcodes";
      display_status = { };
      pause_resume = { };

      "gcode_macro PAUSE" = {
        description = "Pause the actual running print";
        rename_existing = "PAUSE_BASE";
        # change this if you need more or less extrusion
        variable_extrude = 1.0;
        gcode = "
          ##### read E from pause macro #####
          {% set E = printer[' gcode_macro PAUSE '].extrude|float %}
          ##### set park positon for x and y #####
          # default is your max posion from your printer.cfg
          {% set x_park = printer.toolhead.axis_maximum.x|float - 5.0 %}
          {% set y_park = printer.toolhead.axis_maximum.y|float - 5.0 %}
          ##### calculate save lift position #####
          {% set max_z = printer.toolhead.axis_maximum.z|float %}
          {% set act_z = printer.toolhead.position.z|float %}
          {% if act_z < (max_z - 2.0) %}
          {% set z_safe = 2.0 %}
          {% else %}
          {% set z_safe = max_z - act_z %}
          {% endif %}
          ##### end of definitions #####
            PAUSE_BASE
          G91
          {% if printer.extruder.can_extrude|lower == 'true' %}
          G1 E-{E} F2100
          {% else %}
          {action_respond_info(' Extruder not hot enough ')}
          {% endif %}
          {% if ' xyz ' in printer.toolhead.homed_axes %}
          G1 Z{z_safe} F900
          G90
          G1 X{x_park} Y{y_park} F6000
          {% else %}
          {action_respond_info(' Printer not homed')}
          {% endif %}
          ";
      };

      "gcode_macro RESUME" = {
        description = "Resume the actual running print";
        rename_existing = "RESUME_BASE";
        gcode = "
          ### read E from pause macro #####
          {% set E = printer[' gcode_macro PAUSE '].extrude|float %}
          #### get VELOCITY parameter if specified ####
          {% if 'VELOCITY' in params|upper %}
          {% set get_params = ('VELOCITY=' + params.VELOCITY)  %}
          {%else %}
          {% set get_params = ' ' %}
          {% endif %}
          ##### end of definitions #####
          {% if printer.extruder.can_extrude|lower == 'true' %}
          G91
          G1 E{E} F2100
          {% else %}
          {action_respond_info('
            Extruder
            not
            hot
            enough
            ')}
          {% endif %}
            RESUME_BASE {get_params}
        ";
      };
      "gcode_macro CANCEL_PRINT" = {
        description = "Cancel the actual running print";
        rename_existing = "CANCEL_PRINT_BASE";
        gcode = "
          TURN_OFF_HEATERS
          CANCEL_PRINT_BASE
        ";
      };
    };
    extraSettings = "
[bed_mesh default]
version = 1
points =
      -0.116250, -0.078750, -0.040000, -0.062500, -0.076250
      -0.141250, -0.098750, -0.041250, -0.056250, -0.061250
      -0.132500, -0.060000, -0.002500, -0.028750, -0.045000
      -0.042500, -0.012500, 0.031250, -0.005000, -0.037500
      -0.028750, 0.026250, 0.072500, 0.047500, 0.032500
x_count = 5
y_count = 5
mesh_x_pps = 3
mesh_y_pps = 3
algo = bicubic
tension = 0.2
min_x = 25.0
max_x = 300.0
min_y = 25.0
max_y = 300.0
";
  };
}
