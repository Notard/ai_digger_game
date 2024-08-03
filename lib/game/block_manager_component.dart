import 'dart:math';
import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/block_component.dart';
import 'package:flame/components.dart';

class BlockManagerComponent extends PositionComponent {
  Map<int, BlockComponent> blockMap = {};

  @override
  void onLoad() {
    // 블록들을 저장할 리스트 2차원 배열 6x100
    List<List<BlockComponent>> blocks = List.generate(
      100,
      (index) => List.generate(
        6,
        (index2) => BlockComponent(
          blockGridPosition: Vector2(index2.toDouble() - 3.0, index.toDouble()),
          blockType:
              BlockType.values[Random().nextInt(BlockType.values.length)],
          blockKey: index2 * 100 + index,
        ),
      ),
    );
    for (List<BlockComponent> blockList in blocks) {
      for (BlockComponent block in blockList) {
        add(block);
        blockMap[block.blockKey] = block;
      }
    }
    EventBus().subscribe(removeBlockEvent, (Vector2 gridPosition) {
      hitBlock(gridPosition, 1);
    });
  }

  double getGridYPosition(double gridX) {
    double minGridY = 100;
    for (BlockComponent block in blockMap.values) {
      if (block.gridPosition.x == gridX && block.gridPosition.y < minGridY) {
        minGridY = block.gridPosition.y;
      }
    }
    return minGridY;
  }

  void hitBlock(Vector2 gridPosition, int power) {
    int blockKey = (gridPosition.x + 3).toInt() * 100 + gridPosition.y.toInt();
    BlockComponent? block = blockMap[blockKey];
    if (block != null) {
      bool isDestory = block.hitBlock(power);
      if (isDestory) {
        blockMap.remove(block.blockKey);
      }
    }
  }
}
