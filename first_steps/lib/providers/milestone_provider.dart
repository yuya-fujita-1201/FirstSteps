import 'package:flutter/foundation.dart';
import '../models/milestone_record.dart';
import '../services/database_service.dart';

/// Provider for managing milestone records state
class MilestoneProvider extends ChangeNotifier {
  List<MilestoneRecord> _records = [];
  int? _currentChildKey;

  List<MilestoneRecord> get records {
    if (_currentChildKey == null) {
      return _records;
    }
    return _records
        .where((record) => record.childKey == _currentChildKey)
        .toList();
  }

  int? get currentChildKey => _currentChildKey;

  void updateCurrentChildKey(int? key) {
    if (_currentChildKey == key) return;
    _currentChildKey = key;
    notifyListeners();
  }

  /// Load all milestone records from database
  Future<void> loadRecords() async {
    _records = DatabaseService.getAllMilestoneRecords();
    notifyListeners();
  }

  /// Get recent records (limited)
  List<MilestoneRecord> getRecentRecords({int limit = 3}) {
    return records.take(limit).toList();
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
      return records.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if milestone is already recorded
  bool isMilestoneRecorded(String milestoneName) {
    return records.any((record) => record.milestoneName == milestoneName);
  }

  /// Get milestone record by name
  MilestoneRecord? getRecordByName(String milestoneName) {
    try {
      return records
          .firstWhere((record) => record.milestoneName == milestoneName);
    } catch (e) {
      return null;
    }
  }

  /// Get records grouped by month
  Map<String, List<MilestoneRecord>> getRecordsGroupedByMonth() {
    final Map<String, List<MilestoneRecord>> grouped = {};

    for (var record in records) {
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
