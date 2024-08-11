import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/game_component.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

enum BlockType {
  block1,
  block2,
  block3,
  block4,
  block5,
  item1,
  item2,
}

class BlockComponent extends GameComponent with HasPaint {
  BlockComponent({
    required this.blockGridPosition,
    required this.blockType,
    required this.blockKey,
  }) {
    gridPosition = blockGridPosition;
  }
  final Vector2 blockGridPosition;
  final BlockType blockType;
  final int blockKey;
  int blockHP = 1;
  int _maxBlockHP = 1;

  static const Map<BlockType, String> blockTypeMap = {
    BlockType.block1: 'game_block1.png',
    BlockType.block2: 'game_block2.png',
    BlockType.block3: 'game_block3.png',
    BlockType.block4: 'game_block4.png',
    BlockType.block5: 'game_block5.png',
    BlockType.item1: 'blue_box.png',
    BlockType.item2: 'red_box.png',
  };

  SpriteComponent? blockSprite;
  Color? blockColor;

  @override
  void onLoad() async {
    super.onLoad();
    setHP();
    blockSprite = SpriteComponent(
      size: Vector2(gridSize, gridSize),
      sprite: await Sprite.load(
        blockTypeMap[blockType]!,
      ),
    );
    blockSprite!.anchor = Anchor.topLeft;
    size = blockSprite!.size;
    add(blockSprite!);

    if (blockType == BlockType.block5) {
      blockColor = Colors.red;
    } else if (blockType == BlockType.block4) {
      blockColor = Colors.orange;
    } else if (blockType == BlockType.block3) {
      blockColor = Colors.yellow;
    } else if (blockType == BlockType.block2) {
      blockColor = Colors.green;
    } else if (blockType == BlockType.block1) {
      blockColor = Colors.blue;
    } else {
      blockColor = Colors.transparent;
    }

    RectangleComponent blockColorRect = RectangleComponent(
      size: size,
      paint: Paint()..color = blockColor!.withOpacity(0.5),
    );
    add(blockColorRect);
  }

  void setHP() {
    if (blockType == BlockType.block1) {
      _maxBlockHP = blockHP = 10;
    } else if (blockType == BlockType.block2) {
      _maxBlockHP = blockHP = 20;
    } else if (blockType == BlockType.block3) {
      _maxBlockHP = blockHP = 30;
    } else if (blockType == BlockType.block4) {
      _maxBlockHP = blockHP = 40;
    } else if (blockType == BlockType.block5) {
      _maxBlockHP = blockHP = 50;
    } else {
      _maxBlockHP = blockHP = 1;
    }
  }

  bool hitBlock(int damage) {
    if (blockHP <= 0) {
      return true;
    }
    blockHP -= damage;
    if (blockHP <= 0) {
      blockHP = 0;
      destory();
      return true;
    }
    return false;
  }

  void destory() {
    if (blockType == BlockType.item1) {
      EventBus().publish(changeLeftTimeEvent, 10.0);
    }
    if (blockType == BlockType.item2) {
      EventBus().publish(addAttackPowerEvent, 2);
    }
    OpacityEffect fadeOut = OpacityEffect.to(
      0.0,
      EffectController(duration: 0.5),
      onComplete: () {
        removeFromParent();
      },
    );
    blockSprite!.add(fadeOut);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    double hpPercent = blockHP / _maxBlockHP;

    paint = Paint();

    paint.color = blockColor ?? Colors.white;
    paint.style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(15, -15, (size.x - 30) * hpPercent, 10),
      paint,
    );
  }
}
