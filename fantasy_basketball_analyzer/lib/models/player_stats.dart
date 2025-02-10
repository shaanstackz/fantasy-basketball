class PlayerStats {
  final String name;
  final double points;
  final double rebounds;
  final double assists;

  PlayerStats({required this.name, required this.points, required this.rebounds, required this.assists});

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      name: json['name'],
      points: json['points'].toDouble(),
      rebounds: json['rebounds'].toDouble(),
      assists: json['assists'].toDouble(),
    );
  }
}
