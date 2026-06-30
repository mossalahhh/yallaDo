/// Models for `GET user/me`:
/// `{ success, profile: { _id, user:{...}, role, childrenCount?, parentNames? } }`
class UserProfile {
  final String id; // profile._id
  final UserInfo user;
  final String role;
  final int? childrenCount; // parents only
  final List<String> parentNames; // children only

  const UserProfile({
    required this.id,
    required this.user,
    required this.role,
    this.childrenCount,
    this.parentNames = const [],
  });

  bool get isParent => role == 'parent';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: (json['_id'] ?? '').toString(),
      user: UserInfo.fromJson(
          (json['user'] as Map?)?.cast<String, dynamic>() ?? const {}),
      role: (json['role'] ?? '').toString(),
      childrenCount: json['childrenCount'] is num
          ? (json['childrenCount'] as num).toInt()
          : null,
      parentNames: (json['parentNames'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

class UserInfo {
  final String id;
  final String userName;
  final String name;
  final String email;
  final String? avatarUrl;
  final int? age;

  const UserInfo({
    required this.id,
    required this.userName,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.age,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    final avatar = json['avatar'];
    return UserInfo(
      id: (json['_id'] ?? '').toString(),
      userName: (json['userName'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      avatarUrl: avatar is Map ? avatar['url']?.toString() : null,
      age: json['age'] is num ? (json['age'] as num).toInt() : null,
    );
  }
}
