import 'package:digger_game/game/block_component.dart';
import 'package:digger_game/game/grid_component.dart';
import 'package:digger_game/game/mole_character.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

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

    BlockComponent blockComponent =
        BlockComponent(blockGridPosition: Vector2(0, 0), color: Colors.red);
    blockComponent.priority = 4;
    add(blockComponent);

    blockComponent =
        BlockComponent(blockGridPosition: Vector2(1, 0), color: Colors.blue);
    blockComponent.priority = 4;
    add(blockComponent);

    blockComponent =
        BlockComponent(blockGridPosition: Vector2(2, 0), color: Colors.green);
    blockComponent.priority = 4;
    add(blockComponent);
  }
}
