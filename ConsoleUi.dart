import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'C4Game.dart';

/**
 * Handles user interface interactions through the console.
 */
class ConsoleUi {
  /**
   * Displays a message to the user.
   *
   * @param msg The message to display
   */
  void showMessage(String msg) {
    print(msg);
  }

  /**
   * Prompts the user for the server URL.
   *
   * @return The server URL entered by the user or the default URL
   */
  promptServerUi() {
    const defaultUrl = 'https://www.cs.utep.edu/cheon/cs3360/project/c4';
    stdout.write('Enter the base server URL [default: $defaultUrl]: ');

    var input = stdin.readLineSync();
    var url = (input == null || input.trim().isEmpty) ? defaultUrl : input.trim();
    return url;
  }

  /**
   * Prompts the user to select a strategy from the available options.
   *
   * @param strategies Available strategies from the server
   * @return The selected strategy
   */
  String promptStrategy(strats) {

    // Display available strategies
    print('Select the server strategy:');
    for (int i = 0; i < strats.length; i++) {
      print('${i + 1}. ${strats[i]}');
    }

    // Get strategy
    stdout.write('Your choice [default: 1]: ');
    var choiceInput = stdin.readLineSync();
    var choice = int.tryParse(choiceInput ?? '');

    // Empty input
    if (choice == null) {
      print('Invalid choice. Using default strategy: ${strats[0]}');
      choice = 1;
    }

    // Check if valid strategy
    if (choice < 1 || choice > strats.length) {
      print('Invalid choice. Using default strategy: ${strats[0]}');
      choice = 1;
    }

    // Get chosen strategy
    var chosenStrat = strats[choice - 1];
    print('\nSelected strategy: ${strats[choice - 1]}');
    return chosenStrat;
  }

  /**
   * Gets the slot number from the user, validating the input.
   *
   * @return The valid slot number entered by the user
   */
  int getSlot() {
    print('Enter the slot column');

    while (true) {
      stdout.write("> ");
      var input = stdin.readLineSync();

      // Check if input is empty
      if (input == null || input.trim().isEmpty) {
        print('Null input, try again.');
        continue;
      }

      var slot = int.tryParse(input ?? '');
      // null slot
      if (slot == null) {
        print('Invalid choice. Must be between 0 and 6 (inclusive), try again.');
        continue;
      }

      // Check if input is out of range
      if (slot < 0 || slot > 6) {
        print('Chosen slot is out of range, must be between 0 and 6 (inclusive), try again.');
        continue;
      }

      return slot;
    }
  }

  /**
   * Asks the user if they want to enable cheats.
   *
   * @return True if cheats are enabled, false otherwise
   */
  bool promptToCheat() {
    print('Would you like to enable cheats? (y=yes, n=no)');
    stdout.write('Your choice [default: n]: ');
    final choiceInput = stdin.readLineSync()?.toLowerCase().trim();

    // Empty input
    if (choiceInput == null || choiceInput.isEmpty) {
      return false;
    }

    // Select cheat method
    var choice = choiceInput == 'y';
    if (choice) {
      print('To note, you must place atleast one piece before cheats begin to show.');
      return true;
    }
    else {
      return false;
    }
  }
}