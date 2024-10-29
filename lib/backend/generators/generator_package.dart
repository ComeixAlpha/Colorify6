import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_directory.dart';
import 'package:colorify/backend/generators/generator_particle.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class PackageArg {
  final String name;
  final String auth;
  final String desc;

  PackageArg({
    required this.name,
    required this.auth,
    required this.desc,
  });
}

Future<void> manifest(
  Directory dir,
  PackageArg args, {
  bool ebp = true,
  bool erp = true,
}) async {
  final uuid1 = const Uuid().v4();
  final uuid2 = const Uuid().v4();
  final uuid3 = const Uuid().v4();

  final uuidBP = const Uuid().v4();
  final uuidRP = const Uuid().v4();
  final bp = '''
{
  "format_version": 2,
  "header": {
    "name": "${args.name}",
    "description": "[Colorify] ${args.desc}",
    "uuid": "$uuidBP",
    "min_engine_version": [1, 19, 50],
    "version": [1, 0, 0]
  },
  "modules": [
    {
      "type": "data",
      "uuid": "$uuid1",
      "version": [1, 0, 0]
    },
    {
      "type": "script",
      "uuid": "$uuid2",
      "entry": "scripts/index.js",
      "version": [1, 0, 0]
    }
  ],
  "dependencies": [ 
    {
      "module_name": "@minecraft/server",
      "version": "1.10.0"
    }${erp ? ''',
    {
      "uuid": "$uuidRP",
      "version": "1.0.0"
    }''' : ''}
  ],
  "metadata": {
    "authors": ["${args.auth}"],
    "generated_with": {
      "colorify": ["6.0.8"]
    }
  }
}
  ''';

  final rp = '''
{
  "format_version": 2,
  "header": {
    "name": "${args.name}",
    "description": "[Colorify] ${args.desc}",
    "uuid": "$uuidRP",
    "min_engine_version": [1, 19, 50],
    "version": [1, 0, 0]
  },
  "modules": [
    {
      "type": "resources",
      "uuid": "$uuid3",
      "version": [1, 0, 0]
    }
  ],
  "dependencies": [ 
    {
      "uuid": "$uuidBP",
      "version": "1.0.0"
    }
  ],
  "metadata": {
    "authors": ["${args.auth}"],
    "generated_with": {
      "colorify": ["6.0.8"]
    }
  }
}
  ''';

  String bpManifestPath;
  if (!erp) {
    bpManifestPath = path.join(dir.path, 'manifest.json');
  } else {
    bpManifestPath = path.join(dir.path, 'behaviour_pack/manifest.json');
  }
  final rpManifestPath = path.join(dir.path, 'resources_pack/manifest.json');

  if (ebp) {
    await File(bpManifestPath).writeAsString(bp);
  }
  if (erp) {
    await File(rpManifestPath).writeAsString(rp);
  }
}

Future<void> packIcon(
  Directory dir,
  Uint8List list, {
  bool ebp = true,
  bool erp = true,
}) async {
  String bpPackIconPath;
  if (!erp) {
    bpPackIconPath = path.join(dir.path, 'pack_icon.png');
  } else {
    bpPackIconPath = path.join(dir.path, 'behaviour_pack/pack_icon.png');
  }
  final rpPackIconPath = path.join(dir.path, 'resources_pack/pack_icon.png');
  if (ebp) {
    await File(bpPackIconPath).writeAsBytes(list);
  }
  if (erp) {
    await File(rpPackIconPath).writeAsBytes(list);
  }
}

Future<void> scriptModeMatch(Directory dir, int fileCount) async {
  String runCommands = '';
  for (int i = 0; i < fileCount; i++) {
    runCommands += '\tentity.runCommand(\'function output_$i\');\n';
  }
  final script = '''
import * as Server from '@minecraft/server';

function paint(entity, tickDelay) {
  if (!entity.isValid) return;
$runCommands
  Server.system.runTimeout(() => paint(entity, tickDelay), tickDelay);
}

Server.system.runInterval(() => {
  const entities = Server.world.getDimension('overworld').getEntities();
  for (let entity of entities) {
    if (entity.nameTag.startsWith('particle:') && !entity.hasTag('particled')) {
      const tickDelay = Number(entity.nameTag.split(':')[1]);
      entity.addTag('particled');
      entity.addEffect('invisibility', 99999, { showParticles: false });
      paint(entity, tickDelay);
    }
  }
});
''';

  final scriptDir = dir.concact('scripts');
  if (!await scriptDir.exists()) {
    await scriptDir.create();
  }

  final scriptPath = path.join(scriptDir.path, 'index.js');
  await File(scriptPath).writeAsString(script);
}

