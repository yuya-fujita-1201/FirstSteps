import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/child_provider.dart';
import '../providers/milestone_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/milestone_card.dart';
import 'record_screen.dart';

/// Home screen displaying child profile and recent milestones
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

  Future<void> _loadData() async {
    final childProvider = context.read<ChildProvider>();
    final milestoneProvider = context.read<MilestoneProvider>();

    await Future.wait([
      childProvider.loadProfile(),
      milestoneProvider.loadRecords(),
    ]);
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
                        // Name and age
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
                                        .withOpacity(0.5),
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
                          ...recentRecords.map(
                            (record) => MilestoneCard(
                              record: record,
                              onTap: () {
                                // Navigate to record detail (can be implemented later)
                              },
                            ),
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
