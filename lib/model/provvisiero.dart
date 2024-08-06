const String tableNotes = 'provvisiero';

class ProvvisieroField {
  static final List<String> values = [id, isImportant, number];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
}

class Provvisiero {
  final int? id;
  final bool isImportant;
  final int number;
  const Provvisiero({
    this.id,
    required this.isImportant,
    required this.number,
  });

  static Provvisiero fromJson(Map<String, Object?> json) => Provvisiero(
        id: json[ProvvisieroField.id] as int?,
        isImportant: json[ProvvisieroField.isImportant] == 1,
        number: json[ProvvisieroField.number] as int,
      );

  Map<String, Object?> toJson() => {
        ProvvisieroField.id: id,
        ProvvisieroField.isImportant: isImportant ? 1 : 0,
        ProvvisieroField.number: number,
      };

  Provvisiero copy({
    int? id,
    bool? isImportant,
    int? number,
  }) =>
      Provvisiero(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
      );
}
