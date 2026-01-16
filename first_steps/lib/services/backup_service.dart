import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  static Future<String?> _uploadPhoto(String? filePath, String storagePath) async {
    if (filePath == null) return null;
    final file = File(filePath);
    if (!await file.exists()) return null;
    final ref = _storage.ref().child(storagePath);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  static Future<String?> _downloadPhoto(String? url, String fileName) async {
    if (url == null) return null;
    final ref = _storage.refFromURL(url);
    final directory = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(directory.path, 'images'));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final filePath = path.join(imagesDir.path, fileName);
    final file = File(filePath);
    await ref.writeToFile(file);
    return filePath;
  }

  static Future<void> backupToFirebase() async {
    final user = await _ensureSignedIn();
    final userDoc = _firestore.collection('users').doc(user.uid);

    final childBox = DatabaseService.getChildProfileBox();
    final recordBox = DatabaseService.getMilestoneRecordsBox();

    final childrenCollection = userDoc.collection('children');
    final recordsCollection = userDoc.collection('records');

    final childrenBatch = _firestore.batch();
    for (final entry in childBox.toMap().entries) {
      final childKey = entry.key as int;
      final profile = entry.value as ChildProfile;
      final photoUrl = await _uploadPhoto(
        profile.photoPath,
        'users/${user.uid}/children/$childKey.jpg',
      );

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

    final recordsBatch = _firestore.batch();
    for (final record in recordBox.values) {
      final photoUrl = await _uploadPhoto(
        record.photoPath,
        'users/${user.uid}/records/${record.id}.jpg',
      );

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

      final newKey = await childBox.add(profile) as int;
      childKeyMap[originalKey] = newKey;
    }

    for (final doc in recordsSnapshot.docs) {
      final data = doc.data();
      final originalChildKey = (data['childKey'] as num?)?.toInt() ?? 0;
      final mappedChildKey = childKeyMap[originalChildKey] ?? originalChildKey;

      final photoPath = await _downloadPhoto(
        data['photoUrl'] as String?,
        'record_${doc.id}.jpg',
      );

      final record = MilestoneRecord(
        id: data['id'] as String? ?? doc.id,
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
