import 'package:digger_game/component/paint_text_component.dart';
import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/functions/game_function.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class TitlePage extends PositionComponent {
  @override
  void onLoad() async {
    SpriteComponent title =
        SpriteComponent(sprite: await Sprite.load('digger_game_title.png'));
    title.position = Vector2(0, 0);
    title.anchor = Anchor.center;
    title.size = Vector2(1080, 1920);
    add(title);

    PaintTextComponent startText = PaintTextComponent(
      text: '땅파기 게임',
      position: Vector2(0, -200),
      style: GameFunction().getTextStyle(
        fontSize: 120,
        color: Colors.indigo,
      ),
    );
    startText.anchor = Anchor.center;
    add(startText);

    title.opacity = 0;
    startText.opacity = 0;

    setFadeEffect(title);
    setFadeEffect(startText);

    // GameRectButton startButton = GameRectButton(
    //   spriteFileName: 'white_button.png',
    //   buttonSize: Vector2(540, 200),
    //   textComponent: TextComponent(
    //     text: '시작하기',
    //     anchor: Anchor.center,
    //     textRenderer: TextPaint(
    //       style: GameFunction().getTextStyle(
    //         fontSize: 60,
    //         color: Colors.white,
    //       ),
    //     ),
    //   ),
    //   onTapDownEvent: () {
    //     EventBus().publish(changeCamera, CameraType.map);
    //   },
    // );
    // startButton.position = Vector2(0, 600);
    // startButton.anchor = Anchor.center;
    // add(startButton);

    // Sprite startButtonSprite = await Sprite.load('white_button.png');

    // NineTileBoxComponent startButton = NineTileBoxComponent(
    //   size: Vector2(540, 200),
    //   nineTileBox: NineTileBox(startButtonSprite),
    // );
    // startButton.position = Vector2(0, 600);
    // startButton.anchor = Anchor.center;
    // add(startButton);

    // PaintTextComponent startGame = PaintTextComponent(
    //   text: '게임 시작',
    //   position: Vector2(540 / 4, 50),
    //   style: const TextStyle(
    //     color: Colors.black,
    //     fontWeight: FontWeight.bold,
    //     fontSize: 90,
    //     fontFamily: '온글잎 은별',
    //     shadows: [
    //       Shadow(
    //         color: Colors.grey,
    //         offset: Offset(2, 2),
    //         blurRadius: 10,
    //       ),
    //     ],
    //   ),
    // );
    // startGame.anchor = Anchor.center;
    // startButton.add(startGame);
  }

  void setFadeEffect(PositionComponent component) {
    OpacityEffect fadeIn = OpacityEffect.to(
      1.0,
      EffectController(duration: 0.4),
    );

    OpacityEffect fadeOut = OpacityEffect.to(
      0.0,
      DelayedEffectController(
        delay: 0.1,
        EffectController(duration: 0.4),
      ),
    );
    SequenceEffect fadeInOutSequence = SequenceEffect([fadeIn, fadeOut]);
    component.add(fadeInOutSequence);

    fadeOut.onComplete = () {
      removeFromParent();
      EventBus().publish(mainMenuEvent);
    };
  }
}
