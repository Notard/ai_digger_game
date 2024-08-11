import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/game_page.dart';
import 'package:digger_game/game/main_menu_page.dart';
import 'package:digger_game/game/title_page.dart';
import 'package:flame/camera.dart';

class DiggerWorld extends World {
  @override
  void onLoad() async {
    EventBus().subscribe(mainMenuEvent, goMainMenu);
    EventBus().subscribe(gamePageEvent, goGamePage);
    add(TitlePage());
  }

  void goMainMenu(_) {
    MainMenuPage mainPage = MainMenuPage();
    add(mainPage);
  }

  void goGamePage(_) {
    GamePage gamePage = GamePage();
    add(gamePage);
  }

  @override
  void onRemove() {
    EventBus().unsubscribe(mainMenuEvent, goMainMenu);
    EventBus().unsubscribe(gamePageEvent, goGamePage);
  }
}
