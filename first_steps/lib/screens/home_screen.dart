import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/child_provider.dart';
import '../providers/milestone_provider.dart';
import '../providers/purchase_provider.dart';
import '../services/milestone_service.dart';
import '../models/milestone_record.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_ad_widget.dart';
import 'record_screen.dart';
import 'profile_registration_screen.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadData();
    });
  }

  /// Load child profile and milestone records from database
  Future<void> _loadData() async {
    final childProvider = context.read<ChildProvider>();
    final milestoneProvider = context.read<MilestoneProvider>();

    await Future.wait([
      childProvider.loadProfiles(),
      milestoneProvider.loadRecords(),
    ]);
  }

  /// Get icon path for milestone based on its name
  String _getMilestoneIconPath(String milestoneName) {
    final template = MilestoneService.getAllTemplates().firstWhere(
      (t) => t.name == milestoneName,
      orElse: () => MilestoneTemplate(
        name: '',
        category: '',
        minAgeMonths: 0,
        maxAgeMonths: 0,
        iconPath: MilestoneService.defaultIconPath,
      ),
    );
    return template.iconPath;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ChildProvider, MilestoneProvider, PurchaseProvider>(
      builder: (context, childProvider, milestoneProvider, purchaseProvider, _) {
        final profile = childProvider.currentChild;
        final entries = childProvider.profileEntries;
        final showChildSwitcher = entries.length > 1;
        final isPro = purchaseProvider.isPro;
        final recentRecords = milestoneProvider.getRecentRecords(limit: 3);

        return Scaffold(
          appBar: AppBar(
            title: const Text('はじめてメモ'),
            actions: [
              if (showChildSwitcher)
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: childProvider.currentChildKey,
                    onChanged: (value) {
                      if (value != null) {
                        childProvider.setCurrentChild(value);
                      }
                    },
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: AppColors.textPrimary),
                    items: entries
                        .map(
                          (entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (isPro)
                IconButton(
                  tooltip: '子供を追加',
                  icon: const Icon(Icons.person_add_alt),
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const ProfileRegistrationScreen(isAdding: true),
                          ),
                        )
                        .then((result) {
                          if (result == true) {
                            _loadData();
                          }
                        });
                  },
                ),
            ],
          ),
          body: profile == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Child profile section
                              Card(
                                margin: const EdgeInsets.all(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Profile photo - tappable to edit
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ProfileRegistrationScreen(
                                                        existingProfile:
                                                            profile,
                                                        existingProfileKey:
                                                            childProvider
                                                                .currentChildKey,
                                                      ),
                                                ),
                                              )
                                              .then((result) {
                                                if (result == true) {
                                                  _loadData();
                                                }
                                              });
                                        },
                                        child: Container(
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
                                          child:
                                              profile.photoPath != null &&
                                                  File(
                                                    profile.photoPath!,
                                                  ).existsSync()
                                              ? ClipOval(
                                                  child: Image.file(
                                                    File(profile.photoPath!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.person,
                                                  size: 40,
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Name and age information
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      // Recent milestones in vertical list
                                      Column(
                                        children: recentRecords.map((record) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        RecordScreen(
                                                          existingRecord:
                                                              record,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE0E0E0,
                                                    ),
                                                    width: 1,
                                                  ),
                                                ),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon on the left
                                                    Container(
                                                      width: 48,
                                                      height: 48,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: AppColors
                                                              .primaryColor,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          _getMilestoneIconPath(
                                                            record
                                                                .milestoneName,
                                                          ),
                                                          width: 24,
                                                          height: 24,
                                                          colorFilter:
                                                              const ColorFilter.mode(
                                                                AppColors
                                                                    .primaryColor,
                                                                BlendMode.srcIn,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    // Text content in the middle
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            record
                                                                .milestoneName,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .textPrimary,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                              'yyyy年M月d日',
                                                            ).format(
                                                              record
                                                                  .achievedDate,
                                                            ),
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              color: AppColors
                                                                  .textSecondary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Photo on the right
                                                    if (record.photoPath !=
                                                            null &&
                                                        File(
                                                          record.photoPath!,
                                                        ).existsSync())
                                                      Container(
                                                        width: 56,
                                                        height: 56,
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFF5F5F5,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          image: DecorationImage(
                                                            image: FileImage(
                                                              File(
                                                                record
                                                                    .photoPath!,
                                                              ),
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Container(
                                                        width: 56,
                                                        height: 56,
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFF5F5F5,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.image_outlined,
                                                          color: AppColors
                                                              .textSecondary,
                                                          size: 24,
                                                        ),
                                                      ),
                                                  ],
                                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
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
                        ),
                      ),
                    ),
                    // Ad banner at the bottom (above bottom navigation bar)
                    if (!isPro) const BannerAdWidget(),
                  ],
                ),
        );
      },
    );
  }
}
