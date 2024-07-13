import 'package:digger_game/functions/event_bus.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';

enum CameraType {
  gui,
  map,
}

class DiggerCamera extends CameraComponent {
  DiggerCamera() {
    viewport = FixedResolutionViewport(
      resolution: Vector2(1080, 1920),
    );
  }

  @override
  void onLoad() {
    EventBus().subscribe(changeCamera, (data) {
      if (data == CameraType.gui) {
        viewport = FixedResolutionViewport(
          resolution: Vector2(1080, 1920),
        );
      } else if (data == CameraType.map) {
        viewport = MaxViewport();
      }
    });
  }
}
