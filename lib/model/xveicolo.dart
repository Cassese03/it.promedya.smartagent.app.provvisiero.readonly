
const String tableNotes = 'sc';

class xVeicoloField {
  static final List<String> values = [
    id,
    id_ditta,
    cd_cf,
    cd_xveicolo,
    descrizione
  ];
  static const String id = 'id';
  static const String id_ditta = 'id_ditta';
  static const String cd_cf = 'cd_cf';
  static const String cd_xveicolo = 'cd_xveicolo';
  static const String descrizione = 'descrizione';
}

class xVeicolo {
  final int? id;
  final String id_ditta;
  final String cd_cf;
  final String cd_xveicolo;
  final String descrizione;

  const xVeicolo({
    this.id,
    required this.id_ditta,
    required this.cd_cf,
    required this.cd_xveicolo,
    required this.descrizione,
  });

  static xVeicolo fromJson(Map<String, Object?> json) => xVeicolo(
        cd_cf: json[xVeicoloField.cd_cf].toString(),
        id_ditta: json[xVeicoloField.id_ditta].toString().toString(),
        descrizione: json[xVeicoloField.descrizione].toString().toString(),
        cd_xveicolo: json[xVeicoloField.cd_xveicolo].toString().toString(),
      );

  Map<String, Object?> toJson() => {
        xVeicoloField.cd_cf: cd_cf,
        xVeicoloField.id_ditta: id_ditta,
        xVeicoloField.descrizione: descrizione,
        xVeicoloField.cd_xveicolo: cd_xveicolo,
      };

  xVeicolo copy({
    int? id,
    String? id_ditta,
    String? cd_cf,
    String? descrizione,
    String? cd_xveicolo,
  }) =>
      xVeicolo(
        id: id ?? this.id,
        cd_cf: cd_cf ?? this.cd_cf,
        cd_xveicolo: cd_xveicolo ?? this.cd_xveicolo,
        id_ditta: id_ditta ?? this.id_ditta,
        descrizione: descrizione ?? this.descrizione,
      );
}
