import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/game_component.dart';
import 'package:flame/components.dart';

class JumpComponent extends GameComponent {
  Vector2 velocity = Vector2(0, 0);
  double groundLevel = 0; // 바닥 높이
  final double gravity = 2400; // 중력 가속도
  final double jumpForce = -1200; // 점프 시 초기 속도
  final double maxSpeed = 800; // 최대 속도
  bool isJumping = false;
  bool isFollowingCamera = false; // 카메라가 따라다니는지 여부

  @override
  void onLoad() {
    super.onLoad();
    EventBus().subscribe(jumpEvent, jump);
    hasEffect = true;
  }

  @override
  void onRemove() {
    super.onRemove();
    EventBus().unsubscribe(jumpEvent, jump);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 중력 적용
    velocity.y += gravity * dt;
    if (velocity.y > maxSpeed) {
      velocity.y = maxSpeed;
    }

    // 캐릭터의 위치 업데이트
    position += velocity * dt;

    // 바닥에 닿았을 때 속도 초기화 및 점프 상태 해제
    if (position.y >= groundLevel) {
      position.y = groundLevel;
      velocity.y = 0;
      isJumping = false;
    }
    if (isFollowingCamera) {
      EventBus().publish(moveCameraEvent, this);
    }
  }

  void jump() {
    if (!isJumping) {
      velocity.y = jumpForce;
      isJumping = true;
    }
  }
}
