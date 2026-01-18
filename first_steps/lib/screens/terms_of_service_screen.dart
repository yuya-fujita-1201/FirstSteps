import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Terms of Service screen
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '第1条（適用）',
              '本規約は、本アプリの利用に関する条件を定めるものです。ユーザーは、本アプリを利用することにより、本規約に同意したものとみなされます。',
            ),
            _buildSection(
              '第2条（利用登録）',
              '本アプリの利用にあたり、ユーザー登録は必要ありません。アプリをダウンロードし、起動することで利用を開始できます。',
            ),
            _buildSection(
              '第3条（プライバシー）',
              'ユーザーの個人情報の取り扱いについては、別途定めるプライバシーポリシーに従うものとします。',
            ),
            _buildSection(
              '第4条（禁止事項）',
              'ユーザーは、本アプリの利用にあたり、以下の行為をしてはならないものとします。\n'
              '・法令または公序良俗に違反する行為\n'
              '・犯罪行為に関連する行為\n'
              '・本アプリの運営を妨害するおそれのある行為\n'
              '・他のユーザーまたは第三者の権利を侵害する行為\n'
              '・その他、運営者が不適切と判断する行為',
            ),
            _buildSection(
              '第5条（免責事項）',
              '運営者は、本アプリの利用により生じたいかなる損害についても、一切の責任を負わないものとします。また、本アプリの内容変更、中断、終了により生じた損害についても同様とします。',
            ),
            _buildSection(
              '第6条（サービス内容の変更等）',
              '運営者は、ユーザーへの事前の通知なく、本アプリの内容を変更、追加または廃止することができるものとします。',
            ),
            _buildSection(
              '第7条（利用規約の変更）',
              '運営者は、必要と判断した場合には、ユーザーに通知することなくいつでも本規約を変更することができるものとします。変更後の本規約は、本アプリ内に掲示された時点より効力を生じるものとします。',
            ),
            _buildSection(
              '第8条（準拠法・裁判管轄）',
              '本規約の解釈にあたっては、日本法を準拠法とします。本アプリに関して紛争が生じた場合には、運営者の所在地を管轄する裁判所を専属的合意管轄裁判所とします。',
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '以上',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
