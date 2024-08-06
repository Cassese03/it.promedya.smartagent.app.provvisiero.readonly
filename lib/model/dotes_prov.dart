const String tableNotes = 'dotes';

class DOTes_ProvField {
  static final List<String> values = [
    id,
    id_ditta,
    id_dotes,
    xcd_xveicolo,
    xautista,
    ximb,
    xacconto,
    xaccontoF,
    xsettimana,
    xtipoveicolo,
    xmodifica,
    xurgente,
    xpagata,
    xriford,
    xriffatra,
    ximpfat,
    ximppag,
    xpagatat,
    xpagataf,
    xclidest,
    linkcart,
    xnumerodocrif,
    datadocrif,
  ];

  static const String xcd_xveicolo = 'xcd_xveicolo';
  static const String id = 'id';
  static const String id_dotes = 'id_dotes';
  static const String id_ditta = 'id_ditta';
  static const String xriffatra = 'xriffatra';
  static const String ximppag = 'ximppag';
  static const String xautista = 'xautista';
  static const String ximpfat = 'ximpfat';
  static const String ximb = 'ximb';
  static const String xsettimana = 'xsettimana';
  static const String xacconto = 'xacconto';
  static const String xaccontoF = 'xaccontoF';
  static const String xtipoveicolo = 'xtipoveicolo';
  static const String xmodifica = 'xmodifica';
  static const String xurgente = 'xurgente';
  static const String xpagata = 'xpagata';
  static const String xriford = 'xriford';
  static const String xpagatat = 'xpagatat';
  static const String xpagataf = 'xpagataf';
  static const String xclidest = 'xclidest';
  static const String linkcart = 'linkcart';
  static const String xnumerodocrif = 'xnumerodocrif';
  static const String datadocrif = 'datadocrif';
}

class DOTes_Prov {
  final int? id;
  final String id_ditta;
  final String id_dotes;
  final String xriffatra;
  final String xcd_xveicolo;
  final String ximppag;
  final String xautista;
  final String ximpfat;
  final String xsettimana;
  final String ximb;
  final String xacconto;
  final String xaccontoF;
  final String xtipoveicolo;
  final String xmodifica;
  final String xurgente;
  final String xpagata;
  final String xriford;
  final String xpagatat;
  final String xpagataf;
  final String xclidest;
  final String linkcart;
  final String xnumerodocrif;
  final String datadocrif;

  const DOTes_Prov({
    this.id,
    required this.id_ditta,
    required this.id_dotes,
    required this.xriffatra,
    required this.xcd_xveicolo,
    required this.ximppag,
    required this.xautista,
    required this.ximpfat,
    required this.xsettimana,
    required this.ximb,
    required this.xacconto,
    required this.xaccontoF,
    required this.xtipoveicolo,
    required this.xmodifica,
    required this.xurgente,
    required this.xpagata,
    required this.xriford,
    required this.xpagatat,
    required this.xpagataf,
    required this.xclidest,
    required this.linkcart,
    required this.xnumerodocrif,
    required this.datadocrif,
  });

  static DOTes_Prov fromJson(Map<String, Object?> json) => DOTes_Prov(
        id_ditta: json[DOTes_ProvField.id_ditta].toString(),
        id_dotes: json[DOTes_ProvField.id_dotes].toString(),
        xriffatra: json[DOTes_ProvField.xriffatra].toString(),
        xcd_xveicolo: json[DOTes_ProvField.xcd_xveicolo].toString(),
        ximppag: json[DOTes_ProvField.ximppag].toString(),
        xautista: json[DOTes_ProvField.xautista].toString(),
        ximpfat: json[DOTes_ProvField.ximpfat].toString(),
        xsettimana: json[DOTes_ProvField.xsettimana].toString(),
        ximb: json[DOTes_ProvField.ximb].toString(),
        xacconto: json[DOTes_ProvField.xacconto].toString(),
        xaccontoF: json[DOTes_ProvField.xaccontoF].toString(),
        xtipoveicolo: json[DOTes_ProvField.xtipoveicolo].toString(),
        xmodifica: json[DOTes_ProvField.xmodifica].toString(),
        xurgente: json[DOTes_ProvField.xurgente].toString(),
        xpagata: json[DOTes_ProvField.xpagata].toString(),
        xriford: json[DOTes_ProvField.xriford].toString(),
        xpagatat: json[DOTes_ProvField.xpagatat].toString(),
        xpagataf: json[DOTes_ProvField.xpagataf].toString(),
        xclidest: json[DOTes_ProvField.xclidest].toString(),
        linkcart: json[DOTes_ProvField.linkcart].toString(),
        xnumerodocrif: json[DOTes_ProvField.xnumerodocrif].toString(),
        datadocrif: json[DOTes_ProvField.datadocrif].toString(),
      );

