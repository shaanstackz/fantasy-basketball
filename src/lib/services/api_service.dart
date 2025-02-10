import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/player_stats.dart';

class ApiService {
  final String _baseUrl = "https://api.basketball-stats.com/";

  Future<PlayerStats?> fetchPlayerStats(String playerName) async {
    final response = await http.get(Uri.parse("$_baseUrl/players/stats?name=$playerName"));

    if (response.statusCode == 200) {
      return PlayerStats.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
