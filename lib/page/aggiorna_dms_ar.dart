import 'dart:async';
import 'dart:convert';
import 'package:provvisiero_readonly/model/arcodcf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/model/ar.dart';
import 'package:http/http.dart' as http;
import 'package:provvisiero_readonly/model/dms.dart';
import 'package:provvisiero_readonly/page/cliente.dart';

import '../model/dmsmaprules.dart';

class AggiornaPageDmsAr extends StatefulWidget {
  const AggiornaPageDmsAr({super.key});

  @override
  State<AggiornaPageDmsAr> createState() => _AggiornaPageStateDmsAr();
}

class _AggiornaPageStateDmsAr extends State<AggiornaPageDmsAr> {
  late DateTime ultimoAggiornamento;
  bool isLoading = false;
  bool isDownloading = false;
  bool isSending = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _salvaUltimoAggiornamento(DateTime.now());
    aggiornadati();
  }

  Future<void> _salvaUltimoAggiornamento(DateTime datetime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ultimoAggiornamento', datetime.millisecondsSinceEpoch);
  }

  Future<List<xdms>> get_dms() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/dms/PROV1234');
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/dms/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <xdms>[];
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(xdms.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<regoleDms>> get_regoledms() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/regoledms/PROV1234');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/regoledms/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <regoleDms>[];
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(regoleDms.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<AR>> get_ar(String lastAr) async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/ar/PROV1234');
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/ar/PROV1234';

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

  Future<List<arcodcf>> get_arcodcf() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/arcodcf/PROV1234');
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/arcodcf/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <arcodcf>[];
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(arcodcf.fromJson(noteJson));
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

      String lastAr1 = '';

      await get_ar(lastAr1).then(
        (value) async {
          await ProvDatabase.instance.deleteallAR();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert("""INSERT INTO AR 
              (id_ditta,cd_AR,descrizione,
              cd_aliquota_v,cd_arclasse1,cd_arclasse2,cd_arclasse3,cd_argruppo1,cd_argruppo2,cd_argruppo3,immagine,xcd_xcalibro,xcd_xvarieta,giacenza,id_ar,dms) 
              
              VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""", [
              '7',
              element.cd_AR,
              element.descrizione,
              element.cd_aliquota_v,
              element.cd_arclasse1,
              element.cd_arclasse2,
              element.cd_arclasse3,
              element.cd_argruppo1,
              element.cd_argruppo2,
              element.cd_argruppo3,
              element.immagine,
              element.xcd_xcalibro,
              element.xcd_xvarieta,
              element.giacenza,
              element.id_ar,
              element.dms
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
      await get_dms().then(
        (value) async {
          await ProvDatabase.instance.deleteallxdms();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert("""INSERT INTO xdms
              (id_ditta,filename,id_dmsclass1,id_dmsclass2,id_dmsclass3,entityid,link) 
              VALUES(?,?,?,?,?,?,?)""", [
              '7',
              element.filename,
              element.id_dmsclass1,
              element.id_dmsclass2,
              element.id_dmsclass3,
              element.entityid,
              element.link,
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

      await get_regoledms().then(
        (value) async {
          await ProvDatabase.instance.deleteallregoledms();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert("""INSERT INTO regoledms
              (id_ditta,id_dmsclass1,id_dmsclass2,dmsclass3) 
              VALUES(?,?,?,?)""", [
              '7',
              element.id_dmsclass1,
              element.id_dmsclass2,
              element.dmsclass3,
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

      await get_arcodcf().then(
        (value) async {
          await ProvDatabase.instance.deleteallarcodcf();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert("""INSERT INTO arcodcf
              (id_ditta,cd_ar,cd_cf,fornitorepreferenziale,codicealternativo) 
              VALUES(?,?,?,?,?)""", [
              '7',
              element.cd_ar,
              element.cd_cf,
              element.fornitorepreferenziale,
              element.codicealternativo,
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
