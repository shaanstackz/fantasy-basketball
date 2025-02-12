import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/player_stats.dart';

class ApiService {
  Future<PlayerStats?> fetchPlayerStats(String playerName) async {
    final Uri url = Uri.parse("https://www.balldontlie.io/api/v1/players?search=$playerName");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'].isNotEmpty) {
          return PlayerStats.fromJson(data['data'][0]); // Convert to PlayerStats object
        }
      }
    } catch (e) {
      print("Failed to fetch player stats: $e");
    }
    return null; // Return null if no data found
  }
}
