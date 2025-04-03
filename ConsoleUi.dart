import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ConsoleUi {
  void showMessage(String msg) {
    print(msg);
  }

  promptServerUi() {
    const defaultUrl = 'https://www.cs.utep.edu/cheon/cs3360/project/c4';
    stdout.write('Enter the base server URL [default: $defaultUrl]: ');

    var input = stdin.readLineSync();
    var url = (input == null || input.trim().isEmpty) ? defaultUrl : input.trim();
    return url;
  }

  String promptStrategy(strats) {

    // Display available strategies
    print('Select the server strategy:');
    for (int i = 0; i < strats.length; i++) {
      print('${i + 1}. ${strats[i]}');
    }

    // Get strategy
    stdout.write('Your choice [default: 1]: ');
    var choiceInput = stdin.readLineSync();
    int choice = int.tryParse(choiceInput ?? '') ?? 1;

    // Check if valid strategy
    if (choice < 1 || choice > strats.length) {
      print('Invalid choice. Using default strategy: ${strats[0]}');
      choice = 1;
    }

    var chosenStrat = strats[choice - 1];
    print('\nSelected strategy: ${strats[choice - 1]}');
    return chosenStrat;
  }
}