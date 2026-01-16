import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../services/database_service.dart';

/// Provider for managing child profile state
class ChildProvider extends ChangeNotifier {
  final Map<int, ChildProfile> _profilesByKey = {};
  int? _currentChildKey;

  List<ChildProfile> get profiles => _profilesByKey.values.toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  List<MapEntry<int, ChildProfile>> get profileEntries =>
      _profilesByKey.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));

  int? get currentChildKey => _currentChildKey;

  ChildProfile? get currentChild =>
      _currentChildKey != null ? _profilesByKey[_currentChildKey] : null;

  /// Load child profile from database
  Future<void> loadProfiles() async {
    final profilesWithKeys = DatabaseService.getChildProfilesWithKeys();
    _profilesByKey
      ..clear()
      ..addAll(profilesWithKeys);

    final storedKey = DatabaseService.getCurrentChildKey();
    if (storedKey != null && _profilesByKey.containsKey(storedKey)) {
      _currentChildKey = storedKey;
    } else if (_profilesByKey.isNotEmpty) {
      _currentChildKey = _profilesByKey.keys.first;
      await DatabaseService.setCurrentChildKey(_currentChildKey!);
    } else {
      _currentChildKey = null;
    }
    notifyListeners();
  }

  /// Add new child profile
  Future<void> addProfile(ChildProfile profile) async {
    final key = await DatabaseService.addChildProfile(profile);
    _profilesByKey[key] = profile;
    _currentChildKey = key;
    await DatabaseService.setCurrentChildKey(key);
    notifyListeners();
  }

  /// Update profile photo
  Future<void> updatePhoto(String photoPath) async {
    if (_currentChildKey == null) return;
    final currentProfile = _profilesByKey[_currentChildKey!];
    if (currentProfile == null) return;

    final updatedProfile = currentProfile.copyWith(
      photoPath: photoPath,
      updatedAt: DateTime.now(),
    );

    await DatabaseService.updateChildProfile(_currentChildKey!, updatedProfile);
    _profilesByKey[_currentChildKey!] = updatedProfile;
    notifyListeners();
  }

  /// Update profile name
  Future<void> updateName(String name) async {
    if (_currentChildKey == null) return;
    final currentProfile = _profilesByKey[_currentChildKey!];
    if (currentProfile == null) return;

    final updatedProfile = currentProfile.copyWith(
      name: name,
      updatedAt: DateTime.now(),
    );

    await DatabaseService.updateChildProfile(_currentChildKey!, updatedProfile);
    _profilesByKey[_currentChildKey!] = updatedProfile;
    notifyListeners();
  }

  /// Update profile birth date
  Future<void> updateBirthDate(DateTime birthDate) async {
    if (_currentChildKey == null) return;
    final currentProfile = _profilesByKey[_currentChildKey!];
    if (currentProfile == null) return;

    final updatedProfile = currentProfile.copyWith(
      birthDate: birthDate,
      updatedAt: DateTime.now(),
    );

    await DatabaseService.updateChildProfile(_currentChildKey!, updatedProfile);
    _profilesByKey[_currentChildKey!] = updatedProfile;
    notifyListeners();
  }

  /// Switch current child by key
  Future<void> setCurrentChild(int key) async {
    if (!_profilesByKey.containsKey(key)) return;
    _currentChildKey = key;
    await DatabaseService.setCurrentChildKey(key);
    notifyListeners();
  }

  /// Check if profile exists
  bool get hasProfile => _profilesByKey.isNotEmpty;
}
