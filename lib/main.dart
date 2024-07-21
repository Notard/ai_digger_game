import 'package:digger_game/frame/digger_camera.dart';
import 'package:digger_game/frame/digger_frame.dart';
import 'package:digger_game/frame/digger_world.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: DiggerFrame(
        world: DiggerWorld(),
        camera: DiggerCamera(),
      ),
    ),
  );
}
