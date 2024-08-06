import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/model/agente.dart';
import 'package:provvisiero_readonly/model/ar.dart';
import 'package:provvisiero_readonly/model/cf.dart';
import 'package:provvisiero_readonly/model/dorig.dart';
import 'package:provvisiero_readonly/model/dotes.dart';
import 'package:provvisiero_readonly/model/dotes_prov.dart';
import 'package:provvisiero_readonly/model/dototali.dart';
import 'package:provvisiero_readonly/model/lsarticolo.dart';
import 'package:provvisiero_readonly/model/lsrevisione.dart';
import 'package:provvisiero_readonly/model/lsscaglione.dart';
import 'package:provvisiero_readonly/model/mggiac.dart';
import 'package:provvisiero_readonly/model/sc.dart';
import 'package:provvisiero_readonly/page/aggiorna.dart';
import 'package:provvisiero_readonly/page/aggiorna_cf.dart';
import 'package:provvisiero_readonly/page/aggiorna_dms_ar.dart';
import 'package:provvisiero_readonly/page/aggiorna_doc.dart';
import 'package:provvisiero_readonly/page/altri_doc.dart';
import 'package:provvisiero_readonly/page/ar.dart';
import 'package:provvisiero_readonly/page/cerca_varieta.dart';
import 'package:provvisiero_readonly/page/documenti.dart';
import 'package:provvisiero_readonly/page/cliente.dart';
import 'package:provvisiero_readonly/page/fornitore.dart';

import 'package:provvisiero_readonly/page/riford.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:provvisiero_readonly/page/insertlog.dart';

