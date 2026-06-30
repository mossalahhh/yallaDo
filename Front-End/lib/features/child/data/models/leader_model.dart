/// One entry of `GET child/top-children` → `top3[]`.
class LeaderModel {
  final String childId;
  final String name;
  final String avatarUrl;
  final int points;

  const LeaderModel({
    required this.childId,
    required this.name,
    required this.avatarUrl,
    required this.points,
  });

  factory LeaderModel.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'];
    return LeaderModel(
      childId: (json['childId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      avatarUrl: avatar is Map ? (avatar['url']?.toString() ?? '') : '',
      points: json['points'] is num ? (json['points'] as num).toInt() : 0,
    );
  }
}
