import 'package:digger_game/component/game_popup.dart';
import 'package:digger_game/component/gui_time_component.dart';
import 'package:digger_game/frame/digger_frame.dart';
import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/block_manager_component.dart';
import 'package:digger_game/game/jump_component.dart';
import 'package:flame/components.dart';

class MoleCharacter extends JumpComponent {
  SpriteComponent? moleSpriteFront;
  SpriteComponent? moleSpriteLeft;
  SpriteComponent? moleSpriteRight;
  SpriteComponent? moleSpriteJump;
  SpriteComponent? moleSpriteDig;
  final Vector2 moleSize = Vector2(160, 160);
  BlockManagerComponent? _blockManagerComponent;
  GuITimerComponent? heightComponent;
  GuITimerComponent? powerComponent;
  GamePopup? gameSuccessPopup;
  bool _isSuccess = false;
  int power = 0;

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
    //생략
    //로드 하는 함수 안에서 opacity를 0으로 설정하여 보이지 않게 한 뒤 정면만 보이게 한다.
    moleSpriteFront?.opacity = 1;
    isFollowingCamera = true;
    hasEffect = true;

    EventBus().publish(moveCameraEvent, this);
    EventBus().subscribe(characterMoveEvent, (characterDirection));
    EventBus().subscribe(addAttackPowerEvent, (addAttackPower));

    heightComponent = GuITimerComponent();
    heightComponent?.priority = 5;
    heightComponent?.position = Vector2(500, 50);

    EventBus().publish(addViewportEvent, heightComponent!);

    powerComponent = GuITimerComponent();
    powerComponent?.priority = 5;
    powerComponent?.position = Vector2(800, 50);

    EventBus().publish(addViewportEvent, powerComponent!);
    power = 4;
  }

  @override
  void onRemove() {
    super.onRemove();
    EventBus().unsubscribe(characterMoveEvent, (characterDirection));
    EventBus().unsubscribe(addAttackPowerEvent, (addAttackPower));
    if (heightComponent != null) {
      EventBus().publish(removeViewportEvent, heightComponent!);
    }
    if (powerComponent != null) {
      EventBus().publish(removeViewportEvent, powerComponent!);
    }
    if (gameSuccessPopup != null) {
      EventBus().publish(removeViewportEvent, gameSuccessPopup!);
    }
  }

  void characterDirection(Direction direction) {
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
        digDown();
        break;
    }
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

  void setBlockManagerComponent(BlockManagerComponent? blockManagerComponent) {
    _blockManagerComponent = blockManagerComponent;
  }

  @override
  void moveLeft() {
    bool? isDestroyed = _blockManagerComponent?.hitBlock(
        Vector2(gridPosition.x + -1, gridPosition.y), power);
    if (isDestroyed == true) {
      super.moveLeft();
    }
  }

  @override
  void moveRight() {
    bool? isDestroyed = _blockManagerComponent?.hitBlock(
        Vector2(gridPosition.x + 1, gridPosition.y), power);
    if (isDestroyed == true) {
      super.moveRight();
    }
  }

  void digDown() {
    _blockManagerComponent?.hitBlock(
        Vector2(gridPosition.x, gridPosition.y + 1), power);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isSuccess) {
      return;
    }

    double? blockY = _blockManagerComponent?.getGridYPosition(
        gridPosition.x, gridPosition.y);
    if (blockY != null) {
      groundLevel = (blockY - 1) * 160;
    }
    double groundY = (position.y) / 160;
    heightComponent?.renderNumber(groundY);

    powerComponent?.renderNumber(power.toDouble());

    if (groundY >= 99.0) {
      EventBus().publish(gameSuccessEvent);
      showPopup();
    }
  }

  void addAttackPower(int addPower) {
    power += addPower;
  }

  void showPopup() {
    _isSuccess = true;
    gameSuccessPopup = GamePopup(
      priority: 10,
      buttonText: '다시하기',
      eventName: mainMenuEvent,
      imageName: 'game_success.png',
    );
    gameSuccessPopup?.position = Vector2(540, 960);
    EventBus().publish(addViewportEvent, gameSuccessPopup!);
  }
}
