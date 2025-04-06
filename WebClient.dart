import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// Handles communication with game server.
class WebClient {
  var serverUrl;
  WebClient(this.serverUrl);

  /**
   * Gets available game strategies from server.
   *
   * @return List of available strategies
   * @throws Exception if the request fails
   */
  Future<List?> getInfo() async {
    try {
      var response = await http.get(Uri.parse(serverUrl + '/info/'));

      if (response.statusCode != 200) {
        throw Exception('Failed to get server info. Status code: ${response.statusCode}');
      }

      var info = json.decode(response.body);
      List strategies = info['strategies'];
      return strategies;
    }
    catch (e) {
      throw Exception('Error fetchign server /info/: $e');
    }

  }

  /**
   * Starts a new game with the specified strategy.
   *
   * @param strategy to use
   * @return player id for the new game
   * @throws Exception if the request fails.
   */
  Future<String> getNew(strat) async {
    try {
      var response = await http.get(
          Uri.parse(
              serverUrl + '/new/?strategy=' + strat));

      if (response.statusCode != 200) {
        throw Exception('Failed to get server info. Status code: ${response.statusCode}');
      }

      var info = json.decode(response.body);
      if (!info['response']) {
        throw Exception('Got response error: ${info['reason']}');
      }

      String pid = info['pid'];
      return pid;
    }
    catch (e) {
      throw Exception('Error fetching server /new/: $e');
    }
  }

  /**
   * Makes a move in game.
   *
   * @param pid Player id for the current game
   * @param move Column index for the player's move
   * @return Response from the server containing game state
   * @throws Exception if the request fails
   */
  Future<Map<String, dynamic>> getPlay(pid, x) async {
    try {
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
    catch (e) {
      throw Exception('Error fetching server /play/: $e');
    }
  }
}