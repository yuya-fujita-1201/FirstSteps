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
                    _showTermsDialog(context);
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('プライバシーポリシー'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showPrivacyPolicyDialog(context);
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

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('利用規約'),
        content: const SingleChildScrollView(
          child: Text(
            '''はじめてメモ 利用規約

第1条（適用）
本規約は、本アプリ「はじめてメモ」の利用に関する条件を定めるものです。

第2条（利用条件）
1. 本アプリは、お子様の成長記録を目的として提供されます。
2. ユーザーは、本規約に同意の上、本アプリを利用するものとします。

第3条（禁止事項）
1. 法令または公序良俗に違反する行為
2. 他のユーザーまたは第三者の権利を侵害する行為
3. 本アプリの運営を妨害する行為

第4条（免責事項）
1. 当方は、本アプリの内容の正確性、完全性を保証しません。
2. 本アプリの利用により生じた損害について、当方は責任を負いません。
3. データの消失等について、当方は責任を負いません。

第5条（規約の変更）
当方は、必要に応じて本規約を変更することがあります。

最終更新日：2024年1月''',
            style: TextStyle(fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('プライバシーポリシー'),
        content: const SingleChildScrollView(
          child: Text(
            '''はじめてメモ プライバシーポリシー

1. 収集する情報
本アプリでは以下の情報を収集・保存します：
- お子様のニックネーム、生年月日
- 成長記録（マイルストーン、日付、写真、メモ）
- 端末内にローカル保存されます

2. 情報の利用目的
収集した情報は以下の目的で利用します：
- アプリ機能の提供
- ユーザー体験の向上

3. 情報の第三者提供
ユーザーの個人情報を第三者に提供することはありません。

4. 広告について
本アプリではGoogle AdMobを使用して広告を表示します。
広告配信のため、Googleが端末情報を収集する場合があります。

5. データの保存
- 記録データは端末内に保存されます
- アプリを削除するとデータも削除されます

6. お問い合わせ
プライバシーに関するお問い合わせは、アプリストアのサポートページよりご連絡ください。

最終更新日：2024年1月''',
            style: TextStyle(fontSize: 13),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
