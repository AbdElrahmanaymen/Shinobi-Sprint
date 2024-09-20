import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:shinobi_sprint/game/player.dart';

import 'world.dart';

class ShinobiSprintGame extends FlameGame with TapDetector {
  @override
  late final World world;
  late final Player player;
  late final CameraComponent cameraComponent;

  @override
  FutureOr<void> onLoad() {
    world = GameWorld();
    player = Player();

    cameraComponent = CameraComponent(world: world)
      ..viewfinder.anchor = Anchor.topCenter;

    addAll([cameraComponent, world]);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (info.eventPosition.global.x < size.x / 2) {
      player.moveLeft();
    } else {
      player.moveRight();
    }
    super.onTapDown(info);
  }
}