import '../alert/alert_field2.dart';
import '../model/ls.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // ignore: non_constant_identifier_names
  Future<List<AR>> get_ar(String last_ar) async {
    //print('https://bohagent.cloud/api/b2b/get_provvisiero/ar/PROV1234/$last_ar');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/ar/PROV1234/$last_ar';

    var response = await http.get(Uri.parse(url));

    var notes = <AR>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(AR.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<Agente>> get_agente(String lastAr) async {
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/agente/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <Agente>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(Agente.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<CF>> get_cf() async {
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/cf/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <CF>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(CF.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<SC>> get_sc() async {
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/sc/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <SC>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(SC.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<MGGiac>> get_mggiac() async {
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/mggiacenza/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <MGGiac>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(MGGiac.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<LS>> get_ls() async {
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/ls/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <LS>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(LS.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<LSArticolo>> get_lsarticolo() async {
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/lsarticolo/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <LSArticolo>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(LSArticolo.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<LSRevisione>> get_lsrevisione() async {
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/lsrevisione/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <LSRevisione>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(LSRevisione.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<LSScaglione>> get_lsscaglione() async {
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/lsscaglione/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <LSScaglione>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(LSScaglione.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<DOTes>> get_dotes(String lastDotes) async {
    //print('https://bohagent.cloud/api/b2b/get_provvisiero/dotes/PROV1234/$last_dotes');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/dotes/PROV1234/$lastDotes';

    var response = await http.get(Uri.parse(url));

    var notes = <DOTes>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(DOTes.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<DOTes_Prov>> get_dotes_prov(String lastDotesProv) async {
    //print('https://bohagent.cloud/api/b2b/get_provvisiero/dotes_provvisiero/PROV1234/$last_dotes_prov');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/dotes_provvisiero/PROV1234/$lastDotesProv';

    var response = await http.get(Uri.parse(url));

    var notes = <DOTes_Prov>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(DOTes_Prov.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<DORig>> get_dorig(String lastDorig) async {
    //print('https://bohagent.cloud/api/b2b/get_provvisiero/dorig/PROV1234/$last_dorig');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/dorig/PROV1234/$lastDorig';

    var response = await http.get(Uri.parse(url));

    var notes = <DORig>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(DORig.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<DOTotali>> get_dototali(String lastDotes) async {
    //print('https://bohagent.cloud/api/b2b/get_provvisiero/dototali/PROV1234/$last_dotes');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/dototali/PROV1234/$lastDotes';

    var response = await http.get(Uri.parse(url));

    var notes = <DOTotali>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(DOTotali.fromJson(noteJson));
      }
    }

    return notes;
  }

  bool isDownloading = false;

  void showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Quale Aggiornamento vuoi fare ?'),
          content: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: const StadiumBorder()),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AggiornaPage(),
                              ));
                        },
                        child: const Center(
                          child: Text(
                            'Aggiorna Tutto',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'helvetica_neue_light',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const StadiumBorder()),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AggiornaPageCF(),
                          ));
                    },
                    child: const Center(
                      child: Text(
                        'Aggiorna CF',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const StadiumBorder()),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AggiornaPageDmsAr(),
                          ));
                    },
                    child: const Center(
                      child: Text(
                        'Aggiorna DMS-AR',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const StadiumBorder()),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AggiornaPageDoc(),
                          ));
                    },
                    child: const Center(
                      child: Text(
                        'Aggiorna Documenti',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text('Chiudi'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isDownloading
        ? Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('Download dati da Online'),
                //Image.asset('assets/logo.png'),
                const SizedBox(
                  height: 50,
                  width: double.infinity,
                ),
                LoadingJumpingLine.circle()
              ],
            ),
          )
        : Drawer(
            backgroundColor: Colors.lightBlue,
            child: SafeArea(
              child: FractionallySizedBox(
                heightFactor: 0.95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 35, child: Image.asset("assets/logo.jpg")),
                    Expanded(
                        flex: 65,
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text(
                                'Clienti',
                                style: textStyleListTile(),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ClientiPage(),
                                    ));
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Fornitori',
                                style: textStyleListTile(),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FornitorePage(),
                                    ));
                              },
                            ),
                            /* ListTile(
                              title: (InkWell(
                                onTap: () => whatsapp.messagesMediaByLink(
                                    to: 910000000000,
                                    mediaType: "video",
                                    mediaLink:
                                        "https://example.com/flutter.mp4",
                                    caption: "My Flutter Video"),
                                child: Text(
                                  'PROVA ',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white),
                                ),
                              )),
                            ),*/
                            ListTile(
                              title: Text(
                                'Articoli',
                                style: textStyleListTile(),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ARPage(),
                                    ));
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Ns Ord Rif',
                                style: textStyleListTile(),
                              ),
                              onTap: () async {
                                final db = await ProvDatabase.instance.database;
                                var message = await db.rawQuery(
                                    'SELECT * from dotes_prov where xriford != \'null\' ');
                                log(message.toString());
                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RifOrdPage(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Brogliaccio Giornaliero',
                                style: textStyleListTile(),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocumentiPage(
                                      date: DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now())
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Trasporti',
                                style: textStyleListTile(),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AltriPage(
                                      date: DateFormat('dd-MM-yyyy')
                                          .format(DateTime.now())
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Varieta',
                                style: textStyleListTile(),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CercaVarieta(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Insert Log Giornaliero',
                                style: textStyleListTile(),
                              ),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const InsertLogPage(),
                                  ),
                                );
                              },
                            ),
                            // ListTile(
                            //   title: Text(
                            //     'Update Log Giornaliero',
                            //     style: textStyleListTile(),
                            //   ),
                            //   onTap: () async {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => UpdateLogPage(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            ListTile(
                              title: Text(
                                'Aggiorna Dati',
                                style: textStyleListTile(),
                              ),
                              onTap: () async {
                                showAlert();
                              },
                            ),

                            /*
                            ListTile(
                              title: Text(
                                'CHECK DMS',
                                style: textStyleListTile(),
                              ),
                              onTap: () async {
                                final db =
                                    await ProvDatabase.instance.database;
                                var message =
                                    await db.rawQuery('SELECT * from xdms');
                                log(message.toString());
                              },
                            ),
                            ListTile(
                              title: Text(
                                'Logout',
                                style: textStyleListTile(),
                              ),
                              onTap: () {},
                            ),
                            */
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
  }

  TextStyle textStyleListTile() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 18.0,
    );
  }
}

Future<void> _launch(Uri url) async {
  var context;
  await canLaunchUrl(url)
      ? await launchUrl(url, mode: LaunchMode.externalApplication)
      : await showDialog(
          builder: (context) => const AlertField2(
            textButton: 'Ok',
            content: 'Errore. Impossibile Aprire il file.',
            title: 'Errore Momentaneo',
          ),
          context: context,
        );
  throw 'Could not launch $url';
}
