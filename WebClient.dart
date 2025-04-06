import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class WebClient {
  var serverUrl;
  WebClient(this.serverUrl);

  Future<List?> getInfo() async {
    try {
      var response = await http.get(Uri.parse(serverUrl + '/info/'));

      if (response.statusCode != 200) {
        stdout.write('Failed to get server info. Status code: ${response.statusCode}');
        exit(255);
      }

      var info = json.decode(response.body);
      List strategies = info['strategies'];
      return strategies;
    }
    catch (e) {
      stdout.write('Error fetchign server /info/: $e');
      exit(255);
    }

  }

  Future<String> getNew(strat) async {
    try {
      var response = await http.get(
          Uri.parse(
              serverUrl + '/new/?strategy=' + strat));

      if (response.statusCode != 200) {
        stdout.write('Failed to get server info. Status code: ${response.statusCode}');
        exit(255);
      }

      var info = json.decode(response.body);
      if (!info['response']) {
        stdout.write('Got response error: ${info['reason']}');
        exit(255);
      }

      String pid = info['pid'];
      return pid;
    }
    catch (e) {
      stdout.write('Error fetching server /new/: $e');
      exit(255);
    }
  }

  Future<Map<String, dynamic>> getPlay(pid, x) async {
    try {
      var response = await http.get(
          Uri.parse(
              serverUrl + '/play/?pid=${pid}&move=${x}'
          ));

      if (response.statusCode != 200) {
        stdout.write('Failed to get server info. Status code: ${response.statusCode}');
        exit(255);
      }

      var info = json.decode(response.body);
      if (!info['response']) {
        stdout.write('Got error response: ${info['reason']}');
        exit(255);
      }
      return info;
    }
    catch (e) {
      stdout.write('Error fetching server /play/: $e');
      exit(255);
    }
  }
}