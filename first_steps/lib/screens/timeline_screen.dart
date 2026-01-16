import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/milestone_provider.dart';
import '../providers/child_provider.dart';
import '../providers/purchase_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/milestone_card.dart';
import '../widgets/shareable_milestone_card.dart';
import '../widgets/banner_ad_widget.dart';
import 'record_screen.dart';

/// Timeline screen displaying all milestone records chronologically
/// Allows users to view, edit, and share their recorded milestones
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadRecords();
    });
  }

  /// Load all milestone records from database
  Future<void> _loadRecords() async {
    await context.read<MilestoneProvider>().loadRecords();
  }

  /// Share milestone record as an image
  /// Captures the shareable card widget as an image and shares it via OS share sheet
  Future<void> _shareRecord(String recordId) async {
    try {
      final milestoneProvider = context.read<MilestoneProvider>();
      final childProvider = context.read<ChildProvider>();
      final record = milestoneProvider.getRecordById(recordId);
      final childName = childProvider.currentChild?.name ?? 'お子様';

      if (record == null) return;

      // Show loading dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Capture the shareable card as an image
      final image = await _screenshotController.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: ShareableMilestoneCard(
            record: record,
            childName: childName,
          ),
        ),
        delay: const Duration(milliseconds: 100),
      );

      // Save image to temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/milestone_${record.id}.png',
      ).create();
      await file.writeAsBytes(image);

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Share the image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '${record.milestoneName}\n${record.achievedDate.year}/${record.achievedDate.month}/${record.achievedDate.day}\n\n#はじめてメモ #FirstSteps',
      );
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('共有に失敗しました')),
        );
      }
    }
  }

  /// Navigate to record detail/edit screen
  void _navigateToRecordDetail(String recordId) {
    final milestoneProvider = context.read<MilestoneProvider>();
    final record = milestoneProvider.getRecordById(recordId);

    if (record != null) {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (_) => RecordScreen(existingRecord: record),
        ),
      )
          .then((result) {
        if (result == true) {
          _loadRecords();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイムライン'),
      ),
      body: Consumer2<MilestoneProvider, PurchaseProvider>(
        builder: (context, milestoneProvider, purchaseProvider, _) {
          final records = milestoneProvider.records;

          // Show empty state if no records
          if (records.isEmpty) {
            return RefreshIndicator(
              onRefresh: _loadRecords,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timeline_outlined,
                                size: 64,
                                color:
                                    AppColors.textSecondary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'まだ記録がありません\n「記録する」から追加してみましょう',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!purchaseProvider.isPro) const BannerAdWidget(),
                ],
              ),
            );
          }

          // Display records in a scrollable list
          return RefreshIndicator(
            onRefresh: _loadRecords,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return MilestoneCard(
                        record: record,
                        onTap: () => _navigateToRecordDetail(record.id),
                        onShare: () => _shareRecord(record.id),
                      );
                    },
                  ),
                ),
                if (!purchaseProvider.isPro) const BannerAdWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