Future<void> scriptModeDust(Directory dir, List<ParticlePoint> points) async {
  String particles = '';
  for (ParticlePoint point in points) {
    particles +=
        '\t{ x: ${point.x}, y: ${point.y}, z: ${point.z}, r: ${point.r! / 255}, g: ${point.g! / 255}, b: ${point.b! / 255} },\n';
  }
  final script = '''
import * as Server from '@minecraft/server';

const particles = [
$particles
];

function paint(entity, tickDelay) {
  if (!entity.isValid) return;
  for (let particle of particles) {
    const map = new Server.MolangVariableMap();
    map.setColorRGB("variable.rgb", {
        red: particle.r,
        green: particle.g,
        blue: particle.b,
    });
    entity.dimension.spawnParticle(
      "comeix:dust",
      { x: entity.location.x + particle.x, y: entity.location.y + particle.y, z: entity.location.z + particle.z },
      map
    );
  }
  Server.system.runTimeout(() => paint(entity, tickDelay), tickDelay);
}

Server.system.runInterval(() => {
  const entities = Server.world.getDimension('overworld').getEntities();
  for (let entity of entities) {
    if (entity.nameTag.startsWith('particle:') && !entity.hasTag('particled')) {
      const tickDelay = Number(entity.nameTag.split(':')[1]);
      entity.addTag('particled');
      entity.addEffect('invisibility', 99999, { showParticles: false });
      paint(entity, tickDelay);
    }
  }
});
''';

  final scriptDir = dir.concact('scripts');

  if (!await scriptDir.exists()) {
    await scriptDir.create();
  }

  final scriptPath = path.join(scriptDir.path, 'index.js');
  await File(scriptPath).writeAsString(script);
}

Future<void> scriptTickingArea(Directory dir, int fileCount, int dx, int dy, int dz) async {
  String systemRun(int i, String before) {
    if (i != fileCount - 1) {
      final s = '''
entity.runCommand('function output_$i');
Server.system.run(() => {
$before
});
''';
      if (i == 0) {
        return s;
      }
      return systemRun(i - 1, s);
    } else {
      final s = '''
entity.runCommand('function output_$i');
Server.system.run(() => {
  entity.runCommand(`tickingarea remove colorify`);
});
''';
      return systemRun(i - 1, s);
    }
  }

  for (int i = 0; i < fileCount; i++) {
    if (i == fileCount - 1) {}
  }
  final script = '''
import * as Server from "@minecraft/server";

Server.system.runInterval(() => {
  const entities = Server.world.getDimension('overworld').getEntities();
  for (let entity of entities) {
    if (entity.nameTag == 'block' && !entity.hasTag('blocked')) {
      entity.runCommand(`tickingarea add ~ ~ ~ ~${dx - 1} ~${dy - 1} ~${dz - 1} colorify`);
      entity.addTag('blocked');
      Server.system.runTimeout(() => {
${systemRun(fileCount - 1, '')}
      }, 10);
    }
  }
});
''';

  final scriptDir = dir.concact('scripts');
  if (!await scriptDir.exists()) {
    await scriptDir.create();
  }

  final scriptPath = path.join(scriptDir.path, 'index.js');
  await File(scriptPath).writeAsString(script);
}

Future<void> particleJsonModeMatch(Directory dir, List<RGBMapping> mappings) async {
  for (RGBMapping mapping in mappings) {
    final r = mapping.r == 0 ? mapping.r : (mapping.r / 255).toStringAsFixed(5);
    final g = mapping.g == 0 ? mapping.g : (mapping.g / 255).toStringAsFixed(5);
    final b = mapping.b == 0 ? mapping.b : (mapping.b / 255).toStringAsFixed(5);
    final json = '''
{
	"format_version": "1.10.0",
	"particle_effect": {
		"description": {
			"identifier": "${mapping.id}",
			"basic_render_parameters": {
				"material": "particles_blend",
				"texture": "textures/particle/particles"
			}
		},
		"components": {
			"minecraft:emitter_rate_instant": {
				"num_particles": 1
			},
			"minecraft:emitter_lifetime_once": {
				"active_time": 1
			},
			"minecraft:emitter_shape_point": {},
			"minecraft:particle_lifetime_expression": {
				"max_lifetime": 0.6
			},
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
				"color": [$r, $g, $b, 1]
			}
		}
	}
}
''';
    final jsonPath = path.join(dir.path, 'colorify.${mapping.id.replaceAll(':', '.')}.json');
    await File(jsonPath).writeAsString(json);
  }
}

Future<void> particleJsonModeDust(Directory dir) async {
  const json = '''
{
	"format_version": "1.10.0",
	"particle_effect": {
		"description": {
			"identifier": "comeix:dust",
			"basic_render_parameters": {
				"material": "particles_alpha",
				"texture": "textures/particle/particles"
			}
		},
		"components": {
			"minecraft:emitter_initialization": {
				"creation_expression": "variable.size = math.random(0.13, 0.25);variable.radius = 0.6;variable.rgb;"
			},
			"minecraft:emitter_local_space": {
				"position": true,
				"rotation": true
			},
			"minecraft:emitter_rate_instant": {
				"num_particles": 1
			},
			"minecraft:emitter_lifetime_once": {
				"active_time": 1
			},
			"minecraft:emitter_shape_point": {},
			"minecraft:particle_lifetime_expression": {
				"max_lifetime": "math.random(2, 4)"
			},
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
}
''';
  final jsonPath = path.join(dir.path, 'colorify.dust.json');
  await File(jsonPath).writeAsString(json);
}

Future<void> pack(Directory targetDir, Directory outDir, {String suffix = 'mcaddon'}) async {
  final encoder = ZipFileEncoder();
  await encoder.zipDirectoryAsync(targetDir, filename: path.join(outDir.path, 'colorified.$suffix'));
}
