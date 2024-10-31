String getScriptInDustMode(int partIndex) {
  if (partIndex == 0) {
    return '''
import * as Server from '@minecraft/server';

const particles = [
''';
  } else if (partIndex == 1) {
    return '''
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
  } else {
    throw Exception();
  }
}
