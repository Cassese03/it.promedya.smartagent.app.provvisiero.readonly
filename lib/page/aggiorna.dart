// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:provvisiero_readonly/model/arcodcf.dart';
import 'package:provvisiero_readonly/model/dmsmaprules.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/model/ar.dart';
import 'package:http/http.dart' as http;
import 'package:provvisiero_readonly/model/cf.dart';
import 'package:provvisiero_readonly/model/cfdest.dart';
import 'package:provvisiero_readonly/model/dms.dart';
import 'package:provvisiero_readonly/model/dorig.dart';
import 'package:provvisiero_readonly/model/dotes.dart';
import 'package:provvisiero_readonly/model/dotes_prov.dart';
import 'package:provvisiero_readonly/model/dototali.dart';
import 'package:provvisiero_readonly/model/donota.dart';
import 'package:provvisiero_readonly/model/ls.dart';
import 'package:provvisiero_readonly/model/lsarticolo.dart';
import 'package:provvisiero_readonly/model/lsrevisione.dart';
import 'package:provvisiero_readonly/model/lsscaglione.dart';
import 'package:provvisiero_readonly/model/mggiac.dart';
import 'package:provvisiero_readonly/model/sc.dart';
import 'package:provvisiero_readonly/model/xveicolo.dart';
import 'package:provvisiero_readonly/page/cliente.dart';

import '../model/dovettore.dart';

class AggiornaPage extends StatefulWidget {
  const AggiornaPage({super.key});

  @override
  State<AggiornaPage> createState() => _AggiornaPageState();
}

class _AggiornaPageState extends State<AggiornaPage> {
  late DateTime ultimoAggiornamento;
  bool isLoading = false;
  bool isDownloading = false;
  bool isSending = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _salvaUltimoAggiornamento(DateTime.now());
    aggiornadati();
  }

  Future<void> _salvaUltimoAggiornamento(DateTime datetime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ultimoAggiornamento', datetime.millisecondsSinceEpoch);
  }

  Future<List<xdms>> get_dms() async {
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

  Future<List<MGGiac>> get_mggiac() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/mggiacenza/PROV1234');
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

  Future<List<xVeicolo>> get_xVeicolo() async {
    print('https://bohagent.cloud/api/b2b/get_provvisiero/xveicolo/PROV1234');
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/xveicolo/PROV1234/';

    var response = await http.get(Uri.parse(url));

    var notes = <xVeicolo>[];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(xVeicolo.fromJson(noteJson));
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

      await get_mggiac().then((value) async {
        await ProvDatabase.instance.deleteallMGGIAC();

        var database = await ProvDatabase.instance.database;
        var batch = database.batch();
        for (var element in value) {
          batch.rawInsert("""INSERT INTO mggiac (id_ditta,cd_ar,
            giacenza,
            giacenza,
            cd_mg) VALUES(?,?,?,?,?)""", [
            "7",
            element.cd_ar,
            element.giacenza,
            element.giacenza,
            element.cd_mg
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
/*
      await get_ls().then((value) async {
        // await ProvDatabase.instance.deleteallLS();

        for (int i = 0; i < value.length; i++) {
          List check = [];
          var db = await ProvDatabase.instance.database;
          check = await db.rawQuery(
              'SELECT * from ls where id_ditta = \'7\' and cd_ls =\'${value[i].cd_ls.toString()}\' and descrizione = \'${value[i].descrizione.toString()}\' ');
          if (check.isEmpty) {
            await ProvDatabase.instance.addLS("7", value[i].cd_ls.toString(),
                value[i].descrizione.toString());
          }
        }
      });

      await get_lsarticolo().then((value) async {
        await ProvDatabase.instance.deleteallLSArticolo();

        for (int i = 0; i < value.length; i++) {
          await ProvDatabase.instance.addLSArticolo(
              "7",
              value[i].id_lsrevisione.toString(),
              value[i].cd_ar.toString(),
              value[i].prezzo.toString(),
              value[i].sconto.toString(),
              value[i].provvigione.toString());
        }
      });

      await get_lsrevisione().then((value) async {
        //  await ProvDatabase.instance.deleteallLSRevisione();

        for (int i = 0; i < value.length; i++) {
          List check = [];
          var db = await ProvDatabase.instance.database;
          check = await db.rawQuery(
              'SELECT * from lsrevisione where id_ditta = \'7\' and id_lsrevisione = \'${value[i].id_lsrevisione.toString()}\' and cd_ls =\'${value[i].cd_ls.toString()}\' and descrizione = \'${value[i].descrizione.toString()}\' ');
          if (check.isEmpty) {
            await ProvDatabase.instance.addLSRevisione(
                "7",
                value[i].id_lsrevisione.toString(),
                value[i].cd_ls.toString(),
                value[i].descrizione.toString());
          }
        }
      });

      await get_lsscaglione().then((value) async {
//                      await ProvDatabase.instance.deleteallLSScaglione();

        for (int i = 0; i < value.length; i++) {
          List check = [];
          var db = await ProvDatabase.instance.database;
          check = await db.rawQuery(
              'SELECT * from lsscaglione where id_ditta = \'7\' and id_lsarticolo =\'${value[i].id_lsarticolo.toString()}\' and prezzo = \'${value[i].prezzo.toString()}\'  and finoaqta = \'${value[i].finoaqta.toString()}\' ');
          if (check.isEmpty) {
            await ProvDatabase.instance.addLSScaglione(
                "7",
                value[i].id_lsarticolo.toString(),
                value[i].prezzo.toString(),
                value[i].finoaqta.toString());
          }
        }
      });

*/
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
                              xconfezione,noteagg,
                              xlega_doc,stato) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
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
    linkcart,xnumerodocrif,datadocrif) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                [
                  "7",
                  element.id_dotes.toString(),
                  element.xcd_xveicolo.toString(),
                  element.xautista.toString(),
                  element.ximb.toString(),
                  element.xacconto.toString(),
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
            "7".toString(),
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

      await get_xVeicolo().then((value) async {
        await ProvDatabase.instance.deleteallxVeicolo();

        var database = await ProvDatabase.instance.database;
        var batch = database.batch();
        for (var element in value) {
          batch.rawInsert("""INSERT INTO xveicolo 
              (id_ditta,
              cd_cf,
              descrizione,
              cd_xveicolo)
              VALUES(?,?,?,?)""", [
            '7',
            element.cd_cf,
            element.descrizione,
            element.cd_xveicolo,
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
      _salvaUltimoAggiornamento(DateTime.now());
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
