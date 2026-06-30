/// Models for the parent analytics / Track-Behavior screen.

int _toInt(dynamic v) => v is num ? v.toInt() : (int.tryParse('$v') ?? 0);

/// `parent/progress-completion` → `data[]`.
class ChildProgress {
  final String childId;
  final String childName;
  final int approvedPercentage;

  const ChildProgress({
    required this.childId,
    required this.childName,
    required this.approvedPercentage,
  });

  factory ChildProgress.fromJson(Map<String, dynamic> json) => ChildProgress(
        childId: (json['_id'] ?? '').toString(),
        childName: (json['childName'] ?? '').toString(),
        approvedPercentage: _toInt(json['approvedPercentage']),
      );
}

/// `parent/category-completion` → `stats[]`.
class CategoryCompletion {
  final String category;
  final int completionRate;

  const CategoryCompletion({
    required this.category,
    required this.completionRate,
  });

  factory CategoryCompletion.fromJson(Map<String, dynamic> json) =>
      CategoryCompletion(
        category: (json['category'] ?? '').toString(),
        completionRate: _toInt(json['completionRate']),
      );
}

/// `parent/analytics-points` → `results[]`.
class PointsPoint {
  final String date;
  final int points;

  const PointsPoint({required this.date, required this.points});

  factory PointsPoint.fromJson(Map<String, dynamic> json) => PointsPoint(
        date: (json['date'] ?? '').toString(),
        points: _toInt(json['points']),
      );
}
