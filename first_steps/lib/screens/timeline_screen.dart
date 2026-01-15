import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/milestone_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/milestone_card.dart';
import 'record_screen.dart';

/// Timeline screen displaying all milestone records
class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    await context.read<MilestoneProvider>().loadRecords();
  }

  Future<void> _shareRecord(String recordId) async {
    try {
      final milestoneProvider = context.read<MilestoneProvider>();
      final record = milestoneProvider.getRecordById(recordId);

      if (record == null) return;

      // For MVP, share text. Image sharing can be enhanced later.
      final text = '''
${record.milestoneName}
達成日: ${record.achievedDate.year}/${record.achievedDate.month}/${record.achievedDate.day}
${record.memo != null && record.memo!.isNotEmpty ? '\n${record.memo}' : ''}

#はじめてメモ #FirstSteps
''';

      await Share.share(text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('共有に失敗しました')),
        );
      }
    }
  }

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
      body: Consumer<MilestoneProvider>(
        builder: (context, milestoneProvider, _) {
          final records = milestoneProvider.records;

          if (records.isEmpty) {
            return RefreshIndicator(
              onRefresh: _loadRecords,
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
                          color: AppColors.textSecondary.withOpacity(0.5),
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
            );
          }

          return RefreshIndicator(
            onRefresh: _loadRecords,
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
          );
        },
      ),
    );
  }
}
