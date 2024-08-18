import 'package:digger_game/functions/event_bus.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';

class DiggerCamera extends CameraComponent {
  double _yPosition = 0;
  DiggerCamera() {
    viewport = FixedResolutionViewport(
      resolution: Vector2(1080, 1920),
    );
  }

  @override
  void onLoad() {
    EventBus().subscribe(moveCameraEvent, moveCarmera);
    EventBus().subscribe(addViewportEvent, addViewport);
    EventBus().subscribe(removeViewportEvent, removeViewport);
  }

  void moveCarmera(PositionComponent? target) {
    if (target == null) {
      moveTo(Vector2.zero());
      _yPosition = 0;
    } else {
      if (target.y + 320 != _yPosition) {
        _yPosition = target.y + 320;
        moveTo(Vector2(0, _yPosition), speed: 1000);
      }
    }
  }

  void addViewport(PositionComponent target) {
    viewport.add(target);
  }

  void removeViewport(PositionComponent target) {
    viewport.remove(target);
  }

  @override
  void onRemove() {
    EventBus().unsubscribe(moveCameraEvent, moveCarmera);
    EventBus().unsubscribe(addViewportEvent, addViewport);
    for (Component element in viewport.children) {
      if (element is PositionComponent) {
        viewport.remove(element);
      }
    }
  }
}
