import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/child_provider.dart';
import '../providers/milestone_provider.dart';
import '../providers/purchase_provider.dart';
import '../services/milestone_service.dart';
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
          body: RefreshIndicator(
            onRefresh: _loadData,
            child: Builder(
              builder: (context) {
                if (profile == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final recentRecords =
                    milestoneProvider.getRecentRecords(limit: 3);

                return SingleChildScrollView(
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
                                      builder: (_) => ProfileRegistrationScreen(
                                        existingProfile: profile,
                                        existingProfileKey:
                                            childProvider.currentChildKey,
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
                                  child: profile.photoPath != null &&
                                          File(profile.photoPath!).existsSync()
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
                                children: recentRecords.map((record) {
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (_) =>
                                              RecordScreen(existingRecord: record),
                                        ));
                                      },
                                      child: Card(
                                        elevation: 0,
                                        color: const Color(0xFFF5F5F5),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 8.0,
                                          ),
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                _getMilestoneIconPath(
                                                  record.milestoneName,
                                                ),
                                                width: 32,
                                                height: 32,
                                                colorFilter: const ColorFilter.mode(
                                                  AppColors.primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                record.milestoneName,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                DateFormat('yyyy/MM/dd')
                                                    .format(record.achievedDate),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
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
                      if (!isPro) const BannerAdWidget(),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
