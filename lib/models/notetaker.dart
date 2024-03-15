const String tableNotetaker = 'notes';

class NotetakerFields {
  static const String id = 'id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class Notetaker {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String? description;
  final DateTime createdTime;

  Notetaker(
      {this.id,
      required this.isImportant,
      required this.number,
      required this.title,
      required this.description,
      required this.createdTime});

  Notetaker copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) {
    return Notetaker(
        id: id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime);
  }

  static Notetaker fromJson(Map<String, Object?> json) {
    return Notetaker(
      id: json[NotetakerFields.id] as int?,
      isImportant: json[NotetakerFields.isImportant] == 1,
      number: json[NotetakerFields.number] as int,
      title: json[NotetakerFields.title] as String,
      description: json[NotetakerFields.description] as String?,
      createdTime: DateTime.parse(json[NotetakerFields.time] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      NotetakerFields.id: id,
      NotetakerFields.isImportant: isImportant ? 1 : 0,
      NotetakerFields.number: number,
      NotetakerFields.title: title,
      NotetakerFields.description: description,
      NotetakerFields.time: createdTime.toIso8601String(),
    };
  }
}
