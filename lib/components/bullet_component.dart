import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:run/components/enemy_component.dart';

class BulletComponent extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  double speed = 0.0;
  late final Vector2 velocity;
  final Vector2 deltaPosition = Vector2.zero();

  BulletComponent(
      {required super.position, required double speedCo, super.angle})
      : super(size: Vector2(10, 20)) {
    speed = speedCo;
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    animation = await gameRef.loadSpriteAnimation(
      'rogue_shooter/bullet.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2(8, 16),
      ),
    );
    velocity = Vector2(0, -1)
      ..rotate(angle)
      ..scale(speed);
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is EnemyComponent) {
      other.takeHit();
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    deltaPosition
      ..setFrom(velocity)
      ..scale(dt);
    position += deltaPosition;

    if (position.y < 0 ||
        position.x > gameRef.size.x ||
        position.x + size.x < 0 ||
        y >= gameRef.size.y) {
      removeFromParent();
    }
  }
}
