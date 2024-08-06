const String tableNotes = 'cart';

class CartField {
  static final List<String> values = [
    id,
    cd_cf,
    cd_cfsede,
    cd_cfdest,
    cd_ar,
    cd_agente_1,
    qta,
    xcolli,
    xbancali,
    prezzo_unitario,
    totale,
    imposta,
    da_inviare,
    sconto_riga,
    cd_aliquota,
    aliquota,
    stato,
    note,
    confezione,
    datadoc,
    dataconsegna,
    cd_pg,
    linkcart,
    send_mail,
    note_dotes,
    note_agg,
    xlegato,
  ];

  static const String id = 'id';
  static const String cd_cf = 'cd_cf';
  static const String cd_cfsede = 'cd_cfsede';
  static const String cd_cfdest = 'cd_cfdest';
  static const String cd_ar = 'cd_ar';
  static const String cd_agente_1 = 'cd_agente_1';
  static const String qta = 'qta';
  static const String xcolli = 'xcolli';
  static const String xbancali = 'xbancali';
  static const String prezzo_unitario = 'prezzo_unitario';
  static const String totale = 'totale';
  static const String imposta = 'imposta';
  static const String da_inviare = 'da_inviare';
  static const String sconto_riga = 'sconto_riga';
  static const String cd_aliquota = 'cd_aliquota';
  static const String aliquota = 'aliquota';
  static const String note = 'note';
  static const String stato = 'stato';
  static const String confezione = 'confezione';
  static const String datadoc = 'datadoc';
  static const String dataconsegna = 'dataconsegna';
  static const String cd_pg = 'cd_pg';
  static const String linkcart = 'linkcart';
  static const String send_mail = 'send_mail';
  static const String note_dotes = 'note_dotes';
  static const String note_agg = 'note_agg';
  static const String xlegato = 'xlegato';
}

class Cart {
  final int? id;
  final String cd_cf;
  final String cd_cfsede;
  final String cd_cfdest;
  final String cd_ar;
  final String cd_agente_1;
  final String qta;
  final String xcolli;
  final String xbancali;
  final String prezzo_unitario;
  final String totale;
  final String imposta;
  final String da_inviare;
  final String sconto_riga;
  final String cd_aliquota;
  final String aliquota;
  final String note;
  final String stato;
  final String confezione;
  final String datadoc;
  final String dataconsegna;
  final String cd_pg;
  final String linkcart;
  final String send_mail;
  final String note_dotes;
  final String note_agg;
  final String xlegato;

  const Cart({
    this.id,
    required this.cd_cf,
    required this.cd_cfsede,
    required this.cd_cfdest,
    required this.cd_ar,
    required this.cd_agente_1,
    required this.qta,
    required this.xcolli,
    required this.xbancali,
    required this.prezzo_unitario,
    required this.totale,
    required this.imposta,
    required this.da_inviare,
    required this.sconto_riga,
    required this.cd_aliquota,
    required this.aliquota,
    required this.note,
    required this.stato,
    required this.confezione,
    required this.datadoc,
    required this.dataconsegna,
    required this.cd_pg,
    required this.linkcart,
    required this.send_mail,
    required this.note_dotes,
    required this.note_agg,
    required this.xlegato,
  });

  static Cart fromJson(Map<String, Object?> json) => Cart(
        cd_cf: json[CartField.cd_cf] as String,
        cd_cfsede: json[CartField.cd_cfsede] as String,
        cd_cfdest: json[CartField.cd_cfdest] as String,
        cd_ar: json[CartField.cd_ar] as String,
        cd_agente_1: json[CartField.cd_agente_1] as String,
        sconto_riga: json[CartField.sconto_riga] as String,
        qta: '${json[CartField.qta]}',
        xcolli: json[CartField.xcolli] as String,
        xbancali: json[CartField.xbancali] as String,
        prezzo_unitario: json[CartField.prezzo_unitario] as String,
        totale: json[CartField.totale] as String,
        imposta: json[CartField.imposta] as String,
        da_inviare: json[CartField.da_inviare] as String,
        cd_aliquota: json[CartField.cd_aliquota] as String,
        aliquota: json[CartField.aliquota] as String,
        note: json[CartField.note] as String,
        stato: json[CartField.stato] as String,
        confezione: json[CartField.confezione] as String,
        datadoc: json[CartField.datadoc] as String,
        dataconsegna: json[CartField.dataconsegna] as String,
        cd_pg: json[CartField.cd_pg] as String,
        linkcart: json[CartField.linkcart] as String,
        send_mail: json[CartField.send_mail] as String,
        note_dotes: json[CartField.note_dotes] as String,
        note_agg: json[CartField.note_agg] as String,
        xlegato: json[CartField.xlegato] as String,
      );

