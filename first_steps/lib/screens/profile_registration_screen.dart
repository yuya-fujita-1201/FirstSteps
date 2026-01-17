import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/child_profile.dart';
import '../providers/child_provider.dart';
import '../services/image_optimizer.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

/// Profile registration screen (shown on first launch)
class ProfileRegistrationScreen extends StatefulWidget {
  final bool isAdding;
  final ChildProfile? existingProfile;
  final int? existingProfileKey;

  const ProfileRegistrationScreen({
    super.key,
    this.isAdding = false,
    this.existingProfile,
    this.existingProfileKey,
  });

  @override
  State<ProfileRegistrationScreen> createState() =>
      _ProfileRegistrationScreenState();
}

class _ProfileRegistrationScreenState extends State<ProfileRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  String? _photoPath;
  final _imagePicker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize fields with existing profile data if editing
    if (widget.existingProfile != null) {
      _nameController.text = widget.existingProfile!.name;
      _birthDate = widget.existingProfile!.birthDate;
      _photoPath = widget.existingProfile!.photoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 30)),
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
        _birthDate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('生年月日を選択してください')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final childProvider = context.read<ChildProvider>();

      // Check if we're editing an existing profile
      if (widget.existingProfile != null && widget.existingProfileKey != null) {
        // Update existing profile
        final currentProfile = childProvider.currentChild;
        if (currentProfile != null) {
          // Update name if changed
          if (currentProfile.name != _nameController.text.trim()) {
            await childProvider.updateName(_nameController.text.trim());
          }
          // Update birth date if changed
          if (currentProfile.birthDate != _birthDate!) {
            await childProvider.updateBirthDate(_birthDate!);
          }
          // Update photo if changed
          if (currentProfile.photoPath != _photoPath) {
            if (_photoPath != null) {
              await childProvider.updatePhoto(_photoPath!);
            }
          }
        }
      } else {
        // Add new profile
        final profile = ChildProfile(
          name: _nameController.text.trim(),
          birthDate: _birthDate!,
          photoPath: _photoPath,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await childProvider.addProfile(profile);
      }

      if (mounted) {
        if (widget.isAdding || widget.existingProfile != null) {
          Navigator.of(context).pop(true);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
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
        title: Text(
          widget.existingProfile != null
              ? 'プロフィール編集'
              : (widget.isAdding ? '子供を追加' : 'プロフィール登録'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'お子様の情報を入力してください',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Profile photo
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cardBackground,
                        border: Border.all(
                          color: AppColors.accentColor,
                          width: 2,
                        ),
                      ),
                      child: _photoPath != null &&
                              File(_photoPath!).existsSync()
                          ? ClipOval(
                              child: Image.file(
                                File(_photoPath!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.add_a_photo_outlined,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '写真を追加（任意）',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'お名前（ニックネーム可）',
                    hintText: '例：ゆうちゃん',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '名前を入力してください';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Birth date field
                InkWell(
                  onTap: _selectBirthDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '生年月日',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _birthDate != null
                          ? DateFormat('yyyy年MM月dd日').format(_birthDate!)
                          : '選択してください',
                      style: TextStyle(
                        color: _birthDate != null
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
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
                      : Text(
                          widget.existingProfile != null
                              ? '保存する'
                              : (widget.isAdding ? '追加する' : '登録する'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
