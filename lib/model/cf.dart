const String tableNotes = 'cf';

class CFField {
  static final List<String> values = [
    id,
    cd_cf,
    id_ditta,
    descrizione,
    indirizzo,
    localita,
    cap,
    cd_nazione,
    cliente,
    fornitore,
    cd_provincia,
    cd_agente_1,
    cd_agente_2,
    mail,
    telefono,
  ];

  static const String id = 'id';
  static const String cd_cf = 'cd_cf';
  static const String id_ditta = 'id_ditta';
  static const String descrizione = 'descrizione';
  static const String indirizzo = 'indirizzo';
  static const String localita = 'localita';
  static const String cap = 'cap';
  static const String cd_nazione = 'cd_nazione';
  static const String cliente = 'cliente';
  static const String fornitore = 'fornitore';
  static const String cd_provincia = 'cd_provincia';
  static const String cd_agente_1 = 'cd_agente_1';
  static const String cd_agente_2 = 'cd_agente_2';
  static const String mail = 'mail';
  static const String telefono = 'telefono';
}

class CF {
  final int? id;
  final String cd_cf;
  final String id_ditta;
  final String descrizione;
  final String indirizzo;
  final String localita;
  final String cap;
  final String cd_nazione;
  final String cliente;
  final String fornitore;
  final String cd_provincia;
  final String cd_agente_1;
  final String cd_agente_2;
  final String mail;
  final String telefono;

  const CF({
    this.id,
    required this.cd_cf,
    required this.id_ditta,
    required this.descrizione,
    required this.indirizzo,
    required this.localita,
    required this.cap,
    required this.cd_nazione,
    required this.cliente,
    required this.fornitore,
    required this.cd_provincia,
    required this.cd_agente_1,
    required this.cd_agente_2,
    required this.mail,
    required this.telefono,
  });

  static CF fromJson(Map<String, Object?> json) => CF(
        cd_cf: json[CFField.cd_cf].toString(),
        id_ditta: json[CFField.id_ditta].toString(),
        descrizione: json[CFField.descrizione].toString(),
        indirizzo: json[CFField.indirizzo].toString(),
        localita: json[CFField.localita].toString(),
        cap: json[CFField.cap].toString(),
        cd_nazione: json[CFField.cd_nazione].toString(),
        cliente: json[CFField.cliente].toString(),
        fornitore: json[CFField.fornitore].toString(),
        cd_provincia: json[CFField.cd_provincia].toString(),
        cd_agente_1: json[CFField.cd_agente_1].toString(),
        cd_agente_2: json[CFField.cd_agente_2].toString(),
        mail: json[CFField.mail].toString(),
        telefono: json[CFField.telefono].toString(),
      );

  Map<String, Object?> toJson() => {
        CFField.cd_cf: cd_cf,
        CFField.id_ditta: id_ditta,
        CFField.descrizione: descrizione,
        CFField.indirizzo: indirizzo,
        CFField.cd_agente_1: cd_agente_1,
        CFField.cd_agente_2: cd_agente_2,
        CFField.cd_provincia: cd_provincia,
        CFField.fornitore: fornitore,
        CFField.cliente: cliente,
        CFField.localita: localita,
        CFField.cap: cap,
        CFField.cd_nazione: cd_nazione,
        CFField.mail: mail,
        CFField.telefono: telefono,
      };

  CF copy({
    int? id,
    String? cd_cf,
    String? id_ditta,
    String? descrizione,
    String? indirizzo,
    String? localita,
    String? cap,
    String? cd_nazione,
    String? cliente,
    String? fornitore,
    String? cd_provincia,
    String? cd_agente_1,
    String? cd_agente_2,
    String? mail,
    String? telefono,
  }) =>
      CF(
        id: id ?? this.id,
        cd_cf: cd_cf ?? this.cd_cf,
        id_ditta: id_ditta ?? this.id_ditta,
        descrizione: descrizione ?? this.descrizione,
        indirizzo: indirizzo ?? this.indirizzo,
        localita: localita ?? this.localita,
        cap: cap ?? this.cap,
        cd_nazione: cd_nazione ?? this.cd_nazione,
        cliente: cliente ?? this.cliente,
        fornitore: fornitore ?? this.fornitore,
        cd_provincia: cd_provincia ?? this.cd_provincia,
        cd_agente_1: cd_agente_1 ?? this.cd_agente_1,
        cd_agente_2: cd_agente_2 ?? this.cd_agente_2,
        mail: mail ?? this.mail,
        telefono: telefono ?? this.telefono,
      );
}
