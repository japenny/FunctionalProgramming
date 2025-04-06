import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'ConsoleUi.dart';
import 'WebClient.dart';
import 'C4Game.dart';
import 'Cheat.dart';

/**
 * Main controller for the Connect Four game.
 */
class Controller {
  late String url;
  late dynamic strats;
  late String strat;
  late String pid;

  /**
   * Starts and manages the game session.
   */
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

    // Enable cheats?
    var cheatsOn = ui.promptToCheat();

    // Run c4 game
    var c4 = C4Game();
    var cheat = Cheat();
    var c4Continue = true;
    var showCheats = false;

    // Main game loop
    while (c4Continue) {

      // Display current board process
      print('\n\n');
      if (showCheats) {
        var suggestBoard = cheat.cheatSlot(c4.board);
        c4.displayBoard(suggestBoard);
      }
      else {
        c4.displayBoard();
      }

      int slot = -1;
      bool validMove = false;

      // Get player move
      while (!validMove) {
        slot = ui.getSlot();
        validMove = c4.updateBoard(true, slot);

        if (!validMove) {
          print('Chosen slot is full, try again.');
        }
      }

      // Process move with server and get results
      var gameInfo = await net.getPlay(pid, slot);
      c4Continue = c4.checkWin(gameInfo);

      if (!c4Continue){
        c4.finishedBoard();
      }
      if (cheatsOn) {
        showCheats = true;
      }
    }
    print('Game Finished');

  }
}


void main() async {
  Controller().start();
}