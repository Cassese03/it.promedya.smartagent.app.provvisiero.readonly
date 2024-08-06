const String tableNotes = 'dorig';

class DORigField {
  static final List<String> values = [
    id,
    id_dotes,
    id_dorig,
    id_ditta,
    cd_cf,
    cd_ar,
    cd_arlotto,
    qta,
    qtaevadibile,
    descrizione,
    prezzounitariov,
    cd_aliquota,
    scontoriga,
    prezzounitarioscontatov,
    prezzototalev,
    id_dorig_evade,
    linkcf,
    noteriga,
    xcolli,
    xconfezione,
    noteagg,
    cd_mg_p,
    stato,
    xlega_doc,
  ];

  static const String id = 'id';
  static const String id_dotes = 'id_dotes';
  static const String id_dorig = 'id_dorig';
  static const String id_ditta = 'id_ditta';
  static const String cd_cf = 'cd_cf';
  static const String cd_ar = 'cd_ar';
  static const String cd_arlotto = 'cd_arlotto';
  static const String qta = 'qta';
  static const String qtaevadibile = 'qtaevadibile';
  static const String descrizione = 'descrizione';
  static const String prezzounitariov = 'prezzounitariov';
  static const String cd_aliquota = 'cd_aliquota';
  static const String scontoriga = 'scontoriga';
  static const String prezzounitarioscontatov = 'prezzounitarioscontatov';
  static const String prezzototalev = 'prezzototalev';
  static const String id_dorig_evade = 'id_dorig_evade';
  static const String linkcf = 'linkcf';
  static const String noteriga = 'noteriga';
  static const String xcolli = 'xcolli';
  static const String xconfezione = 'xconfezione';
  static const String noteagg = 'noteagg';
  static const String cd_mg_p = 'cd_mg_p';
  static const String xlega_doc = 'xlega_doc';
  static const String stato = 'stato';
}

class DORig {
  final int? id;
  final String id_dotes;
  final String id_dorig;
  final String id_ditta;
  final String cd_cf;
  final String cd_ar;
  final String cd_arlotto;
  final String qta;
  final String qtaevadibile;
  final String descrizione;
  final String prezzounitariov;
  final String cd_aliquota;
  final String scontoriga;
  final String prezzounitarioscontatov;
  final String prezzototalev;
  final String id_dorig_evade;
  final String linkcf;
  final String noteriga;
  final String xcolli;
  final String xconfezione;
  final String noteagg;
  final String cd_mg_p;
  final String stato;
  final String xlega_doc;

  const DORig({
    this.id,
    required this.id_dotes,
    required this.id_dorig,
    required this.id_ditta,
    required this.cd_cf,
    required this.cd_ar,
    required this.cd_arlotto,
    required this.qta,
    required this.qtaevadibile,
    required this.descrizione,
    required this.prezzounitariov,
    required this.cd_aliquota,
    required this.scontoriga,
    required this.prezzounitarioscontatov,
    required this.prezzototalev,
    required this.id_dorig_evade,
    required this.linkcf,
    required this.noteriga,
    required this.xcolli,
    required this.xconfezione,
    required this.noteagg,
    required this.cd_mg_p,
    required this.stato,
    required this.xlega_doc,
  });

  static DORig fromJson(Map<String, Object?> json) => DORig(
        cd_cf: json[DORigField.cd_cf].toString(),
        id_ditta: json[DORigField.id_ditta].toString(),
        descrizione: json[DORigField.descrizione].toString(),
        id_dotes: json[DORigField.id_dotes].toString(),
        id_dorig: json[DORigField.id_dorig].toString(),
        qta: json[DORigField.qta].toString(),
        qtaevadibile: json[DORigField.qtaevadibile].toString(),
        prezzounitariov: json[DORigField.prezzounitariov].toString(),
        cd_aliquota: json[DORigField.cd_aliquota].toString(),
        scontoriga: json[DORigField.scontoriga].toString(),
        prezzounitarioscontatov:
            json[DORigField.prezzounitarioscontatov].toString(),
        prezzototalev: json[DORigField.prezzototalev].toString(),
        cd_ar: json[DORigField.cd_ar].toString(),
        cd_arlotto: json[DORigField.cd_arlotto].toString(),
        id_dorig_evade: json[DORigField.id_dorig_evade].toString(),
        linkcf: json[DORigField.linkcf].toString(),
        noteriga: json[DORigField.noteriga].toString(),
        xcolli: json[DORigField.xcolli].toString(),
        xconfezione: json[DORigField.xconfezione].toString(),
        noteagg: json[DORigField.noteagg].toString(),
        cd_mg_p: json[DORigField.cd_mg_p].toString(),
        stato: json[DORigField.stato].toString(),
        xlega_doc: json[DORigField.xlega_doc].toString(),
      );

