import 'package:hive/hive.dart';
import '../models/child_profile.dart';
import '../models/milestone_record.dart';

/// Database service for managing Hive boxes
class DatabaseService {
  static const String childProfileBoxName = 'child_profile';
  static const String milestoneRecordsBoxName = 'milestone_records';

  /// Initialize all Hive boxes
  static Future<void> initialize() async {
    await Hive.openBox<ChildProfile>(childProfileBoxName);
    await Hive.openBox<MilestoneRecord>(milestoneRecordsBoxName);
  }

  /// Get child profile box
  static Box<ChildProfile> getChildProfileBox() {
    return Hive.box<ChildProfile>(childProfileBoxName);
  }

  /// Get milestone records box
  static Box<MilestoneRecord> getMilestoneRecordsBox() {
    return Hive.box<MilestoneRecord>(milestoneRecordsBoxName);
  }

  /// Save child profile
  static Future<void> saveChildProfile(ChildProfile profile) async {
    final box = getChildProfileBox();
    if (box.isEmpty) {
      await box.add(profile);
    } else {
      await box.putAt(0, profile);
    }
  }

  /// Get child profile (returns null if not exists)
  static ChildProfile? getChildProfile() {
    final box = getChildProfileBox();
    if (box.isEmpty) return null;
    return box.getAt(0);
  }

  /// Save milestone record
  static Future<void> saveMilestoneRecord(MilestoneRecord record) async {
    final box = getMilestoneRecordsBox();
    await box.put(record.id, record);
  }

  /// Get all milestone records sorted by achieved date (descending)
  static List<MilestoneRecord> getAllMilestoneRecords() {
    final box = getMilestoneRecordsBox();
    final records = box.values.toList();
    records.sort((a, b) => b.achievedDate.compareTo(a.achievedDate));
    return records;
  }

  /// Get recent milestone records (limit)
  static List<MilestoneRecord> getRecentMilestoneRecords({int limit = 3}) {
    final allRecords = getAllMilestoneRecords();
    return allRecords.take(limit).toList();
  }

  /// Get milestone record by ID
  static MilestoneRecord? getMilestoneRecordById(String id) {
    final box = getMilestoneRecordsBox();
    return box.get(id);
  }

  /// Delete milestone record
  static Future<void> deleteMilestoneRecord(String id) async {
    final box = getMilestoneRecordsBox();
    await box.delete(id);
  }

  /// Update milestone record
  static Future<void> updateMilestoneRecord(MilestoneRecord record) async {
    await saveMilestoneRecord(record);
  }

  /// Check if milestone is already recorded
  static bool isMilestoneRecorded(String milestoneName) {
    final box = getMilestoneRecordsBox();
    return box.values.any((record) => record.milestoneName == milestoneName);
  }

  /// Get milestone record by name
  static MilestoneRecord? getMilestoneRecordByName(String milestoneName) {
    final box = getMilestoneRecordsBox();
    try {
      return box.values
          .firstWhere((record) => record.milestoneName == milestoneName);
    } catch (e) {
      return null;
    }
  }
}
