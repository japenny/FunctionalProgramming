import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'Controller.dart';
import 'ConsoleUi.dart';
import 'WebClient.dart';

class C4Game {
  // Initialize a 6x7 board with '_' representing empty slots
  List<List<String>> board = List.generate(
      6, (_) => List.filled(7, '_')
  );
  late List<int> winRow;

  // Display the current state of the board
  void displayBoard([List<List<String>>? tempBoard]) {
    final workingBoard = tempBoard ?? board;
    const green = '\x1B[32m';
    const reset = '\x1B[0m';

    // Top border
    print('\n+---+---+---+---+---+---+---+');

    // Print each row with better formatting
    for (var row in workingBoard) {
      StringBuffer rowDisplay = StringBuffer('|');

      for (var cell in row) {
        String displayCell;

        // Check if the cell contains color codes (for winning pieces)
        if (cell.contains(green)) {
          // Cell is already formatted with color, use as is
          displayCell = ' $cell ';
        } else if (cell == 'X' || cell == 'O' || cell == '_') {
          // Handle the three possible states
          displayCell = ' $cell ';
        } else {
          // For any other unexpected value
          displayCell = ' $cell ';
        }

        rowDisplay.write('$displayCell|');
      }

      print(rowDisplay.toString());
    }

    // Column numbers
    print('+---+---+---+---+---+---+---+');
    print('  0   1   2   3   4   5   6  ');
    print('');
  }

  // Check if the game is won, drawn, or still ongoing
  bool checkWin(Map<String, dynamic> gameInfo) {
    var ackMove = gameInfo['ack_move'];
    var move = gameInfo['move'];
    if (move != null) {
      updateBoard(false, move['slot']); // Update board with bot move
    }

    if (ackMove['isWin']) {
      winRow = List<int>.from(ackMove['row']);
      print('===============\n৻(  •̀ ᗜ •́  ৻)  Player Won  ৻(  •̀ ᗜ •́  ৻)\n===============');
      return false;
    }

    if (move['isWin']) {
      winRow = List<int>.from(move['row']);
      print('===============\n˙◠˙  Computer Won  ˙◠˙\n===============');
      return false;
    }

    if (ackMove['isDraw'] || move['isDraw']) {
      print('===============\n¯\_(ツ)_/¯  Draw Game  ¯\_(ツ)_/¯\n===============');
      return false;
    }

    return true;
  }

  // Update the board with the player's or bot's move
  dynamic updateBoard(bool user, int move, [is_ai=false, List<List<String>>? tempBoard]) {
    List<List<String>> workingBoard;
    if (is_ai && tempBoard != null) {
      workingBoard = tempBoard.map((row) => List<String>.from(row)).toList();
    }
    else {
      workingBoard = board;
    }

    // Check if slot chosen is full and place piece
    for (var row = 5; row >= 0; row--) {
      if (workingBoard[row][move] == '_') {
        workingBoard[row][move] = user ? 'X' : 'O'; // 'X' for user, 'O' for bot
        if (is_ai) {
          const green = '\x1B[32m';
          const reset = '\x1B[0m';
          var val = workingBoard[row][move];
          workingBoard[row][move] = '$green$val$reset';
          return workingBoard;
        }
        return true;
      }
    }
    return false;
  }

  // Display the final board with the winning row highlighted
  void finishedBoard() {
    const blue = '\x1B[94m';
    const reset = '\x1B[0m';

    if (winRow.isNotEmpty) {
      for (var i = 0; i < winRow.length; i += 2) {
        var col = winRow[i];
        var row = winRow[i + 1];

        var piece = board[row][col];
        board[row][col] = '$blue$piece$reset'; // Highlight the winning pieces
      }
    }
    displayBoard();
  }
}