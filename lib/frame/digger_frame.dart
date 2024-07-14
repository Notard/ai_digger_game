import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/main_menu_page.dart';
import 'package:digger_game/game/title_page.dart';
import 'package:flame/camera.dart';

class DiggerWorld extends World {
  @override
  void onLoad() async {
    EventBus().subscribe(mainMenuEvent, (_) {
      MainMenuPage mainPage = MainMenuPage();
      add(mainPage);
    });
    add(TitlePage());
  }
}
