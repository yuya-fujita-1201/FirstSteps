import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/child_provider.dart';
import '../providers/milestone_provider.dart';
import '../services/milestone_service.dart';
import '../models/milestone_record.dart';
import '../theme/app_theme.dart';
import 'record_screen.dart';

/// Home screen displaying child profile and recent milestones
/// Shows the child's profile information and the 3 most recent milestone achievements
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load child profile and milestone records from database
  Future<void> _loadData() async {
    final childProvider = context.read<ChildProvider>();
    final milestoneProvider = context.read<MilestoneProvider>();

    await Future.wait([
      childProvider.loadProfile(),
      milestoneProvider.loadRecords(),
    ]);
  }

  /// Get emoji for milestone based on its name
  String _getMilestoneEmoji(String milestoneName) {
    final template = MilestoneService.getAllTemplates().firstWhere(
      (t) => t.name == milestoneName,
      orElse: () => const MilestoneTemplate(
        name: '',
        category: '',
        minAgeMonths: 0,
        maxAgeMonths: 0,
        emoji: '⭐',
      ),
    );
    return template.emoji;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('はじめてメモ'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer2<ChildProvider, MilestoneProvider>(
          builder: (context, childProvider, milestoneProvider, _) {
            final profile = childProvider.profile;

            if (profile == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final recentRecords = milestoneProvider.getRecentRecords(limit: 3);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Child profile section
                  Container(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Profile photo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cardBackground,
                            border: Border.all(
                              color: AppColors.accentColor,
                              width: 2,
                            ),
                          ),
                          child: profile.photoPath != null
                              ? ClipOval(
                                  child: Image.file(
                                    File(profile.photoPath!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.textSecondary,
                                ),
                        ),
                        const SizedBox(width: 16),
                        // Name and age information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${profile.name} くん',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${DateFormat('yyyy年MM月dd日').format(profile.birthDate)} 生まれ (${profile.formattedAge})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Recent records section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '最近の記録',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Show empty state or recent milestones
                        if (recentRecords.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.stars_outlined,
                                    size: 64,
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'まだ記録がありません\n下のボタンから記録してみましょう',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          // Recent milestones in horizontal row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: recentRecords.map((record) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    children: [
                                      // Milestone icon with photo or emoji
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.cardBackground,
                                        ),
                                        child: record.photoPath != null
                                            ? ClipOval(
                                                child: Image.file(
                                                  File(record.photoPath!),
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Center(
                                                child: Text(
                                                  _getMilestoneEmoji(
                                                      record.milestoneName),
                                                  style: const TextStyle(
                                                    fontSize: 32,
                                                  ),
                                                ),
                                              ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Milestone name
                                      Text(
                                        record.milestoneName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      // Achievement date
                                      Text(
                                        DateFormat('yyyy/MM/dd')
                                            .format(record.achievedDate),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),

                  // Record button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RecordScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('記録する'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
