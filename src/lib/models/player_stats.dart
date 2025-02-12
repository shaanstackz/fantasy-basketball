class PlayerStats {
  final String name;
  final double points;
  final double rebounds;
  final double assists;

  PlayerStats({
    required this.name,
    required this.points,
    required this.rebounds,
    required this.assists,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      name: json["name"] ?? "Unknown",
      points: json["points"]?.toDouble() ?? 0.0,
      rebounds: json["rebounds"]?.toDouble() ?? 0.0,
      assists: json["assists"]?.toDouble() ?? 0.0,
    );
  }
}
