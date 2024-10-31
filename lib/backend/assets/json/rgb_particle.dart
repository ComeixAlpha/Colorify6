final rgbparticle = {
  "format_version": "1.10.0",
  "particle_effect": {
    "description": {
      "identifier": "",
      "basic_render_parameters": {"material": "particles_blend", "texture": "textures/particle/particles"}
    },
    "components": {
      "minecraft:emitter_rate_instant": {"num_particles": 1},
      "minecraft:emitter_lifetime_once": {"active_time": 1},
      "minecraft:emitter_shape_point": {},
      "minecraft:particle_lifetime_expression": {"max_lifetime": 0.6},
      "minecraft:particle_initial_speed": 0,
      "minecraft:particle_motion_dynamic": {},
      "minecraft:particle_appearance_billboard": {
        "size": [0.1, 0.1],
        "facing_camera_mode": "lookat_xyz",
        "uv": {
          "texture_width": 128,
          "texture_height": 128,
          "uv": [56, 88],
          "uv_size": [8, 8]
        }
      },
      "minecraft:particle_appearance_tinting": {
        "color": [0, 0, 0, 1]
      }
    }
  }
};
