import '../models/milestone_record.dart';

/// Service for managing milestone templates and categories
class MilestoneService {
  /// Base path for milestone icons
  static const String _iconBasePath = 'assets/icons/milestones/';

  /// Predefined milestone templates based on child development stages
  static const List<MilestoneTemplate> templates = [
    // 0-3 months
    MilestoneTemplate(
      name: '初めての笑顔',
      category: '社会性',
      minAgeMonths: 0,
      maxAgeMonths: 3,
      iconPath: '${_iconBasePath}smile.svg',
    ),
    MilestoneTemplate(
      name: '首すわり',
      category: '運動',
      minAgeMonths: 2,
      maxAgeMonths: 5,
      iconPath: '${_iconBasePath}neck_support.svg',
    ),
    MilestoneTemplate(
      name: '声を出して笑う',
      category: '社会性',
      minAgeMonths: 2,
      maxAgeMonths: 4,
      iconPath: '${_iconBasePath}laugh.svg',
    ),

    // 4-6 months
    MilestoneTemplate(
      name: '寝返り',
      category: '運動',
      minAgeMonths: 4,
      maxAgeMonths: 7,
      iconPath: '${_iconBasePath}roll_over.svg',
    ),
    MilestoneTemplate(
      name: 'おもちゃを掴む',
      category: '運動',
      minAgeMonths: 3,
      maxAgeMonths: 6,
      iconPath: '${_iconBasePath}grasp.svg',
    ),
    MilestoneTemplate(
      name: '離乳食スタート',
      category: '食事',
      minAgeMonths: 5,
      maxAgeMonths: 7,
      iconPath: '${_iconBasePath}solid_food.svg',
    ),

    // 7-9 months
    MilestoneTemplate(
      name: 'お座り',
      category: '運動',
      minAgeMonths: 6,
      maxAgeMonths: 9,
      iconPath: '${_iconBasePath}sit.svg',
    ),
    MilestoneTemplate(
      name: 'ハイハイ',
      category: '運動',
      minAgeMonths: 7,
      maxAgeMonths: 10,
      iconPath: '${_iconBasePath}crawl.svg',
    ),
    MilestoneTemplate(
      name: '人見知り',
      category: '社会性',
      minAgeMonths: 6,
      maxAgeMonths: 9,
      iconPath: '${_iconBasePath}stranger_anxiety.svg',
    ),

    // 10-12 months
    MilestoneTemplate(
      name: 'つかまり立ち',
      category: '運動',
      minAgeMonths: 8,
      maxAgeMonths: 12,
      iconPath: '${_iconBasePath}stand_support.svg',
    ),
    MilestoneTemplate(
      name: '初めての言葉',
      category: '言語',
      minAgeMonths: 9,
      maxAgeMonths: 14,
      iconPath: '${_iconBasePath}first_word.svg',
    ),
    MilestoneTemplate(
      name: 'バイバイする',
      category: '社会性',
      minAgeMonths: 9,
      maxAgeMonths: 12,
      iconPath: '${_iconBasePath}wave.svg',
    ),

    // 12-18 months
    MilestoneTemplate(
      name: '初めての一歩',
      category: '運動',
      minAgeMonths: 10,
      maxAgeMonths: 18,
      iconPath: '${_iconBasePath}first_step.svg',
    ),
    MilestoneTemplate(
      name: 'コップで飲む',
      category: '食事',
      minAgeMonths: 12,
      maxAgeMonths: 18,
      iconPath: '${_iconBasePath}cup.svg',
    ),
    MilestoneTemplate(
      name: 'スプーンを使う',
      category: '食事',
      minAgeMonths: 12,
      maxAgeMonths: 18,
      iconPath: '${_iconBasePath}spoon.svg',
    ),

    // 18-24 months
    MilestoneTemplate(
      name: '二語文を話す',
      category: '言語',
      minAgeMonths: 18,
      maxAgeMonths: 30,
      iconPath: '${_iconBasePath}two_words.svg',
    ),
    MilestoneTemplate(
      name: '階段を上る',
      category: '運動',
      minAgeMonths: 18,
      maxAgeMonths: 24,
      iconPath: '${_iconBasePath}stairs.svg',
    ),
    MilestoneTemplate(
      name: 'お絵描きする',
      category: '創作',
      minAgeMonths: 18,
      maxAgeMonths: 24,
      iconPath: '${_iconBasePath}drawing.svg',
    ),

    // 2+ years
    MilestoneTemplate(
      name: 'トイレトレーニング完了',
      category: '生活',
      minAgeMonths: 24,
      maxAgeMonths: 48,
      iconPath: '${_iconBasePath}toilet.svg',
    ),
    MilestoneTemplate(
      name: '三輪車に乗る',
      category: '運動',
      minAgeMonths: 24,
      maxAgeMonths: 36,
      iconPath: '${_iconBasePath}tricycle.svg',
    ),
    MilestoneTemplate(
      name: 'お友達と遊ぶ',
      category: '社会性',
      minAgeMonths: 24,
      maxAgeMonths: 36,
      iconPath: '${_iconBasePath}friends.svg',
    ),
  ];

  /// Default icon path for unknown milestones
  static const String defaultIconPath = '${_iconBasePath}star.svg';

  /// Get all milestone templates
  static List<MilestoneTemplate> getAllTemplates() {
    return templates;
  }

  /// Get milestone templates grouped by age range
  static Map<String, List<MilestoneTemplate>> getTemplatesGroupedByAge() {
    final Map<String, List<MilestoneTemplate>> grouped = {
      '0-3ヶ月': [],
      '4-6ヶ月': [],
      '7-9ヶ月': [],
      '10-12ヶ月': [],
      '1歳-1歳半': [],
      '1歳半-2歳': [],
      '2歳以上': [],
    };

    for (var template in templates) {
      if (template.maxAgeMonths <= 3) {
        grouped['0-3ヶ月']!.add(template);
      } else if (template.maxAgeMonths <= 6) {
        grouped['4-6ヶ月']!.add(template);
      } else if (template.maxAgeMonths <= 9) {
        grouped['7-9ヶ月']!.add(template);
      } else if (template.maxAgeMonths <= 12) {
        grouped['10-12ヶ月']!.add(template);
      } else if (template.maxAgeMonths <= 18) {
        grouped['1歳-1歳半']!.add(template);
      } else if (template.maxAgeMonths <= 24) {
        grouped['1歳半-2歳']!.add(template);
      } else {
        grouped['2歳以上']!.add(template);
      }
    }

    return grouped;
  }

  /// Get milestone templates by category
  static Map<String, List<MilestoneTemplate>> getTemplatesByCategory() {
    final Map<String, List<MilestoneTemplate>> grouped = {};

    for (var template in templates) {
      if (!grouped.containsKey(template.category)) {
        grouped[template.category] = [];
      }
      grouped[template.category]!.add(template);
    }

    return grouped;
  }

  /// Get all categories
  static List<String> getCategories() {
    return templates.map((t) => t.category).toSet().toList()..sort();
  }
}
