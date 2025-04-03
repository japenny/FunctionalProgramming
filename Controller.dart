import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'ConsoleUi.dart';
import 'WebClient.dart';
import 'C4Game.dart';

class Controller {
  late String url;
  late dynamic strats;
  late String strat;
  late String pid;

  void start() async {

    // Get server url
    var ui = ConsoleUi();
    ui.showMessage("Welcome to C4");
    url = ui.promptServerUi();
    ui.showMessage(url);

    // Get available strategies
    var net = WebClient(url);
    ui.showMessage('Connecting to server...\n');
    strats = await net.getInfo();

    // Get strategy info
    strat = ui.promptStrategy(strats);
    pid = await net.getNew(strat);

    // Run c4 game
    var c4 = C4Game();
    var c4Continue = true;

    while (c4Continue) {
      var slot = c4.getSlot();
      var gameInfo = await net.getPlay(pid, slot);
      c4Continue = c4.checkWin(gameInfo);

      if (!c4Continue){
        c4.finishedBoard();
      }
    }
    print('Game Finished');

  }
}


void main() async {
  Controller().start();
}