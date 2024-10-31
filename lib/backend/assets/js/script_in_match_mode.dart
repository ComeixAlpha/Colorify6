
String getScriptInMatchMode(String runCommands) {
  return '''
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
}