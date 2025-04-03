import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class WebClient {
  var serverUrl;
  WebClient(this.serverUrl);

  Future<List?> getInfo() async {
    var response = await http.get(Uri.parse(serverUrl + '/info/'));
    if (response.statusCode != 200) {
      print('Failed to get server info. Status code: ${response.statusCode}');
      return null;
    }

    var info = json.decode(response.body);
    List strategies = info['strategies'];
    return strategies;
  }

  Future<String> getNew(strat) async {
    var response = await http.get(Uri.parse(serverUrl +
                                  '/new/?strategy=' + strat));

    if (response.statusCode != 200) {
      throw Exception('Failed to get server info. Status code: ${response.statusCode}');
    }

    var info = json.decode(response.body);
    if (!info['response']) {
      throw Exception('Failed to get server info. Status code: ${info['reason']}');
    }

    String pid = info['pid'];
    return pid;
  }

  Future<Map<String, dynamic>> getPlay(pid, x) async {
    var response = await http.get(
        Uri.parse(
            serverUrl + '/play/?pid=${pid}&move=${x}'
        ));

    if (response.statusCode != 200) {
      throw Exception('Failed to get server info. Status code: ${response.statusCode}');
    }

    var info = json.decode(response.body);
    if (!info['response']) {
      throw Exception('Got error response: ${info['reason']}');
    }
    return info;
  }
}