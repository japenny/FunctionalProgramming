import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'Controller.dart';
import 'ConsoleUi.dart';
import 'WebClient.dart';

/**
 * Represents the Connect Four game board and core game logic.
 */
class C4Game {
  // Initialize a 6x7 board with '_' representing empty slots
  List<List<String>> board = List.generate(
      6, (_) => List.filled(7, '_')
  );
  late List<int> winRow;

  /**
   * Displays the current state of the game board.
   *
   * @param board The game board to display
   */
  void displayBoard([List<List<String>>? tempBoard]) {
    final workingBoard = tempBoard ?? board;
    const green = '\x1B[32m';
    const reset = '\x1B[0m';

    // Top border
    print('\n+---+---+---+---+---+---+---+');

    // Print each row
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

  /**
   * Processes the game state after a move to determine if the game continues.
   *
   * @param gameInfo Information returned from the server about the current move
   * @return True if the game should continue, false if the game has ended
   */
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

  /**
   * Updates the board with a player or computer move.
   *
   * @param user True if the move is made by the user, false for the computer
   * @param move Column index where the piece should be dropped
   * @param isSimulation True if this is a simulation move (for AI calculations)
   * @param tempBoard Optional temporary board for simulation
   * @return Updated board for simulation, or true if move was successful, false if column is full
   */
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

  /**
   * Updates the board to highlight the winning sequence.
   */
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