  Map<String, Object?> toJson() => {
        CartField.cd_cf: cd_cf,
        CartField.cd_cfsede: cd_cfsede,
        CartField.cd_cfdest: cd_cfdest,
        CartField.cd_ar: cd_ar,
        CartField.cd_agente_1: cd_agente_1,
        CartField.qta: qta,
        CartField.xcolli: xcolli,
        CartField.xbancali: xbancali,
        CartField.prezzo_unitario: prezzo_unitario,
        CartField.totale: totale,
        CartField.imposta: imposta,
        CartField.da_inviare: da_inviare,
        CartField.sconto_riga: sconto_riga,
        CartField.cd_aliquota: cd_aliquota,
        CartField.aliquota: aliquota,
        CartField.note: note,
        CartField.stato: stato,
        CartField.confezione: confezione,
        CartField.datadoc: datadoc,
        CartField.dataconsegna: dataconsegna,
        CartField.cd_pg: cd_pg,
        CartField.linkcart: linkcart,
        CartField.send_mail: send_mail,
        CartField.note_dotes: note_dotes,
        CartField.note_agg: note_agg,
        CartField.xlegato: xlegato,
      };

  Cart copy({
    int? id,
    String? cd_cf,
    String? cd_cfsede,
    String? cd_cfdest,
    String? cd_ar,
    String? cd_agente_1,
    String? qta,
    String? xcolli,
    String? xbancali,
    String? prezzo_unitario,
    String? totale,
    String? imposta,
    String? da_inviare,
    String? sconto_riga,
    String? cd_aliquota,
    String? aliquota,
    String? note,
    String? stato,
    String? confezione,
    String? datadoc,
    String? dataconsegna,
    String? cd_pg,
    String? linkcart,
    String? send_mail,
    String? note_dotes,
    String? note_agg,
    String? xlegato,
  }) =>
      Cart(
        id: id ?? this.id,
        cd_cf: cd_cf ?? this.cd_cf,
        cd_cfsede: cd_cfsede ?? this.cd_cfsede,
        cd_cfdest: cd_cfdest ?? this.cd_cfdest,
        cd_ar: cd_ar ?? this.cd_ar,
        cd_agente_1: cd_agente_1 ?? this.cd_agente_1,
        qta: qta ?? this.qta,
        xcolli: xcolli ?? this.xcolli,
        xbancali: xbancali ?? this.xbancali,
        prezzo_unitario: prezzo_unitario ?? this.prezzo_unitario,
        totale: totale ?? this.totale,
        imposta: imposta ?? this.imposta,
        da_inviare: da_inviare ?? this.da_inviare,
        sconto_riga: sconto_riga ?? this.sconto_riga,
        cd_aliquota: cd_aliquota ?? this.cd_aliquota,
        aliquota: aliquota ?? this.aliquota,
        note: note ?? this.note,
        stato: stato ?? this.stato,
        confezione: confezione ?? this.confezione,
        datadoc: datadoc ?? this.datadoc,
        dataconsegna: dataconsegna ?? this.dataconsegna,
        cd_pg: cd_pg ?? this.cd_pg,
        linkcart: linkcart ?? this.linkcart,
        send_mail: send_mail ?? this.send_mail,
        note_dotes: note_dotes ?? this.note_dotes,
        note_agg: note_agg ?? this.note_agg,
        xlegato: xlegato ?? this.xlegato,
      );
}
