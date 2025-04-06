import 'C4Game.dart';

class Cheat extends C4Game {
  dynamic cheatSlot(List<List<String>> board) {
    const maxDepth = 5;
    const player = 'X';
    const opponent = 'O';

    // Step A: Check if we can win immediately
    for (int col = 0; col < board[0].length; col++) {
      var newBoard = updateBoard(true, col, true, board);
      if (newBoard != false) {
        var result = isWin(player, 4, newBoard);
        if (result['iswin'] == true) {
          return updateBoard(true, col, true, board); // make the winning move
        }
      }
    }

    // Step B: Block opponent if they can win in next move
    for (int col = 0; col < board[0].length; col++) {
      var newBoard = updateBoard(false, col, true, board);
      if (newBoard != false) {
        var result = isWin(opponent, 4, newBoard);
        if (result['iswin'] == true) {
          return updateBoard(true, col, true, board); // block the opponent
        }
      }
    }

    // Step C: Otherwise, use minimax
    int bestScore = -99999;
    int bestMove = -1;

    for (int col = 0; col < board[0].length; col++) {
      var newBoard = updateBoard(true, col, true, board);
      if (newBoard != false) {
        int score = minimax(newBoard, maxDepth - 1, false);
        if (score > bestScore) {
          bestScore = score;
          bestMove = col;
        }
      }
    }

    if (bestMove != -1) {
      return updateBoard(true, bestMove, true, board);
    }

    return board; // fallback if no valid move
  }


  int minimax(List<List<String>> board, int depth, bool isMaximizing) {
    var resultX = isWin('X', 4, board);
    var resultO = isWin('O', 4, board);

    if (resultX['iswin'] == true) return 1000 + depth;
    if (resultO['iswin'] == true) return -1000 - depth;
    if (resultX['isdraw'] == true || depth == 0) return evaluateBoard(board);

    if (isMaximizing) {
      int maxEval = -99999;
      for (int col = 0; col < board[0].length; col++) {
        var newBoard = updateBoard(true, col, true, board);
        if (newBoard != false) {
          int eval = minimax(newBoard, depth - 1, false);
          maxEval = maxEval > eval ? maxEval : eval;
        }
      }
      return maxEval;
    } else {
      int minEval = 99999;
      for (int col = 0; col < board[0].length; col++) {
        var newBoard = updateBoard(false, col, true, board);
        if (newBoard != false) {
          int eval = minimax(newBoard, depth - 1, true);
          minEval = minEval < eval ? minEval : eval;
        }
      }
      return minEval;
    }
  }

  int evaluateBoard(List<List<String>> board) {
    // Simple evaluation: count 3-in-a-rows for player - opponent
    int score = 0;
    var x3 = isWin('X', 3, board);
    var o3 = isWin('O', 3, board);

    if (x3['iswin'] == true) score += 100;
    if (o3['iswin'] == true) score -= 100;

    var x2 = isWin('X', 2, board);
    var o2 = isWin('O', 2, board);

    if (x2['iswin'] == true) score += 10;
    if (o2['iswin'] == true) score -= 10;

    return score;
  }


  // dynamic cheatSlot(List<List<String>> board) {
  //   int cols = board[0].length;
  //
  //   for (int winCo = 4; winCo > 0; winCo--) {
  //     for (int newMove = 0; newMove < cols; newMove++) {
  //       var result;
  //
  //       // Try to win
  //       var tempBoard = updateBoard(true, newMove, true, board);
  //       if (tempBoard != false) {
  //         result = isWin('X', winCo, tempBoard);
  //         if (result['iswin'] == true) {
  //           return tempBoard;
  //         }
  //       }
  //
  //       // Try to block bot
  //       tempBoard = updateBoard(false, newMove, true, board);
  //       if (tempBoard != false) {
  //         result = isWin('O', winCo, tempBoard);
  //         if (result['iswin'] == true) {
  //           return updateBoard(true, newMove, true, board);
  //         }
  //       }
  //     }
  //   }
  //   return board; // If no other good moves are found, return the original board
  // }

  Map<String, bool> isWin(String player, int winCo, tempBoard) {
    final activeBoard = tempBoard;
    final rows = activeBoard.length;
    final cols = activeBoard[0].length;

    // Horizontal check
    for (int r = 0; r < rows; r++) {
      int co = 0;

      for (int i = 0; i < (cols * 2 - 1); i++) {
        var currCol = i % cols;
        if ((activeBoard[r][currCol]).contains(player)) {
          co++;
          if (co == winCo) {
            return {
              'iswin': true,
              'isdraw': false,
            };
          }
        } else {
          co = 0;
        }
      }
    }

    // Vertical check
    for (int c = 0; c < cols; c++) {
      int co = 0;

      for (int i = 0; i < (rows * 2 - 1); i++) {
        var currRow = i % rows;
        if ((activeBoard[currRow][c]).contains(player)) {
          co++;
          if (co == winCo) {
            return {
              'iswin': true,
              'isdraw': false,
            };
          }
        } else {
          co = 0;
        }
      }
    }

    // Diagonal bottom-left to top-right (/)
    // for (int r = rows - 1; r >= rows - winCo; r--) {
    for (int r = rows - 1; r >= winCo - 1; r--) {
      for (int c = 0; c <= cols - winCo; c++) {
        int co = 0;

        for (int i = 0; i < winCo; i++) {
          if ((activeBoard[r - i][c + i]).contains(player)) {
            co++;
          } else {
            break;
          }
        }

        if (co == winCo) {
          return {
            'iswin': true,
            'isdraw': false,
          };
        }
      }
    }

    // Diagonal bottom-right to top-left (\)
    // for (int r = rows - 1; r >= rows - winCo; r--) {
    for (int r = winCo - 1; r < rows; r++) {
      for (int c = cols - 1; c >= winCo - 1; c--) {
        int co = 0;

        for (int i = 0; i < winCo; i++) {
          if ((activeBoard[r - i][c - i]).contains(player)) {
            co++;
          } else {
            break;
          }
        }

        if (co == winCo) {
          return {
            'iswin': true,
            'isdraw': false,
          };
        }
      }
    }

    // Draw check
    bool isDraw = activeBoard[0].every((col) => col != '_');
    if (isDraw) {
      return {
        'iswin': false,
        'isdraw': true,
      };
    }

    // Game still in progress
    return {
      'iswin': false,
      'isdraw': false,
    };
  }
}