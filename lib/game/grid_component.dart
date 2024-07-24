import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GridComponent extends PositionComponent {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    drawGrid(canvas);
  }

  void drawGrid(Canvas canvas) {
    Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.0;

    double gridSize = 160.0; // 그리드 간격

    for (double x = -540; x <= 540; x += gridSize) {
      canvas.drawLine(Offset(x, -960), Offset(x, 960), paint);
    }

    for (double y = -960; y <= 960; y += gridSize) {
      canvas.drawLine(Offset(-540, y), Offset(1080, y), paint);
    }
  }
}