  Map<String, Object?> toJson() => {
        DOTes_ProvField.id_ditta: id_ditta,
        DOTes_ProvField.id_dotes: id_dotes,
        DOTes_ProvField.xriffatra: xriffatra,
        DOTes_ProvField.xcd_xveicolo: xcd_xveicolo,
        DOTes_ProvField.ximppag: ximppag,
        DOTes_ProvField.xautista: xautista,
        DOTes_ProvField.ximpfat: ximpfat,
        DOTes_ProvField.xsettimana: xsettimana,
        DOTes_ProvField.ximb: ximb,
        DOTes_ProvField.xacconto: xacconto,
        DOTes_ProvField.xaccontoF: xaccontoF,
        DOTes_ProvField.xtipoveicolo: xtipoveicolo,
        DOTes_ProvField.xmodifica: xmodifica,
        DOTes_ProvField.xurgente: xurgente,
        DOTes_ProvField.xpagata: xpagata,
        DOTes_ProvField.xpagatat: xpagatat,
        DOTes_ProvField.xpagataf: xpagataf,
        DOTes_ProvField.xriford: xriford,
        DOTes_ProvField.xclidest: xclidest,
        DOTes_ProvField.linkcart: linkcart,
        DOTes_ProvField.xnumerodocrif: xnumerodocrif,
        DOTes_ProvField.datadocrif: datadocrif,
      };

  DOTes_Prov copy({
    int? id,
    String? id_ditta,
    String? id_dotes,
    String? xriffatra,
    String? xcd_xveicolo,
    String? ximppag,
    String? xautista,
    String? ximpfat,
    String? xsettimana,
    String? ximb,
    String? xacconto,
    String? xaccontoF,
    String? xtipoveicolo,
    String? xmodifica,
    String? xurgente,
    String? xpagata,
    String? xpagatat,
    String? xpagataf,
    String? xriford,
    String? xclidest,
    String? linkcart,
    String? xnumerodocrif,
    String? datadocrif,
  }) =>
      DOTes_Prov(
        id: id ?? this.id,
        id_ditta: id_ditta ?? this.id_ditta,
        id_dotes: id_dotes ?? this.id_dotes,
        xriffatra: xriffatra ?? this.xriffatra,
        xautista: xautista ?? this.xautista,
        ximpfat: ximpfat ?? this.ximpfat,
        xsettimana: xsettimana ?? this.xsettimana,
        ximb: ximb ?? this.ximb,
        xacconto: xacconto ?? this.xacconto,
        xaccontoF: xaccontoF ?? this.xaccontoF,
        xtipoveicolo: xtipoveicolo ?? this.xtipoveicolo,
        xmodifica: xmodifica ?? this.xmodifica,
        xurgente: xurgente ?? this.xurgente,
        xpagata: xpagata ?? this.xpagata,
        xpagatat: xpagatat ?? this.xpagatat,
        xpagataf: xpagataf ?? this.xpagataf,
        xriford: xriford ?? this.xriford,
        xclidest: xclidest ?? this.xclidest,
        xcd_xveicolo: xcd_xveicolo ?? this.xcd_xveicolo,
        ximppag: ximppag ?? this.ximppag,
        linkcart: linkcart ?? this.linkcart,
        xnumerodocrif: xnumerodocrif ?? this.xnumerodocrif,
        datadocrif: datadocrif ?? this.datadocrif,
      );
}
