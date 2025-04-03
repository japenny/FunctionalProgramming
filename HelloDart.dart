import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() async {
  const defaultUrl = 'https://www.cs.utep.edu/cheon/cs3360/project/c4';

  stdout.write('Enter the server URL [default: $defaultUrl]: ');
  var input = stdin.readLineSync();
  var url = (input == null || input.trim().isEmpty) ? defaultUrl : input.trim();

  print('\nObtaining server info ...\n');

  try {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      print('Failed to get server info. Status code: ${response.statusCode}');
      return;
    }

    var info = json.decode(response.body);
    List strategies = List<String>.from(info['strategies']);

    print('Select the server strategy:');
    for (int i = 0; i < strategies.length; i++) {
      print('${i + 1}. ${strategies[i]}');
    }

    stdout.write('Your choice [default: 1]: ');
    var choiceInput = stdin.readLineSync();
    int choice = int.tryParse(choiceInput ?? '') ?? 1;

    if (choice < 1 || choice > strategies.length) {
      print('Invalid choice. Using default strategy: ${strategies[0]}');
      choice = 1;
    }

    print('\nSelected strategy: ${strategies[choice - 1]}');

  } catch (e) {
    print('Error: $e');
  }
}