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

    setFadeEffect(title, false);
    setFadeEffect(startText, true);
  }

  void setFadeEffect(PositionComponent component, bool makeEvent) {
    OpacityEffect fadeIn = OpacityEffect.to(
      1.0,
      EffectController(duration: 0.3),
    );

    OpacityEffect fadeOut = OpacityEffect.to(
      0.0,
      DelayedEffectController(
        delay: 0.1,
        EffectController(duration: 0.3),
      ),
    );
    SequenceEffect fadeInOutSequence = SequenceEffect([fadeIn, fadeOut]);
    component.add(fadeInOutSequence);
    if (makeEvent == true) {
      fadeInOutSequence.onComplete = () {
        removeFromParent();
        EventBus().publish(mainMenuEvent);
      };
    }
  }
}
