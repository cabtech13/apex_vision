import 'package:hive/hive.dart';

part 'category.g.dart';

/// Modèle représentant une catégorie (Sport, Cinéma, etc.)
@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? iconName; // Nom de l'icône Material

  @HiveField(3)
  final int channelCount;

  @HiveField(4)
  final int sortOrder;

  Category({
    required this.id,
    required this.name,
    this.iconName,
    this.channelCount = 0,
    this.sortOrder = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      iconName: json['iconName'],
      channelCount: json['channelCount'] ?? 0,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'channelCount': channelCount,
      'sortOrder': sortOrder,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? iconName,
    int? channelCount,
    int? sortOrder,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      channelCount: channelCount ?? this.channelCount,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
