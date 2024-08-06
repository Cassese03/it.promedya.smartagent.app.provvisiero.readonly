const String tableNotes = 'dms';

class regoleDmsField {
  static final List<String> values = [
    id,
    id_ditta,
    id_dmsclass1,
    id_dmsclass2,
    dmsclass3
  ];
  static const String id = 'id';
  static const String id_ditta = 'id_ditta';
  static const String id_dmsclass1 = 'id_dmsclass1';
  static const String id_dmsclass2 = 'id_dmsclass2';
  static const String dmsclass3 = 'dmsclass3';
}

class regoleDms {
  final int? id;
  final String id_ditta;
  final String id_dmsclass1;
  final String id_dmsclass2;
  final String dmsclass3;

  const regoleDms({
    this.id,
    required this.id_ditta,
    required this.id_dmsclass1,
    required this.id_dmsclass2,
    required this.dmsclass3,
  });

  static regoleDms fromJson(Map<String, Object?> json) => regoleDms(
        id_ditta: json[regoleDmsField.id_ditta].toString().toString(),
        id_dmsclass1: json[regoleDmsField.id_dmsclass1].toString().toString(),
        id_dmsclass2: json[regoleDmsField.id_dmsclass2].toString().toString(),
        dmsclass3: json[regoleDmsField.dmsclass3].toString().toString(),
      );

  Map<String, Object?> toJson() => {
        regoleDmsField.id_ditta: id_ditta,
        regoleDmsField.id_dmsclass1: id_dmsclass1,
        regoleDmsField.id_dmsclass2: id_dmsclass2,
        regoleDmsField.dmsclass3: dmsclass3,
      };

  regoleDms copy({
    int? id,
    String? id_ditta,
    String? id_dmsclass1,
    String? id_dmsclass2,
    String? dmsclass3,
  }) =>
      regoleDms(
        id: id ?? this.id,
        id_ditta: id_ditta ?? this.id_ditta,
        id_dmsclass1: id_dmsclass1 ?? this.id_dmsclass1,
        id_dmsclass2: id_dmsclass2 ?? this.id_dmsclass2,
        dmsclass3: dmsclass3 ?? this.dmsclass3,
      );
}
