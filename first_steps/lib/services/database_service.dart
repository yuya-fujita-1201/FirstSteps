import 'package:hive/hive.dart';
import '../models/child_profile.dart';
import '../models/milestone_record.dart';

/// Database service for managing Hive boxes
class DatabaseService {
  static const String childProfileBoxName = 'child_profile';
  static const String milestoneRecordsBoxName = 'milestone_records';
  static const String appSettingsBoxName = 'app_settings';
  static const String currentChildKeySetting = 'current_child_key';

  /// Initialize all Hive boxes
  static Future<void> initialize() async {
    try {
      await Hive.openBox<ChildProfile>(childProfileBoxName);
      await Hive.openBox<MilestoneRecord>(milestoneRecordsBoxName);
      await Hive.openBox(appSettingsBoxName);
    } catch (e) {
      rethrow;
    }
  }

  /// Get child profile box
  static Box<ChildProfile> getChildProfileBox() {
    try {
      return Hive.box<ChildProfile>(childProfileBoxName);
    } catch (e) {
      rethrow;
    }
  }

  /// Get milestone records box
  static Box<MilestoneRecord> getMilestoneRecordsBox() {
    try {
      return Hive.box<MilestoneRecord>(milestoneRecordsBoxName);
    } catch (e) {
      rethrow;
    }
  }

  /// Get app settings box
  static Box<dynamic> getAppSettingsBox() {
    try {
      return Hive.box(appSettingsBoxName);
    } catch (e) {
      rethrow;
    }
  }

  /// Get all child profiles with their Hive keys
  static Map<int, ChildProfile> getChildProfilesWithKeys() {
    try {
      final box = getChildProfileBox();
      return box.toMap().map(
            (key, value) => MapEntry(key as int, value),
          );
    } catch (e) {
      rethrow;
    }
  }

  /// Add new child profile and return its key
  static Future<int> addChildProfile(ChildProfile profile) async {
    try {
      final box = getChildProfileBox();
      final key = await box.add(profile);
      return key;
    } catch (e) {
      rethrow;
    }
  }

  /// Update existing child profile
  static Future<void> updateChildProfile(int key, ChildProfile profile) async {
    try {
      final box = getChildProfileBox();
      await box.put(key, profile);
    } catch (e) {
      rethrow;
    }
  }

  /// Get current child key from settings
  static int? getCurrentChildKey() {
    try {
      final box = getAppSettingsBox();
      return box.get(currentChildKeySetting) as int?;
    } catch (e) {
      rethrow;
    }
  }

  /// Save current child key to settings
  static Future<void> setCurrentChildKey(int key) async {
    try {
      final box = getAppSettingsBox();
      await box.put(currentChildKeySetting, key);
    } catch (e) {
      rethrow;
    }
  }

  /// Save milestone record
  static Future<void> saveMilestoneRecord(MilestoneRecord record) async {
    try {
      final box = getMilestoneRecordsBox();
      await box.put(record.id, record);
    } catch (e) {
      rethrow;
    }
  }

  /// Get all milestone records sorted by achieved date (descending)
  static List<MilestoneRecord> getAllMilestoneRecords() {
    try {
      final box = getMilestoneRecordsBox();
      final records = box.values.toList();
      records.sort((a, b) => b.achievedDate.compareTo(a.achievedDate));
      return records;
    } catch (e) {
      rethrow;
    }
  }

  /// Get recent milestone records (limit)
  static List<MilestoneRecord> getRecentMilestoneRecords({int limit = 3}) {
    try {
      final allRecords = getAllMilestoneRecords();
      return allRecords.take(limit).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get milestone record by ID
  static MilestoneRecord? getMilestoneRecordById(String id) {
    try {
      final box = getMilestoneRecordsBox();
      return box.get(id);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete milestone record
  static Future<void> deleteMilestoneRecord(String id) async {
    try {
      final box = getMilestoneRecordsBox();
      await box.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  /// Update milestone record
  static Future<void> updateMilestoneRecord(MilestoneRecord record) async {
    try {
      await saveMilestoneRecord(record);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if milestone is already recorded
  static bool isMilestoneRecorded(String milestoneName) {
    try {
      final box = getMilestoneRecordsBox();
      return box.values.any((record) => record.milestoneName == milestoneName);
    } catch (e) {
      rethrow;
    }
  }

  /// Get milestone record by name
  static MilestoneRecord? getMilestoneRecordByName(String milestoneName) {
    try {
      final box = getMilestoneRecordsBox();
      try {
        return box.values
            .firstWhere((record) => record.milestoneName == milestoneName);
      } catch (e) {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
