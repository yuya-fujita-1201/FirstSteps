import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                ListTile(
                  leading: const Icon(
                    Icons.workspace_premium,
                    color: AppColors.accentColor,
                  ),
                  title: const Text('Pro版にアップグレード'),
                  subtitle: const Text('広告非表示、複数の子供登録など'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showComingSoonDialog(context, 'Pro版');
                  },
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
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('アプリバージョン'),
                  trailing: const Text(
                    'v1.0.0',
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
                  subtitle: const Text('Pro版で利用可能'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showComingSoonDialog(context, 'バックアップ機能');
                  },
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
                    color: AppColors.primaryColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '~First Steps~',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.7),
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
