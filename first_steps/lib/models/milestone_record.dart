import 'package:hive/hive.dart';

part 'milestone_record.g.dart';

/// Milestone record model
@HiveType(typeId: 1)
class MilestoneRecord extends HiveObject {
  /// Unique identifier
  @HiveField(0)
  String id;

  /// Milestone name (e.g., "初めての笑顔", "首すわり")
  @HiveField(1)
  String milestoneName;

  /// Milestone category/type
  @HiveField(2)
  String category;

  /// Achievement date
  @HiveField(3)
  DateTime achievedDate;

  /// Photo path (optional)
  @HiveField(4)
  String? photoPath;

  /// Memo/note (optional, up to 140 characters)
  @HiveField(5)
  String? memo;

  /// Created timestamp
  @HiveField(6)
  DateTime createdAt;

  /// Updated timestamp
  @HiveField(7)
  DateTime updatedAt;

  /// Child's age in months when achieved (for sorting/filtering)
  @HiveField(8)
  int ageInMonthsWhenAchieved;

  /// Child profile key (Hive key) for multi-child support
  @HiveField(9)
  int childKey;

  MilestoneRecord({
    required this.id,
    required this.milestoneName,
    required this.category,
    required this.achievedDate,
    this.photoPath,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
    required this.ageInMonthsWhenAchieved,
    required this.childKey,
  });

  /// Copy with method for updating fields
  MilestoneRecord copyWith({
    String? id,
    String? milestoneName,
    String? category,
    DateTime? achievedDate,
    String? photoPath,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? ageInMonthsWhenAchieved,
    int? childKey,
  }) {
    return MilestoneRecord(
      id: id ?? this.id,
      milestoneName: milestoneName ?? this.milestoneName,
      category: category ?? this.category,
      achievedDate: achievedDate ?? this.achievedDate,
      photoPath: photoPath ?? this.photoPath,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ageInMonthsWhenAchieved:
          ageInMonthsWhenAchieved ?? this.ageInMonthsWhenAchieved,
      childKey: childKey ?? this.childKey,
    );
  }
}

/// Milestone template model (predefined milestones)
class MilestoneTemplate {
  final String name;
  final String category;
  final int minAgeMonths;
  final int maxAgeMonths;
  final String iconPath;

  const MilestoneTemplate({
    required this.name,
    required this.category,
    required this.minAgeMonths,
    required this.maxAgeMonths,
    required this.iconPath,
  });
}
