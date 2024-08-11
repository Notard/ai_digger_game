import 'dart:math';
import 'package:digger_game/game/block_component.dart';
import 'package:flame/components.dart';

class BlockManagerComponent extends PositionComponent {
  Map<int, BlockComponent> blockMap = {};
  List<double> cumulativeProbabilities = []; // 누적 확률

  @override
  void onLoad() {
    // 각 블록의 확률 설정
    final probabilities = [0.35, 0.25, 0.2, 0.1, 0.05, 0.025, 0.025];

    double cumulative = 0.0;
    for (var prob in probabilities) {
      cumulative += prob;
      cumulativeProbabilities.add(cumulative);
    }

    // 블록들을 저장할 리스트 2차원 배열 6x100
    List<List<BlockComponent>> blocks = List.generate(
      100,
      (index) => List.generate(
        6,
        (index2) => BlockComponent(
          blockGridPosition: Vector2(index2.toDouble() - 3.0, index.toDouble()),
          blockType: BlockType.values[selectBlock()],
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
  }

  // 블록을 확률에 따라 선택하는 함수
  int selectBlock() {
    double randomValue = Random().nextDouble(); // 0.0에서 1.0 사이의 난수 생성
    for (int i = 0; i < cumulativeProbabilities.length; i++) {
      if (randomValue < cumulativeProbabilities[i]) {
        return i;
      }
    }
    return 5; // 이론상 도달할 수 없음 (모든 확률의 합은 1)
  }

  double getGridYPosition(double gridX, double gridY) {
    double minGridY = 100;
    int blockKey = (gridX + 3).toInt() * 100;
    int startY = gridY.toInt();
    startY = startY < 0 ? 0 : startY;
    for (int y = startY; y < 100; y++) {
      if (blockMap.containsKey(blockKey + y)) {
        minGridY = y.toDouble();
        break;
      }
    }
    return minGridY;
  }

// 같은 색의 이웃 블록을 파괴하는 함수
  void destroyAdjacentBlocks(Vector2 position, BlockType blockType) {
    List<Vector2> directions = [
      Vector2(0, -1), // 상
      Vector2(0, 1), // 하
      Vector2(-1, 0), // 좌
      Vector2(1, 0), // 우
    ];

    for (Vector2 direction in directions) {
      Vector2 neighborPos = position + direction;
      int neighborKey =
          (neighborPos.x + 3).toInt() * 100 + neighborPos.y.toInt();

      BlockComponent? neighborBlock = blockMap[neighborKey];
      if (neighborBlock != null && neighborBlock.blockType == blockType) {
        blockMap.remove(neighborBlock.blockKey);
        neighborBlock.destory(); // 이웃 블록 파괴
        // 재귀적으로 이웃 블록 검사 및 파괴
        destroyAdjacentBlocks(neighborPos, blockType);
      }
    }
  }

  bool hitBlock(Vector2 gridPosition, int power) {
    if (gridPosition.y < 0) {
      return true;
    }
    int blockKey = (gridPosition.x + 3).toInt() * 100 + gridPosition.y.toInt();
    BlockComponent? block = blockMap[blockKey];
    if (block != null) {
      bool isDestory = block.hitBlock(power);
      if (isDestory) {
        BlockType blockType = block.blockType;
        blockMap.remove(block.blockKey);
        destroyAdjacentBlocks(gridPosition, blockType); // 인접한 블록 파괴
        return true;
      } else {
        return false;
      }
    }
    return true;
  }
}
