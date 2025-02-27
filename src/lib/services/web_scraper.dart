import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class WebScraper {
  Future<Map<String, dynamic>?> fetchPlayerStats(String playerName) async {
    // Split the player name into first and last names
    List<String> nameParts = playerName.split(' ');

    // Get the first letter of the last name, first 5 letters of the last name,
    // and the first 2 letters of the first name
    String lastNameInitial = nameParts[1][0].toLowerCase(); // First letter of last name
    String lastNamePrefix = nameParts[1].substring(0, 5).toLowerCase(); // First 5 letters of last name
    String firstNamePrefix = nameParts[0].substring(0, 2).toLowerCase(); // First 2 letters of first name

    // Construct the URL with the formatted player name
    String url = "https://www.basketball-reference.com/players/$lastNameInitial/$lastNamePrefix$firstNamePrefix" + "01.html";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var document = parse(response.body);

        // Find all season rows from the per_game table
        var seasonRows = document.querySelectorAll('#per_game tbody tr');

        if (seasonRows.isNotEmpty) {
          // Select the latest season row (which should be the last one)
          var latestSeasonRow = seasonRows.last;

          // Extract player stats
          var points = double.tryParse(latestSeasonRow.querySelector('td[data-stat="pts_per_g"]')?.text?.trim() ?? "0") ?? 0.0;
          var rebounds = double.tryParse(latestSeasonRow.querySelector('td[data-stat="trb_per_g"]')?.text?.trim() ?? "0") ?? 0.0;
          var assists = double.tryParse(latestSeasonRow.querySelector('td[data-stat="ast_per_g"]')?.text?.trim() ?? "0") ?? 0.0;

          return {
            "name": playerName,
            "points": points,
            "rebounds": rebounds,
            "assists": assists,
          };
        } else {
          print("No stats found for $playerName in the 2024-25 season.");
          return null;
        }
      } else {
        print("Failed to load player data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
