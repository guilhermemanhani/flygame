import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:run/components/bullet_component.dart';
import 'package:run/components/enemy_component.dart';
import 'package:run/components/explosion_component.dart';

class PlayerComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  late TimerComponent bulletCreator;
  // double bulletAnglesMid = 0.0;
  // double bulletAnglesFarLeft = 0.5;
  // double bulletAnglesFarRight = -0.5;
  // double bulletAnglesLeft = 3;
  // double bulletAnglesRight = -3;

  PlayerComponent()
      : super(
          size: Vector2(50, 75),
          position: Vector2(100, 500),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    add(
      bulletCreator = TimerComponent(
        period: 0.09,
        repeat: true,
        autoStart: false,
        onTick: _createBullet,
      ),
    );
    animation = await gameRef.loadSpriteAnimation(
      'rogue_shooter/player.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(32, 39),
      ),
    );
  }

  final bulletAngles = [
    0.0,
  ];
  void _createBullet() {
    gameRef.addAll(
      bulletAngles.map(
        (angle) => BulletComponent(
          position: position + Vector2(0, -size.y / 2),
          angle: angle,
          speedCo: 500.0,
        ),
      ),
    );
  }

  void beginFire() {
    bulletCreator.timer.start();
  }

  void stopFire() {
    bulletCreator.timer.pause();
  }

  void takeHit() {
    gameRef.add(ExplosionComponent(position: position));
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is EnemyComponent) {
      other.takeHit();
    }
  }
}
