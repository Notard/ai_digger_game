import 'package:digger_game/component/game_rect_button.dart';
import 'package:digger_game/component/paint_text_component.dart';
import 'package:digger_game/frame/digger_camera.dart';
import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/functions/game_function.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TitlePage extends PositionComponent {
  @override
  Future<void> onLoad() async {
    SpriteComponent title =
        SpriteComponent(sprite: await Sprite.load('digger_game_title.png'));
    title.position = Vector2(0, 0);
    title.anchor = Anchor.center;
    title.size = Vector2(1080, 1920);
    add(title);

    PaintTextComponent startText = PaintTextComponent(
      text: '땅파기 게임',
      position: Vector2(0, -200),
      style: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 120,
        fontFamily: '온글잎 은별',
        shadows: [
          Shadow(
            color: Colors.white,
            offset: Offset(2, 2),
            blurRadius: 10,
          ),
        ],
      ),
    );
    startText.anchor = Anchor.center;
    add(startText);

    GameRectButton startButton = GameRectButton(
      spriteFileName: 'white_button.png',
      buttonSize: Vector2(540, 200),
      textComponent: TextComponent(
        text: '시작하기',
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: GameFunction().getTextStyle(
            fontSize: 60,
            color: Colors.white,
          ),
        ),
      ),
      onTapDownEvent: () {
        EventBus().publish(changeCamera, CameraType.map);
      },
    );
    startButton.position = Vector2(0, 600);
    startButton.anchor = Anchor.center;
    add(startButton);

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

    return super.onLoad();
  }
}
