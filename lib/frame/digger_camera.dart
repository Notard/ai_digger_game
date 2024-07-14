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
    EventBus().subscribe(moveCameraEvent, (data) {
      if (data == null) {
        moveTo(Vector2.zero());
        _yPosition = 0;
      } else {
        PositionComponent target = data;
        if (target.y != _yPosition) {
          _yPosition = target.y;
          moveTo(Vector2(0, _yPosition), speed: 1);
        }
      }
    });
  }
}
