import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:run/components/bullet_component.dart';
import 'package:run/components/explosion_component.dart';
import 'package:run/rogue_shooter_game.dart';

class EnemyComponent extends SpriteAnimationComponent
    with HasGameRef<RogueShooterGame>, CollisionCallbacks {
  late TimerComponent bulletCreator;
  static const speed = 150;
  int live = 10;
  static Vector2 initialSize = Vector2.all(25);

  EnemyComponent({required super.position})
      : super(size: initialSize, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = await gameRef.loadSpriteAnimation(
      'rogue_shooter/enemy.png',
      SpriteAnimationData.sequenced(
        stepTime: 0.2,
        amount: 4,
        textureSize: Vector2.all(16),
      ),
    );
    add(
      bulletCreator = TimerComponent(
        period: 0.5,
        repeat: true,
        autoStart: true,
        onTick: _createBullet,
      ),
    );
    add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  final bulletAngles = [
    0.0,
  ];
  void _createBullet() {
    gameRef.addAll(
      bulletAngles.map(
        (angle) => BulletComponent(
          position: position + Vector2(0, size.y / 2),
          angle: angle,
          speedCo: -300.0,
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (y >= gameRef.size.y) {
      removeFromParent();
    }
  }

  void takeHit() {
    removeFromParent();
    // live--;
    // if (live <= 0) {
    gameRef.add(ExplosionComponent(position: position));
    gameRef.increaseScore();
    // }
  }
}
