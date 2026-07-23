// Models for the Parent Actions module.

String _avatarUrl(dynamic node) {
  // The API spells it "avater" in /parent/children and "avatar" elsewhere.
  final a = node is Map ? (node['avatar'] ?? node['avater']) : null;
  return a is Map ? (a['url']?.toString() ?? '') : '';
}

int _toInt(dynamic v) => v is num ? v.toInt() : (int.tryParse('$v') ?? 0);

/// One entry of `GET parent/children` → `results[]`.
class ChildSummary {
  final String childId;
  final String name;
  final int age;
  final String avatarUrl;
  final int totalPoints;

  const ChildSummary({
    required this.childId,
    required this.name,
    required this.age,
    required this.avatarUrl,
    required this.totalPoints,
  });

  factory ChildSummary.fromJson(Map<String, dynamic> json) => ChildSummary(
        childId: (json['childId'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        age: _toInt(json['age']),
        avatarUrl: _avatarUrl(json),
        totalPoints: _toInt(json['totalPoints']),
      );
}

/// `GET parent/:id/details` → `results`.
class ChildDetails {
  final String childId;
  final String name;
  final int age;
  final String avatarUrl;
  final int totalPoints;
  final int spentPoints;
  final ActivityEntry? latestActivity;
  final TaskStats taskStats;
  final AdjustAllowance? adjustAllowance;

  const ChildDetails({
    required this.childId,
    required this.name,
    required this.age,
    required this.avatarUrl,
    required this.totalPoints,
    required this.spentPoints,
    required this.latestActivity,
    required this.taskStats,
    this.adjustAllowance,
  });

  factory ChildDetails.fromJson(Map<String, dynamic> json) {
    final child = (json['child'] as Map?)?.cast<String, dynamic>() ?? const {};
    final activity =
        (json['latestActivity'] as Map?)?.cast<String, dynamic>();
    final stats = (json['taskStats'] as Map?)?.cast<String, dynamic>() ?? const {};
    final allowance =
        (json['adjustAllowance'] as Map?)?.cast<String, dynamic>();
    return ChildDetails(
      childId: (child['childId'] ?? '').toString(),
      name: (child['name'] ?? '').toString(),
      age: _toInt(child['age']),
      avatarUrl: _avatarUrl(child),
      totalPoints: _toInt(child['totalPoints']),
      spentPoints: _toInt(child['spentPoints']),
      latestActivity:
          activity == null ? null : ActivityEntry.fromJson(activity),
      taskStats: TaskStats.fromJson(stats),
      adjustAllowance:
          allowance == null ? null : AdjustAllowance.fromJson(allowance),
    );
  }
}

/// Daily manual points budget (add + remove combined) from `parent/:id/details`.
class AdjustAllowance {
  final int dailyLimit;
  final int usedToday;
  final int remainingToday;

  const AdjustAllowance({
    required this.dailyLimit,
    required this.usedToday,
    required this.remainingToday,
  });

  factory AdjustAllowance.fromJson(Map<String, dynamic> json) =>
      AdjustAllowance(
        dailyLimit: _toInt(json['dailyLimit']),
        usedToday: _toInt(json['usedToday']),
        remainingToday: _toInt(json['remainingToday']),
      );
}

class ActivityEntry {
  final String type;
  final String source;
  final int points;
  final String createdAt;

  const ActivityEntry({
    required this.type,
    required this.source,
    required this.points,
    required this.createdAt,
  });

  factory ActivityEntry.fromJson(Map<String, dynamic> json) => ActivityEntry(
        type: (json['type'] ?? '').toString(),
        source: (json['source'] ?? '').toString(),
        points: _toInt(json['points']),
        createdAt: (json['createdAt'] ?? '').toString(),
      );
}

class TaskStats {
  final int total;
  final int approved;
  final int rejected;
  final int pending;

  const TaskStats({
    required this.total,
    required this.approved,
    required this.rejected,
    required this.pending,
  });

  factory TaskStats.fromJson(Map<String, dynamic> json) => TaskStats(
        total: _toInt(json['total']),
        approved: _toInt(json['approved']),
        rejected: _toInt(json['rejected']),
        pending: _toInt(json['pending']),
      );
}

/// One row of `GET parent/:id/history` → `history.history[]`.
class HistoryEntry {
  final String id;
  final int points;
  final String type; // add | remove
  final String source; // manual | task | reward | avatar ...
  final String reason;
  final String createdAt;

  const HistoryEntry({
    required this.id,
    required this.points,
    required this.type,
    required this.source,
    required this.reason,
    required this.createdAt,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
        id: (json['_id'] ?? '').toString(),
        points: _toInt(json['points']),
        type: (json['type'] ?? '').toString(),
        source: (json['source'] ?? '').toString(),
        reason: (json['reason'] ?? '').toString(),
        createdAt: (json['createdAt'] ?? '').toString(),
      );
}

/// `POST parent/invite-code` → `results`.
class InviteCode {
  final String code;
  final String expiresAt;
  final int maxUses;
  final int usedCount;

  const InviteCode({
    required this.code,
    required this.expiresAt,
    required this.maxUses,
    required this.usedCount,
  });

  factory InviteCode.fromJson(Map<String, dynamic> json) => InviteCode(
        code: (json['code'] ?? '').toString(),
        expiresAt: (json['expiresAt'] ?? '').toString(),
        maxUses: _toInt(json['maxUses']),
        usedCount: _toInt(json['usedCount']),
      );
}
