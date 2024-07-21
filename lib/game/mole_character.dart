import 'package:digger_game/frame/digger_frame.dart';
import 'package:digger_game/functions/event_bus.dart';
import 'package:flame/components.dart';

class MoleCharacter extends PositionComponent {
  SpriteComponent? moleSpriteFront;
  SpriteComponent? moleSpriteLeft;
  SpriteComponent? moleSpriteRight;

  @override
  void onLoad() async {
    moleSpriteFront = await loadMoleSprite('mole_character_front.png');
    moleSpriteLeft = await loadMoleSprite('mole_character_left.png');
    moleSpriteRight = await loadMoleSprite('mole_character_right.png');
    add(moleSpriteFront!);
    add(moleSpriteLeft!);
    add(moleSpriteRight!);
    moleSpriteFront?.opacity = 1;

    EventBus().subscribe(characterMoveEvent, (Direction direction) {
      switch (direction) {
        case Direction.up:
          moleSpriteFront?.opacity = 1;
          moleSpriteLeft?.opacity = 0;
          moleSpriteRight?.opacity = 0;
          break;
        case Direction.left:
          moleSpriteFront?.opacity = 0;
          moleSpriteLeft?.opacity = 1;
          moleSpriteRight?.opacity = 0;
          break;
        case Direction.right:
          moleSpriteFront?.opacity = 0;
          moleSpriteLeft?.opacity = 0;
          moleSpriteRight?.opacity = 1;
          break;
        case Direction.down:
          moleSpriteFront?.opacity = 1;
          moleSpriteLeft?.opacity = 0;
          moleSpriteRight?.opacity = 0;
          break;
      }
    });
  }

  Future<SpriteComponent> loadMoleSprite(String fileName) async {
    SpriteComponent sprite = SpriteComponent();
    sprite.sprite = await Sprite.load(fileName);
    sprite.size = Vector2(300, 300);
    sprite.anchor = Anchor.center;
    sprite.opacity = 0;
    add(sprite);
    return sprite;
  }
}
