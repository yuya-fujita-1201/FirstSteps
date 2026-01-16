import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/purchase_provider.dart';
import '../services/backup_service.dart';
import '../theme/app_theme.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handlePurchase(
    BuildContext context,
    PurchaseProvider provider,
  ) async {
    try {
      await provider.purchasePro();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pro版へのアップグレードが完了しました')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('処理に失敗しました。もう一度お試しください。')),
        );
      }
    }
  }

  Future<void> _handleBackup(BuildContext context) async {
    try {
      await BackupService.backupToFirebase();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('バックアップが完了しました')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('処理に失敗しました。もう一度お試しください。')),
        );
      }
    }
  }

  Future<void> _handleRestore(BuildContext context) async {
    try {
      await BackupService.restoreFromFirebase();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('復元が完了しました')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('処理に失敗しました。もう一度お試しください。')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final purchaseProvider = context.watch<PurchaseProvider>();
    final isPro = purchaseProvider.isPro;

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Pro version section
          _buildSectionHeader('Pro版'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                if (!isPro)
                  ListTile(
                    leading: const Icon(
                      Icons.workspace_premium,
                      color: AppColors.accentColor,
                    ),
                    title: const Text('Pro版にアップグレード'),
                    subtitle: const Text('広告非表示、複数の子供登録など'),
                    trailing: purchaseProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: purchaseProvider.isLoading
                        ? null
                        : () => _handlePurchase(context, purchaseProvider),
                  )
                else
                  const ListTile(
                    leading: Icon(
                      Icons.workspace_premium,
                      color: AppColors.accentColor,
                    ),
                    title: Text('Pro版をご利用中です'),
                    subtitle: Text('広告非表示、複数の子供登録など'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // App info section
          _buildSectionHeader('アプリについて'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('利用規約'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showComingSoonDialog(context, '利用規約');
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('プライバシーポリシー'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showComingSoonDialog(context, 'プライバシーポリシー');
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: const Text('お問い合わせ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showComingSoonDialog(context, 'お問い合わせ');
                  },
                ),
                const Divider(height: 1, indent: 56),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('アプリバージョン'),
                  trailing: Text(
                    'v1.1.0',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data management section
          _buildSectionHeader('データ管理'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.textSecondary,
                  ),
                  title: const Text('バックアップ'),
                  subtitle: Text(isPro ? 'Firebaseに保存' : 'Pro版で利用可能'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: isPro ? () => _handleBackup(context) : null,
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(
                    Icons.cloud_download_outlined,
                    color: AppColors.textSecondary,
                  ),
                  title: const Text('復元'),
                  subtitle: Text(isPro ? 'Firebaseから復元' : 'Pro版で利用可能'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: isPro ? () => _handleRestore(context) : null,
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.textSecondary,
                  ),
                  title: const Text('PDF/画像書き出し'),
                  subtitle: const Text('Pro版で利用可能'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showComingSoonDialog(context, 'PDF/画像書き出し機能');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // App branding
          Center(
            child: Column(
              children: [
                Text(
                  'はじめてメモ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '~First Steps~',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('準備中'),
        content: Text('$feature は今後のアップデートで提供予定です。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
