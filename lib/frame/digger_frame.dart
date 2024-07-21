import 'package:digger_game/functions/event_bus.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

enum Direction { up, left, right, down }

class DiggerFrame extends FlameGame with PanDetector {
  DiggerFrame({required super.world, required super.camera});
  Vector2? _startPosition;
  Vector2? _endPosition;
  @override
  void onPanStart(DragStartInfo info) {
    // 스와이프 시작
    _startPosition = info.eventPosition.global;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // 스와이프 중
    _endPosition = info.eventPosition.global;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // 스와이프 종료
    if (_startPosition != null && _endPosition != null) {
      final delta = _endPosition! - _startPosition!;
      if (delta.x.abs() > delta.y.abs()) {
        if (delta.x > 0) {
          // 오른쪽 스와이프
          onSwipeRight();
        } else {
          // 왼쪽 스와이프
          onSwipeLeft();
        }
      } else {
        if (delta.y > 0) {
          // 아래 스와이프
          onSwipeDown();
        } else {
          // 위로 스와이프 (점프)
          onSwipeUp();
        }
      }
    }
    _startPosition = null;
    _endPosition = null;
  }

  void onSwipeLeft() {
    EventBus().publish(characterMoveEvent, Direction.left);
  }

  void onSwipeRight() {
    EventBus().publish(characterMoveEvent, Direction.right);
  }

  void onSwipeUp() {
    EventBus().publish(characterMoveEvent, Direction.up);
  }

  void onSwipeDown() {
    EventBus().publish(characterMoveEvent, Direction.down);
  }
}
