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
import 'package:provvisiero_readonly/model/cf.dart';
import 'package:provvisiero_readonly/model/cfdest.dart';
import 'package:provvisiero_readonly/model/sc.dart';
import 'package:provvisiero_readonly/page/cliente.dart';

class AggiornaPageCF extends StatefulWidget {
  const AggiornaPageCF({super.key});

  @override
  State<AggiornaPageCF> createState() => _AggiornaPageStateCF();
}

class _AggiornaPageStateCF extends State<AggiornaPageCF> {
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

  Future<List<CF>> get_cf() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/cf/PROV1234');
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

  Future<List<CFDest>> get_cfdest() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/cfdest/PROV1234');
    var url = 'https://bohagent.cloud/api/b2b/get_provvisiero/cfdest/PROV1234';

    var response = await http.get(Uri.parse(url));

    var notes = <CFDest>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(CFDest.fromJson(noteJson));
      }
    }
    return notes;
  }

  Future<List<SC>> get_sc() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/sc/PROV1234');
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

  Future aggiornadati() async {
    setState(() {
      isDownloading = true;
    });

    bool internet = await InternetConnectionChecker().hasConnection;
    if (internet) {
      print(
          'Inizio  ${DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now())}');

      var db = await ProvDatabase.instance.database;
      String lastAr1 = '';

      await get_cf().then(
        (value) async {
          await ProvDatabase.instance.deleteallCF();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert(
                "INSERT INTO CF (cd_cf,id_ditta,descrizione,indirizzo,localita,cap,cd_nazione,cliente,fornitore,cd_provincia,cd_agente_1,cd_agente_2,mail,telefono) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                [
                  element.cd_cf,
                  '7',
                  element.descrizione.toString(),
                  element.indirizzo,
                  element.localita,
                  element.cap,
                  element.cd_nazione,
                  element.cliente,
                  element.fornitore,
                  element.cd_provincia,
                  element.cd_agente_1.toString(),
                  element.cd_agente_2.toString(),
                  element.mail.toString(),
                  element.telefono.toString()
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

      await get_cfdest().then(
        (value) async {
          await ProvDatabase.instance.deleteallCFDest();
          var database = await ProvDatabase.instance.database;
          var batch = database.batch();
          for (var element in value) {
            batch.rawInsert(
                "INSERT INTO cfdest (cd_cf,id_ditta,cd_cfdest,descrizione,indirizzo,localita,cap,cd_nazione,cd_provincia,numero) VALUES(?,?,?,?,?,?,?,?,?,?)",
                [
                  element.cd_cf,
                  '7',
                  element.cd_cfdest.toString(),
                  element.descrizione.toString(),
                  element.indirizzo,
                  element.localita,
                  element.cap,
                  element.cd_nazione,
                  element.cd_provincia,
                  element.numero
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

      await get_sc().then((value) async {
        await ProvDatabase.instance.deleteallSC();

        var database = await ProvDatabase.instance.database;
        var batch = database.batch();
        for (var element in value) {
          batch.rawInsert("""INSERT INTO sc (id_ditta,cd_cf,
                              datascadenza,
                              importoe,
                              numfattura,
                              datafattura,
                              datapagamento,
                              pagata,
                              insoluta,
                              id_dotes) VALUES(?,?,?,?,?,?,?,?,?,?)""", [
            "7",
            element.cd_cf.toString(),
            element.datascadenza.toString(),
            element.importoe.toString(),
            element.numfattura.toString(),
            element.datafattura.toString(),
            element.datapagamento.toString(),
            element.pagata.toString(),
            element.insoluta.toString(),
            element.id_dotes.toString(),
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
