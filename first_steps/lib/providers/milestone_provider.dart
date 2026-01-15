import 'package:flutter/foundation.dart';
import '../models/milestone_record.dart';
import '../services/database_service.dart';

/// Provider for managing milestone records state
class MilestoneProvider extends ChangeNotifier {
  List<MilestoneRecord> _records = [];

  List<MilestoneRecord> get records => _records;

  /// Load all milestone records from database
  Future<void> loadRecords() async {
    _records = DatabaseService.getAllMilestoneRecords();
    notifyListeners();
  }

  /// Get recent records (limited)
  List<MilestoneRecord> getRecentRecords({int limit = 3}) {
    return _records.take(limit).toList();
  }

  /// Save new milestone record
  Future<void> saveRecord(MilestoneRecord record) async {
    await DatabaseService.saveMilestoneRecord(record);
    await loadRecords();
  }

  /// Update existing milestone record
  Future<void> updateRecord(MilestoneRecord record) async {
    await DatabaseService.updateMilestoneRecord(record);
    await loadRecords();
  }

  /// Delete milestone record
  Future<void> deleteRecord(String id) async {
    await DatabaseService.deleteMilestoneRecord(id);
    await loadRecords();
  }

  /// Get milestone record by ID
  MilestoneRecord? getRecordById(String id) {
    try {
      return _records.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if milestone is already recorded
  bool isMilestoneRecorded(String milestoneName) {
    return _records.any((record) => record.milestoneName == milestoneName);
  }

  /// Get milestone record by name
  MilestoneRecord? getRecordByName(String milestoneName) {
    try {
      return _records
          .firstWhere((record) => record.milestoneName == milestoneName);
    } catch (e) {
      return null;
    }
  }

  /// Get records grouped by month
  Map<String, List<MilestoneRecord>> getRecordsGroupedByMonth() {
    final Map<String, List<MilestoneRecord>> grouped = {};

    for (var record in _records) {
      final monthKey =
          '${record.achievedDate.year}年${record.achievedDate.month}月';
      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(record);
    }

    return grouped;
  }
}
