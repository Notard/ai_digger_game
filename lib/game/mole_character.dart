import 'package:digger_game/frame/digger_frame.dart';
import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/jump_component.dart';
import 'package:flame/components.dart';

class MoleCharacter extends JumpComponent {
  SpriteComponent? moleSpriteFront;
  SpriteComponent? moleSpriteLeft;
  SpriteComponent? moleSpriteRight;
  SpriteComponent? moleSpriteJump;
  SpriteComponent? moleSpriteDig;
  final double gridSize = 160;
  final Vector2 moleSize = Vector2(160, 160);

  @override
  void onLoad() async {
    // 두더지의 이미지를 로드한다.
    moleSpriteFront = await loadMoleSprite('mole_character_front.png');
    moleSpriteLeft = await loadMoleSprite('mole_character_left.png');
    moleSpriteRight = await loadMoleSprite('mole_character_right.png');
    moleSpriteJump = await loadMoleSprite('mole_character_jump.png');
    moleSpriteDig = await loadMoleSprite('mole_character_dig.png');
    add(moleSpriteFront!);
    add(moleSpriteLeft!);
    add(moleSpriteRight!);
    add(moleSpriteJump!);
    add(moleSpriteDig!);

    //로드 하는 함수 안에서 opacity를 0으로 설정하여 보이지 않게 한 뒤 정면만 보이게 한다.
    moleSpriteFront?.opacity = 1;
    isFollowingCamera = true;
    hasEffect = true;

    EventBus().publish(moveCameraEvent, this);
    EventBus().subscribe(characterMoveEvent, (Direction direction) {
      switch (direction) {
        case Direction.up:
          allSpriteOpacityZero();
          moleSpriteJump?.opacity = 1;
          jump();
          break;
        case Direction.left:
          allSpriteOpacityZero();
          moleSpriteLeft?.opacity = 1;
          moveLeft();
          break;
        case Direction.right:
          allSpriteOpacityZero();
          moleSpriteRight?.opacity = 1;
          moveRight();
          break;
        case Direction.down:
          allSpriteOpacityZero();
          moleSpriteDig?.opacity = 1;
          break;
      }
    });
  }

  Future<SpriteComponent> loadMoleSprite(String fileName) async {
    SpriteComponent sprite = SpriteComponent();
    sprite.sprite = await Sprite.load(fileName);
    sprite.size = moleSize;
    sprite.anchor = Anchor.topLeft;
    sprite.opacity = 0;
    add(sprite);
    return sprite;
  }

  void allSpriteOpacityZero() {
    moleSpriteFront?.opacity = 0;
    moleSpriteLeft?.opacity = 0;
    moleSpriteRight?.opacity = 0;
    moleSpriteJump?.opacity = 0;
    moleSpriteDig?.opacity = 0;
  }
}
