const String tableNotes = 'dovettore';

class dovettoreField {
  static final List<String> values = [
    id,
    id_ditta,
    cd_dovettore,
    id_dovettore,
    descrizione,
    localita,
    indirizzo,
    cap,
    cd_nazione,
    cd_provincia,
    telefono,
    email,
  ];

  static const String id = 'id';
  static const String id_ditta = 'id_ditta';
  static const String cd_dovettore = 'cd_dovettore';
  static const String id_dovettore = 'id_dovettore';
  static const String descrizione = 'descrizione';
  static const String localita = 'localita';
  static const String indirizzo = 'indirizzo';
  static const String cap = 'cap';
  static const String cd_nazione = 'cd_nazione';
  static const String cd_provincia = 'cd_provincia';
  static const String telefono = 'telefono';
  static const String email = 'email';
}

class dovettore {
  final int? id;
  final String id_ditta;
  final String cd_dovettore;
  final String id_dovettore;
  final String descrizione;
  final String localita;
  final String indirizzo;
  final String cap;
  final String cd_nazione;
  final String cd_provincia;
  final String telefono;
  final String email;

  const dovettore({
    this.id,
    required this.id_ditta,
    required this.cd_dovettore,
    required this.id_dovettore,
    required this.descrizione,
    required this.localita,
    required this.indirizzo,
    required this.cap,
    required this.cd_nazione,
    required this.cd_provincia,
    required this.telefono,
    required this.email,
  });

  static dovettore fromJson(Map<String, Object?> json) => dovettore(
        id: json[dovettoreField.id] as int?,
        id_ditta: json[dovettoreField.id_ditta].toString(),
        cd_dovettore: json[dovettoreField.cd_dovettore].toString(),
        id_dovettore: json[dovettoreField.id_dovettore].toString(),
        descrizione: json[dovettoreField.descrizione].toString(),
        localita: json[dovettoreField.localita].toString(),
        indirizzo: json[dovettoreField.indirizzo].toString(),
        cap: json[dovettoreField.cap].toString(),
        cd_nazione: json[dovettoreField.cd_nazione].toString(),
        cd_provincia: json[dovettoreField.cd_provincia].toString(),
        telefono: json[dovettoreField.telefono].toString(),
        email: json[dovettoreField.email].toString(),
      );

  Map<String, Object?> toJson() => {
        dovettoreField.id: id,
        dovettoreField.id_ditta: id_ditta,
        dovettoreField.cd_dovettore: cd_dovettore,
        dovettoreField.id_dovettore: id_dovettore,
        dovettoreField.descrizione: descrizione,
        dovettoreField.localita: localita,
        dovettoreField.indirizzo: indirizzo,
        dovettoreField.cap: cap,
        dovettoreField.cd_nazione: cd_nazione,
        dovettoreField.cd_provincia: cd_provincia,
        dovettoreField.telefono: telefono,
        dovettoreField.email: email,
      };

  dovettore copy({
    int? id,
    String? id_ditta,
    String? cd_dovettore,
    String? id_dovettore,
    String? descrizione,
    String? localita,
    String? indirizzo,
    String? cap,
    String? cd_nazione,
    String? cd_provincia,
    String? telefono,
    String? email,
  }) =>
      dovettore(
        id: id ?? this.id,
        id_ditta: id_ditta ?? this.id_ditta,
        cd_dovettore: cd_dovettore ?? this.cd_dovettore,
        id_dovettore: id_dovettore ?? this.id_dovettore,
        descrizione: descrizione ?? this.descrizione,
        localita: localita ?? this.localita,
        indirizzo: indirizzo ?? this.indirizzo,
        cap: cap ?? this.cap,
        cd_nazione: cd_nazione ?? this.cd_nazione,
        cd_provincia: cd_provincia ?? this.cd_provincia,
        telefono: telefono ?? this.telefono,
        email: email ?? this.email,
      );
}
