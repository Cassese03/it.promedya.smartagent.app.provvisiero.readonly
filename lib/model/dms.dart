const String tableNotes = 'dms';

class xdmsField {
  static final List<String> values = [
    id,
    id_ditta,
    id_dmsclass1,
    id_dmsclass2,
    id_dmsclass3,
    entityid,
    link
  ];
  static const String id = 'id';
  static const String id_ditta = 'id_ditta';
  static const String filename = 'filename';
  static const String id_dmsclass1 = 'id_dmsclass1';
  static const String id_dmsclass2 = 'id_dmsclass2';
  static const String id_dmsclass3 = 'id_dmsclass3';
  static const String entityid = 'entityid';
  static const String link = 'link';
}

class xdms {
  final int? id;
  final String id_ditta;
  final String filename;
  final String id_dmsclass1;
  final String id_dmsclass2;
  final String id_dmsclass3;
  final String entityid;
  final String link;

  const xdms({
    this.id,
    required this.id_ditta,
    required this.filename,
    required this.id_dmsclass1,
    required this.id_dmsclass2,
    required this.id_dmsclass3,
    required this.entityid,
    required this.link,
  });

  static xdms fromJson(Map<String, Object?> json) => xdms(
        id_ditta: json[xdmsField.id_ditta].toString().toString(),
        filename: json[xdmsField.filename].toString().toString(),
        id_dmsclass1: json[xdmsField.id_dmsclass1].toString().toString(),
        id_dmsclass2: json[xdmsField.id_dmsclass2].toString().toString(),
        id_dmsclass3: json[xdmsField.id_dmsclass3].toString().toString(),
        entityid: json[xdmsField.entityid].toString().toString(),
        link: json[xdmsField.link].toString().toString(),
      );

  Map<String, Object?> toJson() => {
        xdmsField.id_ditta: id_ditta,
        xdmsField.filename: filename,
        xdmsField.id_dmsclass1: id_dmsclass1,
        xdmsField.id_dmsclass2: id_dmsclass2,
        xdmsField.id_dmsclass3: id_dmsclass3,
        xdmsField.entityid: entityid,
        xdmsField.link: link,
      };

  xdms copy({
    int? id,
    String? id_ditta,
    String? filename,
    String? id_dmsclass1,
    String? id_dmsclass2,
    String? id_dmsclass3,
    String? entityid,
    String? link,
  }) =>
      xdms(
        id: id ?? this.id,
        id_ditta: id_ditta ?? this.id_ditta,
        filename: filename ?? this.filename,
        id_dmsclass1: id_dmsclass1 ?? this.id_dmsclass1,
        id_dmsclass2: id_dmsclass2 ?? this.id_dmsclass2,
        id_dmsclass3: id_dmsclass3 ?? this.id_dmsclass3,
        entityid: entityid ?? this.entityid,
        link: link ?? this.link,
      );
}
