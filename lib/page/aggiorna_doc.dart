// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:http/http.dart' as http;
import 'package:provvisiero_readonly/model/dorig.dart';
import 'package:provvisiero_readonly/model/dotes.dart';
import 'package:provvisiero_readonly/model/dotes_prov.dart';
import 'package:provvisiero_readonly/model/dototali.dart';
import 'package:provvisiero_readonly/model/donota.dart';
import 'package:provvisiero_readonly/page/cliente.dart';

import '../model/dovettore.dart';

class AggiornaPageDoc extends StatefulWidget {
  const AggiornaPageDoc({super.key});

  @override
  State<AggiornaPageDoc> createState() => _AggiornaPageDocState();
}

class _AggiornaPageDocState extends State<AggiornaPageDoc> {
  late DateTime ultimoAggiornamento;
  bool isLoading = false;
  bool isDownloading = false;
  bool isSending = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_salvaUltimoAggiornamento(DateTime.now());
    aggiornadati();
  }

  Future<void> _salvaUltimoAggiornamento(DateTime datetime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ultimoAggiornamento', datetime.millisecondsSinceEpoch);
  }

  Future<List<DOTes>> get_dotes() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/dotes/PROV1234');
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/dotes/PROV1234';
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

  Future<List<DOTes_Prov>> get_dotes_prov() async {
    print(
        'https://bohagent.cloud/api/b2b/get_provvisiero/dotes_provvisiero/PROV1234');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/dotes_provvisiero/PROV1234';

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

  Future<List<DORig>> get_dorig() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/dorig/PROV1234');
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/dorig/PROV1234';

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

  Future<List<DOTotali>> get_dototali() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/dototali/PROV1234');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/dototali/PROV1234';

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

  Future<List<dovettore>> get_dovettore() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/dovettore/PROV1234');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/dovettore/PROV1234';
    var response = await http.get(Uri.parse(url));

    var notes = <dovettore>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(dovettore.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future<List<donota>> get_donota() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/donota/PROV1234');
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/donota/PROV1234';
    var response = await http.get(Uri.parse(url));

    var notes = <donota>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(donota.fromJson(noteJson));
      }
    }

    return notes;
  }

  Future aggiornadati() async {
    setState(() {
      isDownloading = true;
    });

    bool internet = await InternetConnectionChecker().hasConnection;
    if (internet) {
      print(
          'Inizio  ${DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now())}');

      var db = await ProvDatabase.instance.database;
      await get_dotes().then((value) async {
        ProvDatabase.instance.deleteallDOTes();
        var database = await ProvDatabase.instance.database;
        var batch = database.batch();
        for (var element in value) {
          batch.rawInsert("""INSERT INTO dotes (cd_cf,
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
                                dataconsegna
                                ) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""", [
            element.cd_cf,
            element.cd_do,
            "7",
            element.id_dotes,
            element.numerodoc,
            element.numerodocrif,
            element.tipodocumento,
            element.datadoc,
            element.cd_cfdest,
            element.cd_cfsede,
            element.cd_ls_1,
            element.cd_agente_1,
            element.cd_agente_2,
            element.righeevadibili,
            element.dataconsegna,
          ]);
        }
        try {
          await batch.commit();
        } catch (error) {
          print(error);
          return false;
        }
        return true;
      });

      await get_dorig().then(
        (value) async {
          ProvDatabase.instance.deleteallDORig();

          var database = await ProvDatabase.instance.database;
          var batch = database.batch();

          for (var element in value) {
            batch.rawInsert(
                """INSERT INTO dorig (id_dotes,
                              id_dorig,
                              id_ditta,
                              cd_cf,
                              cd_ar,
                              cd_mg_p,
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
                              xlega_doc,
                              stato) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                [
                  element.id_dotes,
                  element.id_dorig,
                  "7",
                  element.cd_cf,
                  element.cd_ar,
                  element.cd_mg_p,
                  element.cd_arlotto,
                  element.qta,
                  element.qtaevadibile,
                  element.descrizione,
                  element.prezzounitariov,
                  element.cd_aliquota,
                  element.scontoriga,
                  element.prezzounitarioscontatov,
                  element.prezzototalev,
                  element.id_dorig_evade,
                  element.linkcf,
                  element.noteriga,
                  element.xcolli,
                  element.xconfezione,
                  element.noteagg,
                  element.xlega_doc,
                  'false'
                ]);
          }

          try {
            await batch.commit();
          } catch (error) {
            print(error);
            return false;
          }
          return true;
        },
      );

      await get_dototali().then((value) async {
        await ProvDatabase.instance.deleteallDOTotali();
        var database = await ProvDatabase.instance.database;
        var batch = database.batch();
        for (var element in value) {
          batch.rawInsert("""INSERT INTO dototali (id_dotes,id_ditta,
                              totimponibilev,
                              totimpostav,
                              totdocumentov) VALUES(?,?,?,?,?)""", [
            element.id_dotes,
            "7",
            element.totimponibilev,
            element.totimpostav,
            element.totdocumentov,
          ]);
        }
        try {
          await batch.commit();
        } catch (error) {
          print(error);
          return false;
        }
        return true;
      });

      await get_dotes_prov().then(
        (value) async {
          await ProvDatabase.instance.deleteallDOTes_Prov();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert(
                """INSERT INTO dotes_prov (
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
    linkcart,xnumerodocrif,datadocrif) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                [
                  "7",
                  element.id_dotes.toString(),
                  element.xcd_xveicolo.toString(),
                  element.xautista.toString(),
                  element.ximb.toString(),
                  element.xacconto.toString(),
                  element.xaccontoF.toString(),
                  element.xsettimana.toString(),
                  element.xtipoveicolo.toString(),
                  element.xmodifica.toString(),
                  element.xurgente.toString(),
                  element.xpagata.toString(),
                  element.xriford.toString(),
                  element.xriffatra.toString(),
                  element.ximpfat.toString(),
                  element.ximppag.toString(),
                  element.xpagatat.toString(),
                  element.xpagataf.toString(),
                  element.xclidest.toString(),
                  "",
                  element.xnumerodocrif.toString(),
                  element.datadocrif.toString(),
                ]);
          }
          try {
            await batch.commit();
          } catch (error) {
            print(error);
            return false;
          }
          return true;
        },
      );

      await get_dovettore().then((value) async {
        await ProvDatabase.instance.deletealldovettore();

        var database = await ProvDatabase.instance.database;
        var batch = database.batch();
        for (var element in value) {
          batch.rawInsert("""INSERT INTO dovettore
              (
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
                email
              )
              VALUES(?,?,?,?,?,?,?,?,?,?,?)""", [
            "7",
            element.cd_dovettore,
            element.id_dovettore,
            element.descrizione,
            element.localita,
            element.indirizzo,
            element.cap,
            element.cd_nazione,
            element.cd_provincia,
            element.telefono,
            element.email
          ]);
        }
        try {
          await batch.commit();
        } catch (error) {
          print(error);
          return false;
        }
        return true;
      });
      await get_donota().then(
        (value) async {
          await ProvDatabase.instance.deletealldonota();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert("""
              INSERT INTO donota
              (id_ditta,id_dotes,id_nota,nota) 
              VALUES(?,?,?,?)
              """, [
              '7',
              element.id_dotes,
              element.id_nota,
              element.nota,
            ]);
          }
          try {
            await batch.commit();
          } catch (error) {
            print(error);
            return false;
          }
          return true;
        },
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text("Errore!",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    const Text("Non sei connesso ad Internet.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      color: const Color.fromARGB(174, 140, 235, 123),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      minWidth: double.infinity,
                      child: const Text("Riprova"),
                    ),
                  ],
                ),
              ),
            );
          });
    }
    print('Fine ${DateFormat('yyyy-MM-dd  kk:mm:ss').format(DateTime.now())}');
    setState(() {
      isDownloading = false;
      //_salvaUltimoAggiornamento(DateTime.now());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ClientiPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Builder(
          builder: (context) {
            if (isDownloading) {
              return content();
            } else {
              return test();
            }
          },
        ),
      );

  Container test() {
    return Container(
      child: const Text(''),
    );
  }

  Container content() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Download dati da Online',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Image.asset('assets/logo.jpg'),
          const SizedBox(
            height: 50,
            width: double.infinity,
          ),
          LoadingJumpingLine.circle()
        ],
      ),
    );
  }
}
