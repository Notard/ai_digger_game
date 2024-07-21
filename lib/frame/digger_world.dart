import 'package:digger_game/functions/event_bus.dart';
import 'package:digger_game/game/game_page.dart';
import 'package:digger_game/game/main_menu_page.dart';
import 'package:digger_game/game/title_page.dart';
import 'package:flame/camera.dart';
import 'package:flame/src/components/core/component.dart';

class DiggerWorld extends World {
  @override
  void onLoad() async {
    EventBus().subscribe(mainMenuEvent, (_) {
      MainMenuPage mainPage = MainMenuPage();
      add(mainPage);
    });
    EventBus().subscribe(gamePageEvent, (_) {
      GamePage gamePage = GamePage();
      add(gamePage);
    });
    add(TitlePage());
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    // TODO: implement onChildrenChanged
    super.onChildrenChanged(child, type);
  }
}
