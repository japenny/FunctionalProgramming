import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'Controller.dart';
import 'ConsoleUi.dart';
import 'WebClient.dart';

class C4Game {
  List<List<String>> board = List.generate(
    6,
      (_) => List.filled(7, '_')
  );
  late List<int> winRow;

  displayBoard(){
    for (var row in board){
      print(row);
    }
  }

  int getSlot(){
    late int slot;

    print('======\nBoard\n======');
    displayBoard();
    print('Enter the slot column');

    while (true) {
      stdout.write("> ");
      var input = stdin.readLineSync();

      // Check if input is empty
      if (input == null || input.trim().isEmpty){
        print('Null input, try again.');
        continue;
      }

      slot = int.parse(input);
      // Check if input is out of range
      if (slot < 0 || slot > 6) {
        print('Chosen slot is out of range, must be between 0 and 6 (inclusive), try again.');
        continue;
      }

      // Check if chosen slot is full
      if (!updateBoard(true, slot)){
        print('Chosen slot is full, try again.');
        continue;
      }

      break;
    }
    return slot;
  }

  bool checkWin(gameInfo){
    var ackMove = gameInfo['ack_move'];
    var move = gameInfo['move'];
    updateBoard(false, move['slot']); // Update board with bot move

    if (ackMove['isWin']) {
      winRow = List<int>.from(ackMove['row']);
      print('===============\nPlayer Won\n===============');
      return false;
    }

    if (move['isWin']) {
      winRow = List<int>.from(move['row']);
      print('===============\nComputer Won\n===============');
      return false;
    }

    if (ackMove['isDraw'] || move['isDraw']) {
      print('===============\nDraw Game\n===============');
      return false;
    }

    return true;
  }

  bool updateBoard(user, move) {
    // Check if slot chosen is full and place piece
    for (var row=5; row>= 0; row--) {
      if (board[row][move] == '_'){
        board[row][move] = user ? 'X' : 'O';
        return true;
      }
    }
    return false;
  }

  finishedBoard() {
    const blue = '\x1B[94m';
    const reset = '\x1B[0m';

    if (winRow.isNotEmpty) {
      for (var i = 0; i < winRow.length; i+=2) {
        var col = winRow[i];
        var row = winRow[i + 1];

        var piece = board[row][col];
        board[row][col] = '$blue$piece$reset';
      }
    }
    displayBoard();
  }
}
