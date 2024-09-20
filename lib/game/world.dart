import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:shinobi_sprint/game/game.dart';

class Obstacle extends PositionComponent {
  Obstacle(Vector2 position) : super(position: position, size: Vector2(64, 64));

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = Colors.red);

    super.render(canvas);
  }
}

class Collectible extends PositionComponent {
  Collectible(Vector2 position)
      : super(position: position, size: Vector2(32, 32));

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
        Offset(size.x / 2, size.y / 2), 16, Paint()..color = Colors.yellow);
    super.render(canvas);
  }
}

class WorldPiece extends PositionComponent {
  static const pieceHeight = 640.0;
  final Color color;
  final Random random = Random();

  WorldPiece(Vector2 position, this.color)
      : super(position: position, size: Vector2(360, pieceHeight));

  @override
  void render(Canvas canvas) {
    final perspectivePoint = size.y * 0.1; // Moved up for more dramatic effect
    final roadWidth = size.x * 0.8; // Road narrows at the top

    // Draw the road (trapezoid shape)
    final roadPath = Path()
      ..moveTo(size.x / 2 - roadWidth / 2, size.y)
      ..lineTo(size.x / 2 - roadWidth / 4, perspectivePoint)
      ..lineTo(size.x / 2 + roadWidth / 4, perspectivePoint)
      ..lineTo(size.x / 2 + roadWidth / 2, size.y)
      ..close();
    canvas.drawPath(roadPath, Paint()..color = Colors.grey);

    // Draw lane markers with perspective
    final laneWidth = roadWidth / 3;
    for (int i = 1; i < 3; i++) {
      final startX = size.x / 2 - roadWidth / 2 + i * laneWidth;
      final endX = size.x / 2 - roadWidth / 4 + i * (roadWidth / 2) / 3;
      canvas.drawLine(
        Offset(startX, size.y),
        Offset(endX, perspectivePoint),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3,
      );
    }

    // Draw side buildings with enhanced perspective
    final buildingPaint = Paint()..color = Colors.blue;
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(0, size.y)
        ..lineTo(size.x * 0.1, size.y)
        ..lineTo(size.x * 0.3, perspectivePoint)
        ..close(),
      buildingPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.x, 0)
        ..lineTo(size.x, size.y)
        ..lineTo(size.x * 0.9, size.y)
        ..lineTo(size.x * 0.7, perspectivePoint)
        ..close(),
      buildingPaint,
    );

    super.render(canvas);
  }

  @override
  FutureOr<void> onLoad() {
    // for (int i = 0; i < 3; i++) {
    //   final yPos = random.nextDouble() * size.y;
    //   final scale =
    //       1 - (yPos / size.y) * 0.5; // Objects scale down with distance

    //   add(Obstacle(Vector2(random.nextDouble() * size.x, yPos))
    //     ..scale = Vector2.all(scale));
    //   add(Collectible(Vector2(random.nextDouble() * size.x, yPos))
    //     ..scale = Vector2.all(scale));
    // }
    return super.onLoad();
  }
}

class GameWorld extends World with HasGameRef<ShinobiSprintGame> {
  final List<WorldPiece> pieces = [];
  static const numPieces = 3;
  final Random random = Random();

  @override
  FutureOr<void> onLoad() {
    Color lastColor = _getRandomColor();
    for (int i = 0; i < numPieces; i++) {
      addPiece(lastColor);
      lastColor = _getNextColor(lastColor);
    }
    return super.onLoad();
  }

  void addPiece(Color color) {
    final yPos =
        pieces.isEmpty ? 0 : pieces.last.position.y - WorldPiece.pieceHeight;
    pieces.add(WorldPiece(Vector2(0, yPos.toDouble()), color));
    add(pieces.last);
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
      random.nextInt(200) + 55,
    );
  }

  Color _getNextColor(Color lastColor) {
    // Create a slightly different color from the last one
    return Color.fromARGB(
      255,
      (lastColor.red + random.nextInt(51) - 25).clamp(0, 255),
      (lastColor.green + random.nextInt(51) - 25).clamp(0, 255),
      (lastColor.blue + random.nextInt(51) - 25).clamp(0, 255),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var piece in pieces) {
      piece.position.y += 200 * dt;
    }
    if (pieces.first.position.y > game.size.y) {
      remove(pieces.first);
      pieces.removeAt(0);
      addPiece(_getNextColor(pieces.last.color));
    }
  }
}