  Map<String, Object?> toJson() => {
        DORigField.cd_cf: cd_cf,
        DORigField.id_ditta: id_ditta,
        DORigField.descrizione: descrizione,
        DORigField.cd_ar: cd_ar,
        DORigField.cd_arlotto: cd_arlotto,
        DORigField.prezzototalev: prezzototalev,
        DORigField.prezzounitarioscontatov: prezzounitarioscontatov,
        DORigField.scontoriga: scontoriga,
        DORigField.cd_aliquota: cd_aliquota,
        DORigField.prezzounitariov: prezzounitariov,
        DORigField.qta: qta,
        DORigField.qtaevadibile: qtaevadibile,
        DORigField.id_dotes: id_dotes,
        DORigField.id_dorig: id_dorig,
        DORigField.id_dorig_evade: id_dorig_evade,
        DORigField.linkcf: linkcf,
        DORigField.noteriga: noteriga,
        DORigField.xcolli: xcolli,
        DORigField.xconfezione: xconfezione,
        DORigField.noteagg: noteagg,
        DORigField.cd_mg_p: cd_mg_p,
        DORigField.stato: stato,
        DORigField.xlega_doc: xlega_doc,
      };

  DORig copy({
    int? id,
    String? id_dotes,
    String? id_dorig,
    String? id_ditta,
    String? cd_cf,
    String? cd_ar,
    String? cd_arlotto,
    String? qta,
    String? qtaevadibile,
    String? descrizione,
    String? prezzounitariov,
    String? cd_aliquota,
    String? scontoriga,
    String? prezzounitarioscontatov,
    String? prezzototalev,
    String? id_dorig_evade,
    String? linkcf,
    String? noteriga,
    String? xcolli,
    String? xconfezione,
    String? noteagg,
    String? cd_mg_p,
    String? stato,
    String? xlega_doc,
  }) =>
      DORig(
        id: id ?? this.id,
        cd_cf: cd_cf ?? this.cd_cf,
        id_ditta: id_ditta ?? this.id_ditta,
        id_dotes: id_dotes ?? this.id_dotes,
        id_dorig: id_dorig ?? this.id_dorig,
        descrizione: descrizione ?? this.descrizione,
        prezzototalev: prezzototalev ?? this.prezzototalev,
        prezzounitarioscontatov:
            prezzounitarioscontatov ?? this.prezzounitarioscontatov,
        scontoriga: scontoriga ?? this.scontoriga,
        cd_aliquota: cd_aliquota ?? this.cd_aliquota,
        prezzounitariov: prezzounitariov ?? this.prezzounitariov,
        qta: qta ?? this.qta,
        qtaevadibile: qtaevadibile ?? this.qtaevadibile,
        cd_ar: cd_ar ?? this.cd_ar,
        cd_arlotto: cd_arlotto ?? this.cd_arlotto,
        id_dorig_evade: id_dorig_evade ?? this.id_dorig_evade,
        linkcf: linkcf ?? this.linkcf,
        noteriga: noteriga ?? this.noteriga,
        xcolli: xcolli ?? this.xcolli,
        xconfezione: xconfezione ?? this.xconfezione,
        noteagg: noteagg ?? this.noteagg,
        cd_mg_p: cd_mg_p ?? this.cd_mg_p,
        stato: stato ?? this.stato,
        xlega_doc: xlega_doc ?? this.xlega_doc,
      );
}
