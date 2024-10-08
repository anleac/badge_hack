import 'dart:async';
import 'dart:convert';

import 'package:badge_hack/constants.dart';
import 'package:badge_hack/flame_game/components/spike.dart';
import 'package:badge_hack/flame_game/main_game.dart';
import 'package:badge_hack/flame_game/managers/sprite_manager.dart';
import 'package:badge_hack/states/nfc_global.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Blob extends SpriteComponent
    with CollisionCallbacks, HasGameReference<MainGame> {
  late int _timeSinceLastGyroEvent = DateTime.now().microsecondsSinceEpoch;

  bool _isAlive = true;
  bool get isAlive => _isAlive;

  Blob()
      : super(size: Vector2(24, 24), sprite: SpriteManager.getSprite('blob')) {
    scale = Vector2.all(3.5);
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(size: size));
    NfcGlobal.newTag = (NfcTag tag) {
      try {
        Ndef.from(tag)?.read().then((data) {
          final command = utf8.decode(data.records.first.payload).substring(3);
          if (command == "left") {
            position += Vector2(-18 * 3, 0);
          } else if (command == "right") {
            position += Vector2(18 * 3, 0);
          }
        });
      } catch (e) {
        print(e);
      }
    };
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += Vector2(0, 1) * dt * 100;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is Spike && _isAlive) {
      _isAlive = false;
      game.overlays.add(Constants.gameOverOverlayKey);
    }

    super.onCollision(points, other);
  }

  void reset() {
    _isAlive = true;
  }
}
