import 'package:digger_game/component/game_popup.dart';
import 'package:digger_game/component/gui_time_component.dart';
import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/block_manager_component.dart';
import 'package:digger_game/game/mole_character.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class GamePage extends PositionComponent {
  MoleCharacter? moleCharacter;
  BlockManagerComponent? blockManagerComponent;
  GuITimerComponent? timerComponent;
  SpriteComponent? timeComponent;
  SpriteComponent? guiBackground;
  GamePopup? gameOverPopup;
  SpriteComponent? gameBackground;

  double nowTime = 0.0;
  static const double startTime = 60.0;
  bool isGameOver = false;

  @override
  void onLoad() async {
    gameBackground = SpriteComponent();
    gameBackground?.sprite = await Sprite.load('game_background.png');
    gameBackground?.position = Vector2(0, 0);
    gameBackground?.size = Vector2(1080, 1920);
    gameBackground?.anchor = Anchor.center;
    add(gameBackground!);

    OpacityEffect fadeIn = OpacityEffect.to(
      1.0,
      EffectController(duration: 0.4),
    );
    gameBackground?.add(fadeIn);
    gameBackground?.priority = 1;

    moleCharacter = MoleCharacter();
    moleCharacter?.gridPosition = Vector2(0, -6);

    add(moleCharacter!);
    moleCharacter?.priority = 4;

    blockManagerComponent = BlockManagerComponent();
    blockManagerComponent?.priority = 3;
    add(blockManagerComponent!);

    moleCharacter?.setBlockManagerComponent(blockManagerComponent);

    nowTime = startTime;

    EventBus().subscribe(changeLeftTimeEvent, changeTime);

    timerComponent = GuITimerComponent();
    timerComponent?.priority = 5;
    timerComponent?.position = Vector2(200, 50);

    EventBus().publish(addViewportEvent, timerComponent!);
    timeComponent = SpriteComponent(
      sprite: await Sprite.load('time.png'),
      size: Vector2(200, 200),
      position: Vector2(0, -25),
    );
    timeComponent?.priority = 5;
    EventBus().publish(addViewportEvent, timeComponent!);

    guiBackground = SpriteComponent(
      sprite: await Sprite.load('gui_background.png'),
      size: Vector2(1080, 150),
      position: Vector2(0, 0),
    );
    guiBackground?.anchor = Anchor.topLeft;
    guiBackground?.priority = 4;
    EventBus().publish(addViewportEvent, guiBackground!);

    EventBus().subscribe(gameSuccessEvent, gameOver);
  }

  @override
  void onRemove() {
    super.onRemove();
    EventBus().unsubscribe(changeLeftTimeEvent, changeTime);
    EventBus().unsubscribe(gameSuccessEvent, gameOver);

    if (timerComponent != null) {
      EventBus().publish(removeViewportEvent, timerComponent!);
    }
    if (timeComponent != null) {
      EventBus().publish(removeViewportEvent, timeComponent!);
    }
    if (guiBackground != null) {
      EventBus().publish(removeViewportEvent, guiBackground!);
    }
    if (gameOverPopup != null) {
      EventBus().publish(removeViewportEvent, gameOverPopup!);
    }
  }

  void changeTime(double time) {
    nowTime += time;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isGameOver) {
      return;
    }
    nowTime -= dt;
    if (nowTime <= 0) {
      showPopup();
    } else {
      timerComponent?.renderNumber(nowTime);
    }
    //moleCharacter y축을 gameBackground y축으로 맞춘다.
    gameBackground?.position = Vector2(
      0,
      moleCharacter!.position.y,
    );
  }

  void showPopup() {
    isGameOver = true;
    gameOverPopup = GamePopup(
      priority: 10,
      buttonText: '다시하기',
      eventName: mainMenuEvent,
      imageName: 'game_over.png',
    );
    gameOverPopup?.position = Vector2(540, 960);
    EventBus().publish(addViewportEvent, gameOverPopup!);
  }

  void gameOver(_) {
    isGameOver = true;
  }
}
