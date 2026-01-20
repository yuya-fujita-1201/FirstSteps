import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Privacy Policy screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'はじめてメモ ~First Steps~（以下「本アプリ」といいます）は、ユーザーのプライバシーを尊重し、個人情報の保護に努めます。本プライバシーポリシーは、本アプリにおける個人情報の取り扱いについて説明するものです。',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. 収集する情報',
              '本アプリは、以下の情報を収集する場合があります。\n\n'
              '【無料版】\n'
              '・広告配信のための匿名利用情報\n'
              '※お子様の名前、生年月日、マイルストーン記録（達成日、メモ、写真）などの入力情報は、無料版では本アプリ運営者に送信・収集されません（端末内のローカル保存のみ）。\n\n'
              '【Pro版】\n'
              '・クラウドバックアップ用の匿名認証情報\n'
              '・バックアップ機能の利用時に、端末内の入力情報（お子様の名前、生年月日、マイルストーン記録など）がクラウドに保存される場合があります\n'
              '・購入情報（RevenueCatを通じた課金情報）',
            ),
            _buildSection(
              '2. 情報の利用目的',
              '収集した情報は、以下の目的で利用されます。\n\n'
              '・本アプリのサービス提供\n'
              '・データのバックアップおよび復元（Pro版）\n'
              '・広告の配信（無料版）\n'
              '・アプリの改善および新機能の開発\n'
              '・お問い合わせへの対応',
            ),
            _buildSection(
              '3. データの保存場所',
              '【ローカルストレージ】\n'
              'お子様のプロフィールやマイルストーン記録は、デバイス内のローカルストレージに保存されます。\n\n'
              '【クラウドストレージ（Pro版のみ）】\n'
              'バックアップ機能を利用する場合、データはFirebase（Google Cloud Platform）に保存されます。通信は暗号化され、安全に管理されます。',
            ),
            _buildSection(
              '4. 第三者への提供',
              '本アプリは、以下の場合を除き、ユーザーの個人情報を第三者に提供することはありません。\n\n'
              '・ユーザーの同意がある場合\n'
              '・法令に基づく場合\n'
              '・人の生命、身体または財産の保護のために必要がある場合',
            ),
            _buildSection(
              '5. 第三者サービスの利用',
              '本アプリは、以下の第三者サービスを利用しています。各サービスのプライバシーポリシーもご確認ください。\n\n'
              '【無料版】\n'
              '・Google AdMob（広告配信）\n\n'
              '【Pro版】\n'
              '・Firebase Authentication（匿名認証）\n'
              '・Cloud Firestore（データ保存）\n'
              '・RevenueCat（課金管理）',
            ),
            _buildSection(
              '6. データの削除',
              'ユーザーは、アプリをアンインストールすることで、ローカルに保存されたすべてのデータを削除できます。クラウドに保存されたデータについては、お問い合わせいただければ削除いたします。',
            ),
            _buildSection(
              '7. 子どものプライバシー',
              '本アプリは、13歳未満の子どもから直接個人情報を収集することを意図していません。保護者の方が、お子様の情報を記録する形でご利用ください。',
            ),
            _buildSection(
              '8. プライバシーポリシーの変更',
              '本プライバシーポリシーは、必要に応じて変更されることがあります。変更後のプライバシーポリシーは、本アプリ内に掲示された時点より効力を生じます。',
            ),
            _buildSection(
              '9. お問い合わせ',
              '本プライバシーポリシーに関するお問い合わせは、アプリ内の「お問い合わせ」よりご連絡ください。',
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '制定日：2026年1月18日',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
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
