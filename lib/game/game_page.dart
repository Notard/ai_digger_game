import 'package:digger_game/game/grid_component.dart';
import 'package:digger_game/game/mole_character.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class GamePage extends PositionComponent {
  @override
  void onLoad() async {
    SpriteComponent background = SpriteComponent();
    background.sprite = await Sprite.load('game_background.png');
    background.position = Vector2(0, 0);
    background.size = Vector2(1080, 1920);
    background.anchor = Anchor.center;
    add(background);

    OpacityEffect fadeIn = OpacityEffect.to(
      1.0,
      EffectController(duration: 0.4),
    );
    background.add(fadeIn);
    background.priority = 1;

    MoleCharacter moleCharacter = MoleCharacter();
    moleCharacter.position = Vector2(0, 0);
    add(moleCharacter);
    moleCharacter.priority = 2;

    GridComponent gridComponent = GridComponent();
    add(gridComponent);
    gridComponent.priority = 3;
    gridComponent.anchor = Anchor.topLeft;
    add(gridComponent);
  }
}
