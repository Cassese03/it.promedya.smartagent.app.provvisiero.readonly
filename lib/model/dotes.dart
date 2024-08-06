const String tableNotes = 'dotes';

class DOTesField {
  static final List<String> values = [
    id,
    cd_cf,
    cd_do,
    id_ditta,
    id_dotes,
    numerodoc,
    numerodocrif,
    tipodocumento,
    datadoc,
    cd_cfdest,
    cd_cfsede,
    cd_ls_1,
    cd_agente_1,
    cd_agente_2,
    righeevadibili,
    dataconsegna,
  ];

  static const String id = 'id';
  static const String cd_cf = 'cd_cf';
  static const String cd_do = 'cd_do';
  static const String id_ditta = 'id_ditta';
  static const String id_dotes = 'id_dotes';
  static const String numerodoc = 'numerodoc';
  static const String numerodocrif = 'numerodocrif';
  static const String tipodocumento = 'tipodocumento';
  static const String datadoc = 'datadoc';
  static const String cd_cfdest = 'cd_cfdest';
  static const String cd_cfsede = 'cd_cfsede';
  static const String cd_ls_1 = 'cd_ls_1';
  static const String cd_agente_1 = 'cd_agente_1';
  static const String cd_agente_2 = 'cd_agente_2';
  static const String righeevadibili = 'righeevadibili';
  static const String dataconsegna = 'dataconsegna';
}

class DOTes {
  final int? id;
  final String cd_cf;
  final String cd_do;
  final String id_ditta;
  final String id_dotes;
  final String numerodoc;
  final String numerodocrif;
  final String tipodocumento;
  final String datadoc;
  final String cd_cfdest;
  final String cd_cfsede;
  final String cd_ls_1;
  final String cd_agente_1;
  final String cd_agente_2;
  final String righeevadibili;
  final String dataconsegna;

  const DOTes({
    this.id,
    required this.cd_cf,
    required this.cd_do,
    required this.id_ditta,
    required this.id_dotes,
    required this.numerodoc,
    required this.numerodocrif,
    required this.tipodocumento,
    required this.datadoc,
    required this.cd_cfdest,
    required this.cd_cfsede,
    required this.cd_ls_1,
    required this.cd_agente_1,
    required this.cd_agente_2,
    required this.righeevadibili,
    required this.dataconsegna,
  });

  static DOTes fromJson(Map<String, Object?> json) => DOTes(
        cd_cf: json[DOTesField.cd_cf].toString(),
        cd_do: json[DOTesField.cd_do].toString(),
        id_ditta: json[DOTesField.id_ditta].toString(),
        id_dotes: json[DOTesField.id_dotes].toString(),
        numerodoc: json[DOTesField.numerodoc].toString(),
        numerodocrif: json[DOTesField.numerodocrif].toString(),
        tipodocumento: json[DOTesField.tipodocumento].toString(),
        datadoc: json[DOTesField.datadoc].toString(),
        cd_cfdest: json[DOTesField.cd_cfdest].toString(),
        cd_cfsede: json[DOTesField.cd_cfsede].toString(),
        cd_ls_1: json[DOTesField.cd_ls_1].toString(),
        cd_agente_1: json[DOTesField.cd_agente_1].toString(),
        cd_agente_2: json[DOTesField.cd_agente_2].toString(),
        righeevadibili: json[DOTesField.righeevadibili].toString(),
        dataconsegna: json[DOTesField.dataconsegna].toString(),
      );

  Map<String, Object?> toJson() => {
        DOTesField.cd_cf: cd_cf,
        DOTesField.cd_do: cd_do,
        DOTesField.id_ditta: id_ditta,
        DOTesField.id_dotes: id_dotes,
        DOTesField.cd_cfsede: cd_cfsede,
        DOTesField.cd_cfdest: cd_cfdest,
        DOTesField.cd_agente_1: cd_agente_1,
        DOTesField.cd_agente_2: cd_agente_2,
        DOTesField.datadoc: datadoc,
        DOTesField.numerodoc: numerodoc,
        DOTesField.numerodocrif: numerodocrif,
        DOTesField.tipodocumento: tipodocumento,
        DOTesField.cd_ls_1: cd_ls_1,
        DOTesField.righeevadibili: righeevadibili,
        DOTesField.dataconsegna: dataconsegna,
      };

  DOTes copy({
    int? id,
    String? cd_cf,
    String? cd_do,
    String? id_ditta,
    String? id_dotes,
    String? numerodoc,
    String? numerodocrif,
    String? tipodocumento,
    String? datadoc,
    String? cd_cfdest,
    String? cd_cfsede,
    String? cd_ls_1,
    String? cd_agente_1,
    String? cd_agente_2,
    String? righeevadibili,
    String? dataconsegna,
  }) =>
      DOTes(
        id: id ?? this.id,
        cd_cf: cd_cf ?? this.cd_cf,
        cd_do: cd_do ?? this.cd_do,
        id_ditta: id_ditta ?? this.id_ditta,
        id_dotes: id_dotes ?? this.id_dotes,
        cd_ls_1: cd_ls_1 ?? this.cd_ls_1,
        cd_cfsede: cd_cfsede ?? this.cd_cfsede,
        cd_cfdest: cd_cfdest ?? this.cd_cfdest,
        datadoc: datadoc ?? this.datadoc,
        numerodoc: numerodoc ?? this.numerodoc,
        numerodocrif: numerodocrif ?? this.numerodocrif,
        tipodocumento: tipodocumento ?? this.tipodocumento,
        cd_agente_1: cd_agente_1 ?? this.cd_agente_1,
        cd_agente_2: cd_agente_2 ?? this.cd_agente_2,
        righeevadibili: righeevadibili ?? this.righeevadibili,
        dataconsegna: dataconsegna ?? this.dataconsegna,
      );
}
