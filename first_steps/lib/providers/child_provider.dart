import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../services/database_service.dart';

/// Provider for managing child profile state
class ChildProvider extends ChangeNotifier {
  ChildProfile? _profile;

  ChildProfile? get profile => _profile;

  /// Load child profile from database
  Future<void> loadProfile() async {
    _profile = DatabaseService.getChildProfile();
    notifyListeners();
  }

  /// Save or update child profile
  Future<void> saveProfile(ChildProfile profile) async {
    await DatabaseService.saveChildProfile(profile);
    _profile = profile;
    notifyListeners();
  }

  /// Update profile photo
  Future<void> updatePhoto(String photoPath) async {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      photoPath: photoPath,
      updatedAt: DateTime.now(),
    );

    await saveProfile(updatedProfile);
  }

  /// Update profile name
  Future<void> updateName(String name) async {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      name: name,
      updatedAt: DateTime.now(),
    );

    await saveProfile(updatedProfile);
  }

  /// Update profile birth date
  Future<void> updateBirthDate(DateTime birthDate) async {
    if (_profile == null) return;

    final updatedProfile = _profile!.copyWith(
      birthDate: birthDate,
      updatedAt: DateTime.now(),
    );

    await saveProfile(updatedProfile);
  }

  /// Check if profile exists
  bool get hasProfile => _profile != null;
}
