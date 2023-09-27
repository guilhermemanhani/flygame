import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:run/components/enemy_creator.dart';
import 'package:run/components/player_component.dart';
import 'package:run/components/star_background_creator.dart';

class RogueShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  static const String description = '''
    A simple space shooter game used for testing performance of the collision
    detection system in Flame.
  ''';

  late final PlayerComponent player;
  late final TextComponent componentCounter;
  late final TextComponent scoreText;
  bool nivel1 = false;
  bool nivel2 = false;
  bool nivel3 = false;

  int score = 0;

  @override
  Future<void> onLoad() async {
    add(player = PlayerComponent());
    addAll([
      FpsTextComponent(
        position: size - Vector2(0, 50),
        anchor: Anchor.bottomRight,
      ),
      scoreText = TextComponent(
        position: size - Vector2(0, 25),
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
      componentCounter = TextComponent(
        position: size,
        anchor: Anchor.bottomRight,
        priority: 1,
      ),
    ]);

    add(EnemyCreator());
    add(StarBackGroundCreator());
  }

  @override
  void update(double dt) {
    super.update(dt);
    scoreText.text = 'Score: $score';
    componentCounter.text = 'Components: ${children.length}';
  }

  @override
  void onPanStart(_) {
    player.beginFire();
  }

  @override
  void onPanEnd(_) {
    player.stopFire();
  }

  @override
  void onPanCancel() {
    player.stopFire();
  }

  @override
  void onPanUpdate(DragUpdateInfo details) {
    player.position += details.delta.game;
  }

  void increaseScore() {
    score++;
    if (score > 10 && nivel1 == false) {
      player.bulletAngles.addAll([0.1, -0.1]);
      nivel1 = true;
    }
    if (score > 20 && nivel2 == false) {
      player.bulletAngles.addAll([0.2, -0.2]);
      nivel2 = true;
    }
    if (score > 30 && nivel3 == false) {
      player.bulletAngles.addAll([0.3, -0.3]);
      nivel3 = true;
    }
  }
}
