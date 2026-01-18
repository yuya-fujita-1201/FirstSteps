import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../models/child_profile.dart';
import '../models/milestone_record.dart';
import 'database_service.dart';

/// Service for Firebase backup and restore (Pro feature)
class BackupService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<User> _ensureSignedIn() async {
    final user = _auth.currentUser;
    if (user != null) return user;
    final credential = await _auth.signInAnonymously();
    return credential.user!;
  }

  /// Upload a photo to Firebase Storage
  /// Returns the download URL if successful, null otherwise
  static Future<String?> _uploadPhoto(
    String? filePath,
    String storagePath,
  ) async {
    if (filePath == null || filePath.isEmpty) {
      return null;
    }

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }

      final ref = _storage.ref().child(storagePath);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      // Log error but don't crash - photo upload is not critical
      debugPrint('Error uploading photo to Firebase Storage: $e');
      return null;
    }
  }

  /// Download a photo from Firebase Storage
  /// Returns the local file path if successful, null otherwise
  static Future<String?> _downloadPhoto(
    String? url,
    String fileName,
  ) async {
    if (url == null || url.isEmpty) {
      return null;
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final localPath = path.join(appDir.path, 'photos', fileName);
      final localFile = File(localPath);

      // Create directory if it doesn't exist
      await localFile.parent.create(recursive: true);

      // Download file from URL
      final ref = _storage.refFromURL(url);
      await ref.writeToFile(localFile);

      return localFile.path;
    } catch (e) {
      // Log error but don't crash - photo download is not critical
      debugPrint('Error downloading photo from Firebase Storage: $e');
      return null;
    }
  }

  static Future<void> backupToFirebase() async {
    final user = await _ensureSignedIn();
    final userDoc = _firestore.collection('users').doc(user.uid);

    final childBox = DatabaseService.getChildProfileBox();
    final recordBox = DatabaseService.getMilestoneRecordsBox();

    final childrenCollection = userDoc.collection('children');
    final recordsCollection = userDoc.collection('records');

    // Get existing cloud data to preserve photoUrls
    final existingChildren = await childrenCollection.get();
    final existingChildPhotoUrls = <int, String?>{};
    for (final doc in existingChildren.docs) {
      final data = doc.data();
      final childKey = (data['childKey'] as num?)?.toInt();
      final photoUrl = data['photoUrl'] as String?;
      if (childKey != null && photoUrl != null) {
        existingChildPhotoUrls[childKey] = photoUrl;
      }
    }

    final childrenBatch = _firestore.batch();
    for (final entry in childBox.toMap().entries) {
      final childKey = entry.key as int;
      final profile = entry.value;

      // Try to upload new photo, fallback to existing cloud URL
      String? photoUrl;
      if (profile.photoPath != null && profile.photoPath!.isNotEmpty) {
        photoUrl = await _uploadPhoto(
          profile.photoPath,
          'users/${user.uid}/children/$childKey.jpg',
        );
      }
      // If upload failed or no new photo, preserve existing cloud URL
      photoUrl ??= existingChildPhotoUrls[childKey];

      childrenBatch.set(childrenCollection.doc(childKey.toString()), {
        'name': profile.name,
        'birthDate': Timestamp.fromDate(profile.birthDate),
        'photoUrl': photoUrl,
        'createdAt': Timestamp.fromDate(profile.createdAt),
        'updatedAt': Timestamp.fromDate(profile.updatedAt),
        'childKey': childKey,
      });
    }
    await childrenBatch.commit();

    // Get existing record photo URLs
    final existingRecords = await recordsCollection.get();
    final existingRecordPhotoUrls = <String, String?>{};
    for (final doc in existingRecords.docs) {
      final data = doc.data();
      final recordId = data['id'] as String?;
      final photoUrl = data['photoUrl'] as String?;
      if (recordId != null && photoUrl != null) {
        existingRecordPhotoUrls[recordId] = photoUrl;
      }
    }

    final recordsBatch = _firestore.batch();
    for (final record in recordBox.values) {
      // Try to upload new photo, fallback to existing cloud URL
      String? photoUrl;
      if (record.photoPath != null && record.photoPath!.isNotEmpty) {
        photoUrl = await _uploadPhoto(
          record.photoPath,
          'users/${user.uid}/records/${record.id}.jpg',
        );
      }
      // If upload failed or no new photo, preserve existing cloud URL
      photoUrl ??= existingRecordPhotoUrls[record.id];

      recordsBatch.set(recordsCollection.doc(record.id), {
        'id': record.id,
        'milestoneName': record.milestoneName,
        'category': record.category,
        'achievedDate': Timestamp.fromDate(record.achievedDate),
        'photoUrl': photoUrl,
        'memo': record.memo,
        'createdAt': Timestamp.fromDate(record.createdAt),
        'updatedAt': Timestamp.fromDate(record.updatedAt),
        'ageInMonthsWhenAchieved': record.ageInMonthsWhenAchieved,
        'childKey': record.childKey,
      });
    }
    await recordsBatch.commit();
  }

  static Future<void> restoreFromFirebase() async {
    final user = await _ensureSignedIn();
    final userDoc = _firestore.collection('users').doc(user.uid);

    final childrenSnapshot = await userDoc.collection('children').get();
    final recordsSnapshot = await userDoc.collection('records').get();

    final childBox = DatabaseService.getChildProfileBox();
    final recordBox = DatabaseService.getMilestoneRecordsBox();

    await childBox.clear();
    await recordBox.clear();

    final Map<int, int> childKeyMap = {};

    for (final doc in childrenSnapshot.docs) {
      final data = doc.data();
      final originalKey = (data['childKey'] as num?)?.toInt() ??
          int.tryParse(doc.id) ??
          0;

      // Download photo from cloud storage
      final photoPath = await _downloadPhoto(
        data['photoUrl'] as String?,
        'child_${doc.id}.jpg',
      );

      final profile = ChildProfile(
        name: data['name'] as String? ?? '',
        birthDate: (data['birthDate'] as Timestamp?)?.toDate() ??
            DateTime.now(),
        photoPath: photoPath,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
            DateTime.now(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ??
            DateTime.now(),
      );

      final newKey = await childBox.add(profile);
      childKeyMap[originalKey] = newKey;
    }

    for (final doc in recordsSnapshot.docs) {
      final data = doc.data();
      final originalChildKey = (data['childKey'] as num?)?.toInt() ?? 0;
      final mappedChildKey = childKeyMap[originalChildKey] ?? originalChildKey;
      final recordId = data['id'] as String? ?? doc.id;

      // Download photo from cloud storage
      final photoPath = await _downloadPhoto(
        data['photoUrl'] as String?,
        'record_${doc.id}.jpg',
      );

      final record = MilestoneRecord(
        id: recordId,
        milestoneName: data['milestoneName'] as String? ?? '',
        category: data['category'] as String? ?? '記録',
        achievedDate: (data['achievedDate'] as Timestamp?)?.toDate() ??
            DateTime.now(),
        photoPath: photoPath,
        memo: data['memo'] as String?,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        ageInMonthsWhenAchieved:
            (data['ageInMonthsWhenAchieved'] as num?)?.toInt() ?? 0,
        childKey: mappedChildKey,
      );

      await recordBox.put(record.id, record);
    }

    if (childKeyMap.isNotEmpty) {
      final firstKey = childKeyMap.values.first;
      await DatabaseService.setCurrentChildKey(firstKey);
    }
  }
}

