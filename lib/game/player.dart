import 'dart:async';

import 'package:flame/components.dart';
import 'package:shinobi_sprint/game/game.dart';

class Player extends SpriteComponent with HasGameRef<ShinobiSprintGame> {
  Player() : super(size: Vector2(64, 64));

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  void moveLeft() {
    // TODO: implement moveLeft
  }

  void moveRight() {
    // TODO: implement moveRight
  }
}
