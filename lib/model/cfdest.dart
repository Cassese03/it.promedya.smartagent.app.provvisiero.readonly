const String tableNotes = 'cf';

class CFDestField {
  static final List<String> values = [
    id,
    cd_cf,
    cd_cfdest,
    id_ditta,
    descrizione,
    indirizzo,
    localita,
    cap,
    cd_nazione,
    cd_provincia,
    numero,
  ];

  static const String id = 'id';
  static const String cd_cf = 'cd_cf';
  static const String cd_cfdest = 'cd_cfdest';
  static const String id_ditta = 'id_ditta';
  static const String descrizione = 'descrizione';
  static const String indirizzo = 'indirizzo';
  static const String localita = 'localita';
  static const String cap = 'cap';
  static const String cd_nazione = 'cd_nazione';
  static const String cd_provincia = 'cd_provincia';
  static const String numero = 'numero';
}

class CFDest {
  final int? id;
  final String cd_cf;
  final String cd_cfdest;
  final String id_ditta;
  final String descrizione;
  final String indirizzo;
  final String localita;
  final String cap;
  final String cd_nazione;
  final String cd_provincia;
  final String numero;

  const CFDest({
    this.id,
    required this.cd_cf,
    required this.cd_cfdest,
    required this.id_ditta,
    required this.descrizione,
    required this.indirizzo,
    required this.localita,
    required this.cap,
    required this.cd_nazione,
    required this.cd_provincia,
    required this.numero,
  });

  static CFDest fromJson(Map<String, Object?> json) => CFDest(
        cd_cf: json[CFDestField.cd_cf] as String,
        cd_cfdest: json[CFDestField.cd_cfdest] as String,
        id_ditta: json[CFDestField.id_ditta].toString(),
        descrizione: json[CFDestField.descrizione] as String,
        indirizzo: (json[CFDestField.indirizzo] != null)
            ? json[CFDestField.indirizzo].toString()
            : '',
        localita: (json[CFDestField.localita] != null)
            ? json[CFDestField.localita].toString()
            : '',
        cap: (json[CFDestField.cap] != null)
            ? json[CFDestField.cap].toString()
            : '',
        cd_nazione: (json[CFDestField.cd_nazione] != null)
            ? json[CFDestField.cd_nazione].toString()
            : '',
        cd_provincia: (json[CFDestField.cd_provincia] != null)
            ? json[CFDestField.cd_provincia].toString()
            : '',
        numero: (json[CFDestField.numero] != null)
            ? json[CFDestField.numero].toString()
            : '',
      );

  Map<String, Object?> toJson() => {
        CFDestField.cd_cf: cd_cf,
        CFDestField.cd_cfdest: cd_cfdest,
        CFDestField.id_ditta: id_ditta,
        CFDestField.descrizione: descrizione,
        CFDestField.indirizzo: indirizzo,
        CFDestField.cd_provincia: cd_provincia,
        CFDestField.localita: localita,
        CFDestField.cap: cap,
        CFDestField.cd_nazione: cd_nazione,
        CFDestField.numero: numero,
      };

  CFDest copy({
    int? id,
    String? cd_cf,
    String? cd_cfdest,
    String? id_ditta,
    String? descrizione,
    String? indirizzo,
    String? localita,
    String? cap,
    String? cd_nazione,
    String? cd_provincia,
    String? numero,
  }) =>
      CFDest(
        id: id ?? this.id,
        cd_cf: cd_cf ?? this.cd_cf,
        cd_cfdest: cd_cfdest ?? this.cd_cfdest,
        id_ditta: id_ditta ?? this.id_ditta,
        descrizione: descrizione ?? this.descrizione,
        indirizzo: indirizzo ?? this.indirizzo,
        localita: localita ?? this.localita,
        cap: cap ?? this.cap,
        cd_nazione: cd_nazione ?? this.cd_nazione,
        cd_provincia: cd_provincia ?? this.cd_provincia,
        numero: numero ?? this.numero,
      );
}
