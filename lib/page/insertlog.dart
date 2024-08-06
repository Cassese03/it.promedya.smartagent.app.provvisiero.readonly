import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart' as intltru;
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/dettaglio_docu.dart';

bool isLoading = false;

class InsertLogPage extends StatefulWidget {
  static const String id = '/LogPage';

  const InsertLogPage({super.key});
  @override
  State<InsertLogPage> createState() => _InsertLogPageState();
}

class _InsertLogPageState extends State<InsertLogPage> {
  TextEditingController textController = TextEditingController();
  bool isLoading = true;
  bool isOnline = true;

  var notesJson = [];

  @override
  void initState() {
    super.initState();

    refreshLog();
  }

  Future refreshLog() async {
    setState(() {
      isLoading = true;
    });

    bool internet = await InternetConnectionChecker().hasConnection;
    if (internet) {
      var url =
          'https://bohagent.cloud/api/b2b/get_provvisiero/xlogInsert/PROV1234';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        notesJson = json.decode(response.body);
      }

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isOnline = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      if (isOnline == true) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                centerTitle: true,
                title: const Text(
                  'Insert Log Giornaliero',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.lightBlue,
              ),
              body: isLoading
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ...notesJson.map(
                            (e) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              Colors.grey, // Colore del bordo
                                          width: 2, // Spessore del bordo
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ), // Raggio del bordo arrotondato
                                      ),
                                      child: (e['type'] == 'SC')
                                          ? sc(e)
                                          : (e['type'] == 'DOTes')
                                              ? dotes(e)
                                              : ar(e),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.lightBlue,
            title: const Text(
              'Torna Indietro',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: const Center(
            child: Text(
              'SEI OFFLINE! IMPOSSIBILE RECUPERARE I DATI DESIDERATI.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        );
      }
    }
  }

  ListTile ar(e) {
    return ListTile(
      title: Center(
        child: Text(
          'Nuovo ${e['type']} Inserito',
        ),
      ),
      subtitle: Text(
        'Codice Articolo: ${json.decode(e['json'])[0]['Cd_AR']} \n'
        'Calibro: ${json.decode(e['json'])[0]['xCd_xCalibro']}\n'
        'Varieta: ${json.decode(e['json'])[0]['xCd_xVarieta']}\n'
        'Descrizione:${json.decode(e['json'])[0]['Descrizione']}',
      ),
    );
  }

  ListTile dotes(e) {
    DateTime datadoc = DateTime.parse(json.decode(e['json'])[0]['DataDoc']);
    String newdatadoc =
        intltru.DateFormat('dd/MM/yyyy').format(datadoc).toString();

    return ListTile(
      title: const Center(
        child: Text(
          'Nuovo Documento Inserito',
        ),
      ),
      subtitle: GestureDetector(
        child: Text(
          'Data Documento: $newdatadoc \n'
          'Codice Cliente/Fornitore: ${json.decode(e['json'])[0]['desc_cf']} - ${json.decode(e['json'])[0]['Cd_CF']}\n'
          'Codice Documento: ${json.decode(e['json'])[0]['Cd_Do']}\n'
          'Numero Documento: ${json.decode(e['json'])[0]['NumeroDocI']}\n'
          'Cliente/Fornitore Collegato: ${json.decode(e['json'])[0]['Descrizione_Collegato']}',
        ),
        onTap: () async {
          if (json.decode(e['json'])[0]['Id_DoTes'] != null) {
            final db = await ProvDatabase.instance.database;
            await db
                .rawQuery(
              'SELECT * from dotes where id_dotes = \'${json.decode(e['json'])[0]['Id_DoTes']}\' ',
            )
                .then((value) {
              if (value.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocuPage(
                      id_dotes:
                          json.decode(e['json'])[0]['Id_DoTes'].toString(),
                    ),
                  ),
                );
              } else {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Attenzione!',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      content: const Text(
                        'Documento ancora non presente in APP Mobile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.green),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            });
          }
        },
      ),
    );
  }

  ListTile sc(e) {
    DateTime dataScadenza =
        DateTime.parse(json.decode(e['json'])[0]['DataScadenza']);
    DateTime dataFattura =
        DateTime.parse(json.decode(e['json'])[0]['DataFattura']);
    String newdataScadenza =
        intltru.DateFormat('dd/MM/yyyy').format(dataScadenza).toString();
    String newdataFattura =
        intltru.DateFormat('dd/MM/yyyy').format(dataFattura).toString();
    String documentocollegato = '';
    if (json.decode(e['json'])[0]['Id_DOTes'] != null) {
      documentocollegato =
          '\nDocumento collegato: ${json.decode(e['json'])[0]['Id_DOTes']}';

      documentocollegato =
          '$documentocollegato\n Codice Documento: ${json.decode(e['json'])[0]['cd_do']}';
    }

    return ListTile(
      title: Center(
        child: Text(
          'Nuova ${e['type']} Inserita',
        ),
      ),
      subtitle: GestureDetector(
        child: Text(
          'Data Scadenza: $newdataScadenza\n'
          'Codice Cliente Fornitore: ${json.decode(e['json'])[0]['desc_cf']} - ${json.decode(e['json'])[0]['Cd_CF']}\n'
          'Data Fattura: $newdataFattura\n'
          'Protocollo: ${json.decode(e['json'])[0]['Protocollo']}\n'
          'ImportoE: ${json.decode(e['json'])[0]['ImportoE']}\n'
          'Pagata: ${json.decode(e['json'])[0]['Pagata']}',
        ),
        onTap: () async {
          if (json.decode(e['json'])[0]['Id_DOTes'] != null) {
            final db = await ProvDatabase.instance.database;
            await db
                .rawQuery(
              'SELECT * from dotes where id_dotes = \'${json.decode(e['json'])[0]['Id_DOTes']}\' ',
            )
                .then((value) {
              if (value.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocuPage(
                      id_dotes:
                          json.decode(e['json'])[0]['Id_DOTes'].toString(),
                    ),
                  ),
                );
              } else {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Attenzione!',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      content: const Text(
                        'Documento ancora non presente in APP Mobile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all<Color>(Colors.green),
                          ),
                          child: const Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            });
          }
        },
      ),
    );
  }
}

class PrimaryShadowedButton extends StatelessWidget {
  const PrimaryShadowedButton(
      {super.key,
      required this.child,
      required this.onPressed,
      required this.borderRadius,
      required this.color});

  final Widget child;
  final double borderRadius;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: const RadialGradient(
              colors: [Colors.black54, Colors.black],
              center: Alignment.topLeft,
              radius: 2),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.25),
                offset: const Offset(3, 2),
                spreadRadius: 1,
                blurRadius: 8)
          ]),
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
          ],
        ),
      ),
    );
  }
}

class FavouriteButton extends StatelessWidget {
  const FavouriteButton(
      {super.key,
      required this.iconSize,
      required this.onPressed,
      required this.isClicked});

  final String isClicked;
  final double iconSize;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80))),
          backgroundColor: WidgetStateProperty.all(
              (isClicked == 'true') ? Colors.green : Colors.grey),
          elevation: WidgetStateProperty.all(4),
          shadowColor: WidgetStateProperty.all(Colors.green)),
      onPressed: onPressed,
      child: Center(
        child: Icon(
          Icons.circle,
          size: iconSize,
          color: (isClicked == 'true') ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
