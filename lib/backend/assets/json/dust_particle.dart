const dustparticle = {
  "format_version": "1.10.0",
  "particle_effect": {
    "description": {
      "identifier": "comeix:dust",
      "basic_render_parameters": {"material": "particles_alpha", "texture": "textures/particle/particles"}
    },
    "components": {
      "minecraft:emitter_initialization": {
        "creation_expression": "variable.size = math.random(0.13, 0.25);variable.radius = 0.6;variable.rgb;"
      },
      "minecraft:emitter_local_space": {"position": true, "rotation": true},
      "minecraft:emitter_rate_instant": {"num_particles": 1},
      "minecraft:emitter_lifetime_once": {"active_time": 1},
      "minecraft:emitter_shape_point": {},
      "minecraft:particle_lifetime_expression": {"max_lifetime": "math.random(2, 4)"},
      "minecraft:particle_initial_speed": 0.15,
      "minecraft:particle_appearance_billboard": {
        "size": ["variable.size*(1-variable.particle_age)", "variable.size*(1-variable.particle_age)"],
        "facing_camera_mode": "rotate_xyz",
        "uv": {
          "texture_width": 128,
          "texture_height": 128,
          "flipbook": {
            "base_UV": ["Math.random(-1, 1) > 0 ? 56 : 48", 0],
            "size_UV": [8, 8],
            "step_UV": [-8, 0],
            "frames_per_second": 8,
            "stretch_to_lifetime": true
          }
        }
      },
      "minecraft:particle_appearance_tinting": {
        "color": ["variable.rgb.r", "variable.rgb.g", "variable.rgb.b", 0.5]
      }
    }
  }
};
