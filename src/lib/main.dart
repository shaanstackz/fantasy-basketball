import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/web_scraper.dart';
import 'models/player_stats.dart';


void main() {
  runApp(FantasyBasketballApp());
}

class FantasyBasketballApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeamAnalyzerScreen(),
    );
  }
}

class TeamAnalyzerScreen extends StatefulWidget {
  @override
  _TeamAnalyzerScreenState createState() => _TeamAnalyzerScreenState();
}

class _TeamAnalyzerScreenState extends State<TeamAnalyzerScreen> {
  final TextEditingController _playerController = TextEditingController();
  PlayerStats? _playerStats;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

void _analyzePlayer() async {
  setState(() {
    _isLoading = true;
  });

  final stats = await WebScraper().fetchPlayerStats(_playerController.text);

  setState(() {
    _isLoading = false;
    if (stats != null) {
      _playerStats = PlayerStats(
        name: stats["name"],
        points: stats["points"],
        rebounds: stats["rebounds"],
        assists: stats["assists"],
      );
    } else {
      _playerStats = null;
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fantasy Basketball Analyzer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _playerController,
              decoration: InputDecoration(
                labelText: "Enter Player Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzePlayer,
              child: Text("Analyze Player"),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : _playerStats != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${_playerStats!.name}"),
                          Text("Points: ${_playerStats!.points}"),
                          Text("Rebounds: ${_playerStats!.rebounds}"),
                          Text("Assists: ${_playerStats!.assists}"),
                        ],
                      )
                    : Text("No player data available"),
          ],
        ),
      ),
    );
  }
}
