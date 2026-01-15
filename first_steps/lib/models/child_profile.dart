import 'package:hive/hive.dart';

part 'child_profile.g.dart';

/// Child profile model
@HiveType(typeId: 0)
class ChildProfile extends HiveObject {
  /// Child's name or nickname
  @HiveField(0)
  String name;

  /// Child's birth date
  @HiveField(1)
  DateTime birthDate;

  /// Profile photo path (optional)
  @HiveField(2)
  String? photoPath;

  /// Created timestamp
  @HiveField(3)
  DateTime createdAt;

  /// Updated timestamp
  @HiveField(4)
  DateTime updatedAt;

  ChildProfile({
    required this.name,
    required this.birthDate,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate age in months from birth date
  int get ageInMonths {
    final now = DateTime.now();
    final months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;
    return months;
  }

  /// Calculate age in days
  int get ageInDays {
    final now = DateTime.now();
    return now.difference(birthDate).inDays;
  }

  /// Get formatted age string (e.g., "3ヶ月", "1歳2ヶ月")
  String get formattedAge {
    final months = ageInMonths;
    if (months < 12) {
      return '$months ヶ月';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years 歳';
      } else {
        return '$years 歳 $remainingMonths ヶ月';
      }
    }
  }

  /// Copy with method for updating fields
  ChildProfile copyWith({
    String? name,
    DateTime? birthDate,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
