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

    // Create the URL with the constructed player name
    String url = "https://www.basketball-reference.com/players/$lastNameInitial/$lastNamePrefix$firstNamePrefix" + "01.html";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var document = parse(response.body);

        // Extract Player Stats (Adjust selectors based on actual site)
        // Convert the stats to double before returning them
      var points = double.tryParse(document.querySelector('td[data-stat="pts_per_g"]')?.text ?? "0") ?? 0.0;
      var rebounds = double.tryParse(document.querySelector("#per_game .trb_per_g")?.text ?? "0") ?? 0.0;
      var assists = double.tryParse(document.querySelector("#per_game .ast_per_g")?.text ?? "0") ?? 0.0;

      return {
        "name": playerName,
        "points": points,
        "rebounds": rebounds,
        "assists": assists,
      };

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
