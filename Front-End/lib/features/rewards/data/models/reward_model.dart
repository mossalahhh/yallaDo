/// Reward model for `GET reward/rewards` and the add/update responses.
class RewardModel {
  final String id;
  final String name;
  final String description;
  final int points;
  final int quantity;
  final bool isActive;
  final String imageUrl;

  const RewardModel({
    required this.id,
    required this.name,
    required this.description,
    required this.points,
    required this.quantity,
    required this.isActive,
    required this.imageUrl,
  });

  static int _toInt(dynamic v) =>
      v is num ? v.toInt() : (int.tryParse('$v') ?? 0);

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return RewardModel(
      id: (json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      points: _toInt(json['points']),
      quantity: _toInt(json['quantity']),
      isActive: json['isActive'] != false, // default true
      imageUrl: image is Map ? (image['url']?.toString() ?? '') : '',
    );
  }
}
