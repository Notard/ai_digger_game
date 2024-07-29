import 'package:digger_game/game/game_component.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BlockComponent extends GameComponent with HasPaint {
  BlockComponent({
    required this.blockGridPosition,
    required this.color,
  }) {
    gridPosition = blockGridPosition;
  }
  final Vector2 blockGridPosition;
  final Color color;
  SpriteComponent? blockSprite;
  @override
  void onLoad() async {
    super.onLoad();
    blockSprite = SpriteComponent(
      size: Vector2(160, 160),
      sprite: await Sprite.load(
        ('game_block.png'),
      ),
    );
    blockSprite!.anchor = Anchor.topLeft;
    size = blockSprite!.size;
    // add(blockSprite!);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    blockSprite?.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));
    final paint = Paint()..color = color.withOpacity(0.5);
    canvas.drawRRect(rrect, paint);
  }
}
