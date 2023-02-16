import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: GameDemo()));
  }
}

class GameDemo extends FlameGame with HasCollisionDetection {
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    await add(ScreenHitbox());
    final collidableObject = CollidableObject();
    final collidableObject2 = CollidableObject2();
    add(collidableObject2);
    add(collidableObject);
  }
}

class CollidableObject extends PositionComponent
    with CollisionCallbacks, HasGameRef<GameDemo> {
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    final hitbox = CircleHitbox(
        radius: 24,
        position: Offset(100, 200).toVector2(),
        anchor: Anchor.center)
      ..renderShape = true;
    await add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.red;
    canvas.drawCircle(const Offset(100, 200), 24.0, paint);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    position.x += dt * 30;
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is CollidableObject2) {
      final collidableObject2 = CollidableObject3(positionObj: Offset(0, 200));
      gameRef.add(collidableObject2);
    }
  }
}

class CollidableObject2 extends PositionComponent
    with CollisionCallbacks, HasGameRef<GameDemo> {
  final Offset positionObj;

  CollidableObject2({this.positionObj = const Offset(300, 200)});
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    final hitbox = CircleHitbox(
        anchor: Anchor.center, radius: 24, position: positionObj.toVector2())
      ..renderShape = true;
    await add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.orange;
    canvas.drawCircle(positionObj, 24.0, paint);
    super.render(canvas);
  }
}

class CollidableObject3 extends PositionComponent
    with CollisionCallbacks, HasGameRef<GameDemo> {
  final Offset positionObj;

  CollidableObject3({this.positionObj = const Offset(300, 200)});
  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    final hitbox = CircleHitbox(radius: 24);
    await add(hitbox);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.white;
    canvas.drawCircle(positionObj, 24.0, paint);
    super.render(canvas);
  }
}
