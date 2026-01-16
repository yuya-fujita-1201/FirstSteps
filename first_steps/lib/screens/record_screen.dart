import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/milestone_record.dart';
import '../providers/milestone_provider.dart';
import '../providers/child_provider.dart';
import '../providers/purchase_provider.dart';
import '../services/ad_service.dart';
import '../services/image_optimizer.dart';
import '../theme/app_theme.dart';

/// Record screen for creating/editing milestone records
class RecordScreen extends StatefulWidget {
  final MilestoneRecord? existingRecord;
  final String? prefilledMilestoneName;
  final String? prefilledCategory;

  const RecordScreen({
    super.key,
    this.existingRecord,
    this.prefilledMilestoneName,
    this.prefilledCategory,
  });

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _milestoneNameController = TextEditingController();
  final _memoController = TextEditingController();
  DateTime _achievedDate = DateTime.now();
  String? _photoPath;
  final _imagePicker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.existingRecord != null) {
      // Edit mode
      final record = widget.existingRecord!;
      _milestoneNameController.text = record.milestoneName;
      _memoController.text = record.memo ?? '';
      _achievedDate = record.achievedDate;
      _photoPath = record.photoPath;
    } else if (widget.prefilledMilestoneName != null) {
      // Create mode with prefilled name
      _milestoneNameController.text = widget.prefilledMilestoneName!;
    }
  }

  @override
  void dispose() {
    _milestoneNameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        final optimizedPath = await ImageOptimizer.optimizeAndSave(image.path);
        setState(() {
          _photoPath = optimizedPath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('処理に失敗しました。もう一度お試しください。')),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _achievedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('ja'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.accentColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _achievedDate = picked;
      });
    }
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final childProvider = context.read<ChildProvider>();
      final milestoneProvider = context.read<MilestoneProvider>();
      final profile = childProvider.currentChild;
      final childKey = childProvider.currentChildKey;

      if (profile == null || childKey == null) {
        throw Exception('Child profile not found');
      }

      // Calculate age in months when achieved
      final ageInMonths =
          (_achievedDate.year - profile.birthDate.year) * 12 +
              _achievedDate.month -
              profile.birthDate.month;

      final record = MilestoneRecord(
        id: widget.existingRecord?.id ??
            'milestone_${DateTime.now().millisecondsSinceEpoch}',
        milestoneName: _milestoneNameController.text.trim(),
        category: widget.prefilledCategory ?? '記録',
        achievedDate: _achievedDate,
        photoPath: _photoPath,
        memo: _memoController.text.trim().isEmpty
            ? null
            : _memoController.text.trim(),
        createdAt: widget.existingRecord?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        ageInMonthsWhenAchieved: ageInMonths,
        childKey: childKey,
      );

      if (widget.existingRecord != null) {
        await milestoneProvider.updateRecord(record);
      } else {
        await milestoneProvider.saveRecord(record);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('記録を保存しました')),
        );
        final purchaseProvider = context.read<PurchaseProvider>();
        if (!purchaseProvider.isPro) {
          AdService().showInterstitialAd();
        }
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('処理に失敗しました。もう一度お試しください。')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingRecord != null ? '記録を編集' : '記録する'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Milestone name
                TextFormField(
                  controller: _milestoneNameController,
                  decoration: const InputDecoration(
                    labelText: 'マイルストーン名',
                    hintText: '例：初めての笑顔',
                    prefixIcon: Icon(Icons.stars_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'マイルストーン名を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Achieved date
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '達成日',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      DateFormat('yyyy年MM月dd日').format(_achievedDate),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Photo picker
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accentColor.withValues(alpha: 0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: _photoPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_photoPath!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 48,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '写真を追加（任意）',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Memo field
                TextFormField(
                  controller: _memoController,
                  decoration: const InputDecoration(
                    labelText: 'メモ（任意）',
                    hintText: '思い出や様子を記録しましょう（140字まで）',
                    prefixIcon: Icon(Icons.edit_note_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  maxLength: 140,
                ),
                const SizedBox(height: 32),

                // Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveRecord,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('保存する'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
