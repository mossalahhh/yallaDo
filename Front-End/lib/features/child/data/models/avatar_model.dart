/// One entry of `GET child/avatars` → `avatars[]`.
class AvatarModel {
  final String avatarId;
  final String title;
  final String imageUrl;
  final int pointsRequired;
  final bool isDefault;
  final String status; // unlocked | locked | selected

  const AvatarModel({
    required this.avatarId,
    required this.title,
    required this.imageUrl,
    required this.pointsRequired,
    required this.isDefault,
    required this.status,
  });

  bool get isLocked => status == 'locked';
  bool get isSelected => status == 'selected';

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return AvatarModel(
      avatarId: (json['avatarId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      imageUrl: image is Map ? (image['url']?.toString() ?? '') : '',
      pointsRequired:
          json['pointsRequired'] is num ? (json['pointsRequired'] as num).toInt() : 0,
      isDefault: json['isDefault'] == true,
      status: (json['status'] ?? 'locked').toString(),
    );
  }
}
