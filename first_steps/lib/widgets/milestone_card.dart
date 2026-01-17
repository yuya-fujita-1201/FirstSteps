import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/milestone_record.dart';
import '../theme/app_theme.dart';

/// Card widget for displaying a milestone record
class MilestoneCard extends StatelessWidget {
  final MilestoneRecord record;
  final VoidCallback? onTap;
  final VoidCallback? onShare;

  const MilestoneCard({
    super.key,
    required this.record,
    this.onTap,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Category badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      record.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Date
                  Text(
                    DateFormat('yyyy/MM/dd').format(record.achievedDate),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Milestone name
              Text(
                record.milestoneName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              // Photo (if exists)
              if (record.photoPath != null &&
                  File(record.photoPath!).existsSync()) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(record.photoPath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              // Memo (if exists)
              if (record.memo != null && record.memo!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  record.memo!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],

              // Share button
              if (onShare != null) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onShare,
                    icon: const Icon(
                      Icons.share,
                      size: 18,
                    ),
                    label: const Text('共有'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
