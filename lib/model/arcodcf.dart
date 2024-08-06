const String tableNotes = 'arcodcf';

class arcodcfField {
  static final List<String> values = [
    id,
    id_ditta,
    cd_ar,
    cd_cf,
    codicealternativo,
    fornitorepreferenziale,
  ];

  static const String id = 'id';
  static const String id_ditta = 'id_ditta';
  static const String cd_ar = 'cd_ar';
  static const String cd_cf = 'cd_cf';
  static const String fornitorepreferenziale = 'fornitorepreferenziale';
  static const String codicealternativo = 'codicealternativo';
}

class arcodcf {
  final int? id;
  final String id_ditta;
  final String cd_ar;
  final String cd_cf;
  final String codicealternativo;
  final String fornitorepreferenziale;

  const arcodcf(
      {this.id,
      required this.id_ditta,
      required this.cd_ar,
      required this.cd_cf,
      required this.codicealternativo,
      required this.fornitorepreferenziale});

  static arcodcf fromJson(Map<String, Object?> json) => arcodcf(
        id: json[arcodcfField.id] as int?,
        id_ditta: json[arcodcfField.id_ditta].toString(),
        cd_ar: json[arcodcfField.cd_ar].toString(),
        cd_cf: json[arcodcfField.cd_cf].toString(),
        codicealternativo:
            json[arcodcfField.codicealternativo].toString(),
        fornitorepreferenziale:
            json[arcodcfField.fornitorepreferenziale].toString(),
      );

  Map<String, Object?> toJson() => {
        arcodcfField.id: id,
        arcodcfField.id_ditta: id_ditta,
        arcodcfField.cd_ar: cd_ar,
        arcodcfField.cd_cf: cd_cf,
        arcodcfField.codicealternativo: codicealternativo,
        arcodcfField.fornitorepreferenziale: fornitorepreferenziale,
      };

  arcodcf copy(
          {int? id,
          String? id_ditta,
          String? cd_ar,
          String? cd_cf,
          String? codicealternativo,
          String? fornitorepreferenziale}) =>
      arcodcf(
        id: id ?? this.id,
        id_ditta: id_ditta ?? this.id_ditta,
        cd_ar: cd_ar ?? this.cd_ar,
        cd_cf: cd_cf ?? this.cd_cf,
        codicealternativo: codicealternativo ?? this.codicealternativo,
        fornitorepreferenziale:
            fornitorepreferenziale ?? this.fornitorepreferenziale,
      );
}
