const String tableNotes = 'donota';

class donotaField {
  static final List<String> values = [id, id_ditta, id_dotes, id_nota, nota];
  static const String id = 'id';
  static const String id_ditta = 'id_ditta';
  static const String id_dotes = 'id_dotes';
  static const String id_nota = 'id_nota';
  static const String nota = 'nota';
}

class donota {
  final int? id;
  final String id_ditta;
  final String id_dotes;
  final String id_nota;
  final String nota;

  const donota({
    this.id,
    required this.id_ditta,
    required this.id_dotes,
    required this.id_nota,
    required this.nota,
  });

  static donota fromJson(Map<String, Object?> json) => donota(
        id_ditta: json[donotaField.id_ditta].toString().toString(),
        id_dotes: json[donotaField.id_dotes].toString().toString(),
        id_nota: json[donotaField.id_nota].toString().toString(),
        nota: json[donotaField.nota].toString().toString(),
      );

  Map<String, Object?> toJson() => {
        donotaField.id_ditta: id_ditta,
        donotaField.id_dotes: id_dotes,
        donotaField.id_nota: id_nota,
        donotaField.nota: nota,
      };

  donota copy({
    int? id,
    String? id_ditta,
    String? id_dotes,
    String? id_nota,
    String? nota,
  }) =>
      donota(
        id: id ?? this.id,
        id_ditta: id_ditta ?? this.id_ditta,
        id_dotes: id_dotes ?? this.id_dotes,
        id_nota: id_nota ?? this.id_nota,
        nota: nota ?? this.nota,
      );
}
