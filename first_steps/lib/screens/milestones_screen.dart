import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/milestone_provider.dart';
import '../services/milestone_service.dart';
import '../theme/app_theme.dart';
import 'record_screen.dart';

/// Milestones list screen showing all milestone templates grouped by age
/// Displays predefined milestone templates with completion status indicators
class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  /// Load milestone records from database
  Future<void> _loadRecords() async {
    await context.read<MilestoneProvider>().loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    // Get milestone templates grouped by age range
    final groupedTemplates = MilestoneService.getTemplatesGroupedByAge();

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイルストーン'),
      ),
      body: Consumer<MilestoneProvider>(
        builder: (context, milestoneProvider, _) {
          return RefreshIndicator(
            onRefresh: _loadRecords,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: groupedTemplates.length,
              itemBuilder: (context, index) {
                final ageRange = groupedTemplates.keys.elementAt(index);
                final templates = groupedTemplates[ageRange]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Age range header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                      child: Text(
                        ageRange,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),

                    // Milestone template cards
                    ...templates.map((template) {
                      // Check if this milestone has been recorded
                      final isRecorded = milestoneProvider
                          .isMilestoneRecorded(template.name);
                      final record = isRecorded
                          ? milestoneProvider.getRecordByName(template.name)
                          : null;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: InkWell(
                          onTap: () {
                            // Navigate to record screen with prefilled milestone info
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RecordScreen(
                                  prefilledMilestoneName: template.name,
                                  prefilledCategory: template.category,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Emoji icon with completion indicator
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isRecorded
                                        ? AppColors.accentColor.withOpacity(0.1)
                                        : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Center(
                                    child: Text(
                                      template.emoji,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Milestone name and completion date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        template.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      // Show achievement date if recorded
                                      if (isRecorded && record != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('yyyy/MM/dd')
                                              .format(record.achievedDate),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Completion status icon
                                Icon(
                                  isRecorded
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: isRecorded
                                      ? AppColors.success
                                      : AppColors.textSecondary,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
