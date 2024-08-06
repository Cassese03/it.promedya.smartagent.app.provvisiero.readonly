// ignore_for_file: deprecated_member_use, unrelated_type_equality_checks, non_constant_identifier_names, use_build_context_synchronously, unused_field, unused_local_variable, duplicate_ignore, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as matematica;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/alert_field2.dart';
import 'package:provvisiero_readonly/page/cerca_cliente.dart';

import 'package:url_launcher/url_launcher.dart';
import '../db/databases.dart';

String prezzo = '1.00';
String prezzototale = '0.00';
bool isLoading = false;
String cd_cf = '';

class DocuPage extends StatefulWidget {
  const DocuPage({super.key, required this.id_dotes});
  final String id_dotes;

  @override
  State<DocuPage> createState() => _DocuPageState();
}

class _DocuPageState extends State<DocuPage>
    with SingleTickerProviderStateMixin {
  late List documento = [];
  late List somma_qta = [];
  late List righe = [];
  late List totali = [];
  late List colonne = [];
  bool isLoading = true;
  late TabController _tabController;

  List Testa = [];
  List EvasoDa = [];
  List EvasoIn = [];
  List LinkCF = [];
  List LinkCF2 = [];
  List EvasoDa2 = [];
  List EvasoIn2 = [];
  List EvasoIn3 = [];
  List donota = [];
  List scadenza_cf = [];
  List scadenza_cliente = [];
  List dms = [];
  List count = [];
  List regoledms = [];
  List pers_dms = [];
  bool checkdms = false;
  String data = '';
  String data_consegna = '';
  String id_dmsclass1 = '';
  String id_dmsclass2 = '';
  var collegamenti = '';

  Future refreshDORig() async {
    setState(() {
      isLoading = true;
    });
    final d1b = await ProvDatabase.instance.database;

    var id = widget.id_dotes;

    documento = await d1b.rawQuery(
        'SELECT *,(SELECT descrizione from cf where cf.cd_cf = dotes.cd_cf limit 1) as Desc_CF from dotes where id_ditta = \'7\' and id_dotes  = \'$id\'');
    somma_qta = await d1b.rawQuery(
        'SELECT sum(Qta) as Qta from dorig where id_ditta = \'7\' and id_dotes  = \'$id\'');

    if (documento.isNotEmpty) {
      regoledms = await d1b.rawQuery(
          'SELECT * from regoledms where dmsclass3 = \'${documento.first['cd_do']}\' order by id desc');

      if (regoledms.isNotEmpty) {
        for (var element in regoledms) {
          id_dmsclass1 = '$id_dmsclass1\'${element["id_dmsclass1"]}\',';
          id_dmsclass2 = '$id_dmsclass2\'${element["id_dmsclass2"]}\',';
        }
        id_dmsclass1 =
            id_dmsclass1.substring(0, id_dmsclass1.length.toInt() - 1);

        id_dmsclass2 =
            id_dmsclass2.substring(0, id_dmsclass2.length.toInt() - 1);
      }

      count = await d1b.rawQuery(
          'SELECT * from xdms where entityid = \'$id\' and id_dmsclass1 in ($id_dmsclass1) and id_dmsclass2 in ($id_dmsclass2) order by id_dmsclass2 desc');

      dms = await d1b.rawQuery('SELECT * from xdms where entityid = \'$id\' ');

      //checkdms = true;
      var clifor =
          (documento.first['cd_cf'].toString().startsWith('C') == true) ? 1 : 2;
      int tipoDoc = 0;
      switch (documento.first['cd_do']) {
        case 'SCO':
          {
            tipoDoc = 48;
          }
          break;

        case 'FTA':
          {
            tipoDoc = 43;
          }
          break;
        case 'FTV':
          {
            tipoDoc = 44;
          }
          break;
        case 'FTI':
          {
            tipoDoc = 45;
          }
          break;
        case 'OVC':
          {
            tipoDoc = 46;
          }
          break;
        case 'OAF':
          {
            tipoDoc = 50;
          }
          break;
        default:
          {
            tipoDoc = 49;
          }
          break;
      }
      if (documento.first['cd_do'].toString().startsWith('OF') == true) {
        tipoDoc = 50;
      }

      pers_dms = await d1b.rawQuery(
          'SELECT * from xdms where entityid = \'$id\' and (id_dmsclass1 = \'$clifor\') and (id_dmsclass2 = \'$tipoDoc\') order by id desc');
    }

    donota =
        await d1b.rawQuery('SELECT * from donota where id_dotes = ? ', [id]);

    scadenza_cliente = await d1b.rawQuery(
        'SELECT *,(SELECT descrizione from cf where cd_cf = sc.cd_cf) as descrizione from sc where id_dotes = ? ',
        [id]);

    righe = await d1b.rawQuery(
        'SELECT * from dorig where id_ditta = \'7\' and id_dotes= \'$id\'');

    totali = await d1b.rawQuery(
        'SELECT * from dototali where id_ditta = \'7\' and id_dotes= \'$id\'');

    colonne = await d1b.rawQuery(
        " SELECT 'descrizione' AS name UNION ALL SELECT 'cd_arlotto' AS name UNION ALL SELECT 'qta' AS name UNION ALL SELECT 'prezzounitariov' AS name UNION ALL SELECT 'scontoriga' AS name UNION ALL SELECT 'cd_aliquota' AS name UNION ALL SELECT 'xconfezione' AS name UNION ALL SELECT 'xcolli' AS name UNION ALL SELECT 'noteriga' AS name ",
        null);

    Testa = await d1b.rawQuery(
        'SELECT *, (SELECT descrizione from cf where cd_cf = dotes.cd_cf )as descrizione from dotes where id_ditta = \'7\' and id_dotes  = \'$id\'');

    List LinkCF1 = await d1b.rawQuery(
        'SELECT id_dotes as LINK from dorig where Id_DORig in (SELECT linkcf from dorig where id_dotes  = \'$id\' ) GROUP BY id_dotes');

    if (LinkCF1.isEmpty) {
      LinkCF1 = await d1b.rawQuery(
          'SELECT id_dotes as LINK from dorig where linkcf in (SELECT id_dorig from dorig where id_dotes  = \'$id\' ) GROUP BY id_dotes');
    }

    if (LinkCF1.isNotEmpty) {
      String filtro = '';
      for (var element in LinkCF1) {
        filtro = '$filtro \',\' ${element["LINK"]}';
      }
      filtro = filtro.toString().replaceAll('null , ', '').replaceAll(' ', '');
      LinkCF = await d1b.rawQuery(
          'SELECT *,(select descrizione from cf where cd_Cf = dotes.cd_cf limit 1) as Desc_CF from dotes where id_dotes in (\'$filtro\') ');
    }

    if (LinkCF.isNotEmpty) {
      for (var element in LinkCF) {
        collegamenti =
            '$collegamenti ${element["cd_do"]} - ${element["numerodoc"]}';
      }
    }

    EvasoDa = await d1b.rawQuery(
        'SELECT * from dotes where id_dotes in (SELECT id_dotes AS EvasoDa from dorig where id_dorig in (SELECT id_dorig_evade from dorig where id_dotes= \'$id\') GROUP BY id_dotes) ');

    EvasoIn = await d1b.rawQuery(
        'SELECT * from dotes where id_dotes in (SELECT id_dotes AS EvasoIn from dorig where id_dorig_evade in (SELECT id_dorig from dorig where id_dotes= \'$id\') GROUP BY id_dotes) ');

    List EvasoDa1 = await d1b.rawQuery(
        'SELECT id_dotes AS EvasoDa from dorig where id_dorig in (SELECT id_dorig_evade from dorig where id_dotes  = \'$id\') GROUP BY id_dotes');

    if (EvasoDa1.isNotEmpty) {
      List EvasoDa2 = await d1b.rawQuery(
          'SELECT id_dotes AS EvasoIn2 from dorig where id_dorig in (SELECT id_dorig_evade from dorig where id_dotes  = \'${EvasoDa[0]['id_dotes']}\') GROUP BY id_dotes');
      if (EvasoDa2.isNotEmpty) {
        this.EvasoDa2 = await d1b.rawQuery(
            'SELECT * from dotes where id_dotes = \'${EvasoDa2.first["EvasoIn2"]}\' ');

        var LinkCF2 = await d1b.rawQuery(
            'SELECT id_dotes as LINK from dorig where id_dorig in (SELECT linkcf from dorig where id_dotes  = ?  ) GROUP BY id_dotes',
            [this.EvasoDa2.first['id_dotes']]);
        if (LinkCF2.isEmpty) {
          LinkCF2 = await d1b.rawQuery(
              'SELECT id_dotes as LINK from dorig where linkcf in (SELECT id_dorig from dorig where id_dotes  = \'${this.EvasoDa2.first['id_dotes']}\' ) GROUP BY id_dotes');
        }
        if (LinkCF2.isNotEmpty) {
          this.LinkCF2 = await d1b.rawQuery(
              'SELECT * from dotes where id_dotes = \'${LinkCF2[0]["LINK"]}\' ');
        }

        if (this.LinkCF2.isNotEmpty) {
          List EvasoIn2 = await d1b.rawQuery(
              'SELECT id_dotes AS EvasoIn from dorig where id_dorig_evade in (SELECT id_dorig from dorig where id_dotes  = ?) GROUP BY id_dotes',
              [this.LinkCF2.first['id_dotes']]);
          if (EvasoIn2.isNotEmpty) {
            this.EvasoIn2 = await d1b.rawQuery(
                'SELECT * from dotes where id_dotes = \'${EvasoIn2[0]["EvasoIn"]}\' ');
          }
        }

        if (EvasoIn2.isNotEmpty) {
          List EvasoIn3 = await d1b.rawQuery(
              'SELECT id_dotes AS EvasoIn from dorig where id_dorig_evade in (SELECT id_dorig from dorig where id_dotes  = ?) GROUP BY id_dotes',
              [EvasoIn2.first['id_dotes']]);
          if (EvasoIn3.isNotEmpty) {
            this.EvasoIn3 = await d1b.rawQuery(
                'SELECT * from dotes where id_dotes = ? ',
                [EvasoIn3[0]["EvasoIn"]]);
            scadenza_cf = await d1b.rawQuery(
                'SELECT *,(SELECT descrizione from cf where cd_cf = sc.cd_cf) as descrizione from sc where id_dotes = ? ',
                [EvasoIn3[0]["EvasoIn"]]);
          }
        }
      }
    }

    data = (Testa.isNotEmpty) ? Testa[0]["datadoc"] : '';
    data_consegna = (Testa.isNotEmpty) ? Testa[0]["dataconsegna"] : '';

    setState(() {
      isLoading = false;
    });
  }

  Future<String?> scegli_dms(List dms) async {
    return await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text(
              'Scegli Documento',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: dms
                    .map(
                      (e) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: const StadiumBorder()),
                        onPressed: () {
                          Navigator.of(context).pop('${e["link"]}');
                        },
                        child: Center(
                          child: Text(
                            '${e["filename"]} [${e["id"]}]',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'helvetica_neue_light',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();

    refreshDORig();

    _tabController = TabController(vsync: this, length: 1);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  child: const Icon(
                    Icons.download,
                  ),
                  onPressed: () async {
                    if (dms.isNotEmpty) {
                      if (dms.length > 1) {
                        var result = await scegli_dms(dms);
                        if (result != null) {
                          if (result.toString() != 'null') {
                            Uri url = Uri.parse(result);
                            if (await canLaunch(url.toString())) {
                              await launch(url.toString());
                            } else {
                              await showDialog(
                                builder: (context) => const AlertField2(
                                  textButton: 'Ok',
                                  content:
                                      'Errore. Impossibile Aprire il file.',
                                  title: 'Errore Momentaneo',
                                ),
                                context: context,
                              );
                              throw 'Could not launch $url';
                            }
                          }
                        }
                      } else {
                        if (dms.first['link'].toString() != 'null') {
                          Uri url = Uri.parse(dms.first['link']);
                          if (await canLaunch(url.toString())) {
                            log(widget.id_dotes);
                            log(url.toString());
                            await launch(url.toString());
                          } else {
                            await showDialog(
                              builder: (context) => const AlertField2(
                                textButton: 'Ok',
                                content: 'Errore. Impossibile Aprire il file.',
                                title: 'Errore Momentaneo',
                              ),
                              context: context,
                            );
                            throw 'Could not launch $url';
                          }
                        } else {
                          await showDialog(
                            builder: (context) => const AlertField2(
                              textButton: 'Ok',
                              content:
                                  'Impossibile aprire il Documento, in quanto non è stato trovato.',
                              title: 'Documento non Trovato',
                            ),
                            context: context,
                          );
                        }
                      }
                    } else {
                      await showDialog(
                        builder: (context) => const AlertField2(
                          textButton: 'Ok',
                          content: 'File non Esistente.',
                          title: 'Errore',
                        ),
                        context: context,
                      );
                      log('no dms found');
                      log(widget.id_dotes);
                    }
                  },
                ),
                (pers_dms.isNotEmpty)
                    ? FloatingActionButton(
                        heroTag: "btn2",
                        child: const Icon(
                          Icons.dock,
                        ),
                        onPressed: () async {
                          if (pers_dms.first['link'].toString() != 'null') {
                            Uri url = Uri.parse(pers_dms.first['link']);
                            if (await canLaunch(url.toString())) {
                              log(url.toString());
                              await launch(url.toString());
                            } else {
                              await showDialog(
                                builder: (context) => const AlertField2(
                                  textButton: 'Ok',
                                  content:
                                      'Errore. Impossibile Aprire il file.',
                                  title: 'Errore Momentaneo',
                                ),
                                context: context,
                              );
                              throw 'Could not launch $url';
                            }
                          } else {
                            await showDialog(
                              builder: (context) => const AlertField2(
                                textButton: 'Ok',
                                content:
                                    'Impossibile aprire il Documento, in quanto non è stato trovato.',
                                title: 'Documento non Trovato',
                              ),
                              context: context,
                            );
                          }
                        },
                      )
                    : const Text(''),
              ],
            ),
            appBar: AppBar(
              leading: GestureDetector(
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onTap: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              centerTitle: true,
              title: Text(
                '${documento[0]["cd_do"]} N° ${documento[0]["numerodoc"]}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                textScaleFactor: 1.0,
              ),
              backgroundColor: Colors.lightBlue,
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          figlio1(context),
                          figlio2(context),
                          quantitatotale(context, somma_qta),
                          buildTree(id_dotes: widget.id_dotes),
                          if (totali.isNotEmpty)
                            figlio3(context, totali, donota, widget.id_dotes),
                        ],
                      ),
                    ),
                  ),
          );
  }

  DefaultTabController figlio2(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: [
          const TabBar(
            controller: null,
            tabs: [
              Tab(
                child: Text(
                  'Righe',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
// columnSpacing: MediaQuery.of(context).size.width / 15,
// dataRowHeight: MediaQuery.of(context).size.height / 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    width: 2.0, color: Theme.of(context).dividerColor),
              ),
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.lightBlue),
              border: const TableBorder.symmetric(
                outside: BorderSide(width: 1),
                inside: BorderSide(width: 1),
              ),
              dataRowColor: MaterialStateProperty.all(Colors.white),
              columns: const [
                DataColumn(
                    label: Text(
                  "Descrizione",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Lotto",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Quantità",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Prezzo \n Unitario",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Sconto Riga",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Aliquota",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Conf",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Colli",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
                DataColumn(
                    label: Text(
                  "Note Riga",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                )),
              ],
              rows: [
                for (var element in righe)
                  DataRow(
                    cells: [
                      for (var i = 0; i < 9; i++)
                        DataCell(
                          element["noteagg"] == 'null'
                              ? RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: element[colonne[i]["name"]]
                                        .toString()
                                        .trim(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        String noteagg;

                                        var controller =
                                            TextEditingController();
                                        noteagg = await showDialog(
                                          context: context,
                                          builder: (context2) {
                                            TextEditingController controller =
                                                TextEditingController();
                                            return AlertDialog(
                                              title: const Text(
                                                'Inserisci la NotaAgg',
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      shape:
                                                          const StadiumBorder()),
                                                  onPressed: () async {
                                                    Navigator.of(context2)
                                                        .pop(controller.text);
                                                  },
                                                  child: const Center(
                                                    child: Text(
                                                      'Ok',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'helvetica_neue_light',
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              content: TextField(
                                                controller: controller..text,
                                                keyboardType:
                                                    TextInputType.name,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText:
                                                      'Inserisci la NotaAgg',
                                                  labelText:
                                                      'Inserisci la NotaAgg',
                                                  labelStyle: TextStyle(
                                                      color: Colors.black),
                                                  hintStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                        await updateNoteAgg(
                                                noteagg, element["id_dorig"])
                                            .then((value) =>
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: const Text(
                                                      'NoteAgg Inserita Correttamente'),
                                                  action: SnackBarAction(
                                                    label: 'Chiudi',
                                                    onPressed: () {},
                                                  ),
                                                )));
                                      },
                                  ),
                                )
                              : SizedBox(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: element[colonne[i]["name"]]
                                          .toString()
                                          .trim(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Note Agg',
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        shape:
                                                            const StadiumBorder()),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        'Ok',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'helvetica_neue_light',
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.blue,
                                                        shape:
                                                            const StadiumBorder()),
                                                    onPressed: () async {
                                                      String noteagg;

                                                      var controller =
                                                          TextEditingController();
                                                      controller.text =
                                                          element["noteagg"];

                                                      noteagg =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (context2) {
                                                          TextEditingController
                                                              controller =
                                                              TextEditingController();
                                                          controller.text =
                                                              element[
                                                                  'noteagg'];
                                                          return AlertDialog(
                                                            title: const Text(
                                                              'Inserisci la 2NotaAgg',
                                                            ),
                                                            actions: [
                                                              ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    shape:
                                                                        const StadiumBorder()),
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(
                                                                          context2)
                                                                      .pop(controller
                                                                          .text);
                                                                },
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    'Ok',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'helvetica_neue_light',
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                            content: TextField(
                                                              controller:
                                                                  controller
                                                                    ..text,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .name,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    'Inserisci la NotaAgg',
                                                                labelText:
                                                                    'Inserisci la NotaAgg',
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                hintStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      await updateNoteAgg(
                                                              noteagg,
                                                              element[
                                                                  "id_dorig"])
                                                          .then(
                                                        (value) =>
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                          SnackBar(
                                                            content: const Text(
                                                                'NoteAgg Inserita Correttamente'),
                                                            action:
                                                                SnackBarAction(
                                                              label: 'Chiudi',
                                                              onPressed: () {},
                                                            ),
                                                          ),
                                                        ),
                                                      );

                                                      Navigator.pop(context);
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        'Modifica',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'helvetica_neue_light',
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
// todo copia e incolla
                                                content: InkWell(
                                                  child: Text(
                                                    element["noteagg"],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  onTap: () async {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text: element[
                                                                "noteagg"]));
// ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: const Text(
                                                          'Testo Copiato negli Appunti!'),
                                                      action: SnackBarAction(
                                                        label: 'Chiudi',
                                                        onPressed: () {},
                                                      ),
                                                    ));
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                    ),
                                  ),
                                ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget figlio1(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FittedBox(
              child: Text(
                '${Testa[0]["descrizione"]}',
                softWrap: false,
                textScaleFactor: 1.3,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tipo Documento :',
              softWrap: false,
              textScaleFactor: 1.3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${Testa[0]["cd_do"]}',
              softWrap: false,
              textScaleFactor: 1.3,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Data Documento :',
              softWrap: false,
              textScaleFactor: 1.3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.substring(0, data.indexOf('00:')),
              softWrap: false,
              textScaleFactor: 1.3,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Data Consegna :',
              softWrap: false,
              textScaleFactor: 1.3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              textScaleFactor: 1.3,
              text: TextSpan(
                text: (data_consegna != 'null')
                    ? (data_consegna == '')
                        ? 'Nessuna Data'
                        : data_consegna.substring(
                            0, data_consegna.indexOf('00:'))
                    : 'Nessuna Data',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()..onTap = () async {},
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Evaso da :',
              softWrap: false,
              textScaleFactor: 1.3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: EvasoDa.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RichText(
                        textScaleFactor: 1.2,
                        text: TextSpan(
                          text: '${e["cd_do"]} - ${e["numerodoc"]}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocuPage(
                                    id_dotes: e["id_dotes"],
                                  ),
                                ),
                              );
                            },
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Evaso in :',
              softWrap: false,
              textScaleFactor: 1.3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: EvasoIn.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RichText(
                        textScaleFactor: 1.2,
                        text: TextSpan(
                          text: '${e["cd_do"]} - ${e["numerodoc"]}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocuPage(
                                    id_dotes: e["id_dotes"],
                                  ),
                                ),
                              );
                            },
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Documento collegato:',
              softWrap: false,
              textScaleFactor: 1.2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: LinkCF.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RichText(
                        textScaleFactor: 1.2,
                        text: TextSpan(
                          text: (LinkCF.isNotEmpty)
                              ? '${e["cd_do"]} - ${e["numerodoc"]}'
                              : '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (LinkCF.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DocuPage(
                                              id_dotes: e["id_dotes"],
                                            )));
                              }
                            },
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (scadenza_cliente.isNotEmpty)
              RichText(
                textScaleFactor: 1.3,
                text: TextSpan(
                  text: 'Scadenza cliente',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (scadenza_cliente.first['pagata'] != '0')
                        ? Colors.blue
                        : Colors.red,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (scadenza_cf.isNotEmpty) {
                        await showDialog(
                          builder: (context) => AlertField2(
                            textButton: 'Ok',
                            content:
                                '${scadenza_cliente.first['descrizione']}\nData Scadenza : ${scadenza_cliente.first["datascadenza"].substring(0, scadenza_cliente.first["datascadenza"].indexOf('00:'))}\nDa Pagare : ${scadenza_cliente.first['importoe']}',
                            title: 'Scadenza a Cliente',
                          ),
                          context: context,
                        );
                      }
                    },
                ),
              ),
            if (scadenza_cf.isNotEmpty)
              RichText(
                textScaleFactor: 1.3,
                text: TextSpan(
                  text: 'Scadenza Fornitore',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: (scadenza_cf.first['pagata'] != '0')
                        ? Colors.blue
                        : Colors.red,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (scadenza_cf.isNotEmpty) {
                        await showDialog(
                            builder: (context) => AlertField2(
                                  textButton: 'Ok',
                                  content:
                                      '${scadenza_cf.first['descrizione']}\nData Scadenza : ${scadenza_cf.first["datascadenza"].substring(0, scadenza_cf.first["datascadenza"].indexOf('00:'))}\nDa Pagare : ${scadenza_cf.first['importoe']}',
                                  title: 'Scadenza a Fornitore',
                                ),
                            context: context);
                      }
                    },
                ),
              )
          ],
        ),
      ],
    );
  }
}

duplicaDocumento(
    {required String cd_cf,
    required String id_dotes,
    required String cd_cf2}) async {
  final db = await ProvDatabase.instance.database;
  matematica.Random random = matematica.Random();

  int randomNumber = random.nextInt(99999999) + 1;

  matematica.Random random2 = matematica.Random();

  int random2Number = random.nextInt(99999999) + 1;

  List doc = await db.rawQuery(
      ''' SELECT * FROM dorig where cd_ar != 'null' and cd_ar is not null and id_dotes = '$id_dotes' ''');
  List dotes_prov = await db
      .rawQuery(''' SELECT * FROM dotes_prov where id_dotes = '$id_dotes' ''');
  List cf = await db.rawQuery(
      ''' SELECT * FROM cf where cd_cf in (SELECT cd_cf from dotes where id_dotes = '$id_dotes')''');
  String xclidest = '';

  if (cf != '') {
    xclidest =
        '${cf[0]["localita"].toString().replaceAll('/', '').replaceAll('\'', '')} - ${cf[0]["indirizzo"].toString().replaceAll('/', '').replaceAll('\'', '')} ${cf[0]["cap"].toString().replaceAll('/', '').replaceAll('\'', '')} (${cf[0]["cd_provincia"].toString().replaceAll('/', '').replaceAll('\'', '')}) - ${cf[0]["numero"].toString().replaceAll('/', '').replaceAll('\'', '')}';
  }

  String randomNumero = random2Number.toString();
  if (doc.isNotEmpty) {
    doc.forEach(
      (element) async {
        await ProvDatabase.instance.addCart(
          cd_cf.toString(),
          element["cd_ar"].toString(),
          element["qta"].toString(),
          "null".toString(),
          "null".toString(),
          "null".toString(),
          "null".toString(),
          "null".toString(),
          element["prezzounitariov"].toString(),
          "null".toString(),
          "null".toString(),
          "null".toString(),
          element["scontoriga"].toString(),
          "null".toString(),
          "null".toString(),
          element['note'].toString(),
          "send",
          element["xconfezione"].toString(),
          "null".toString(),
          element["dataconsegna"].toString(),
          "null".toString(),
          randomNumber.toString(),
          "1".toString(),
          "<rows><row nota=\"1\"></row></rows>".toString(),
          element["noteagg"].toString(),
          randomNumero,
        );
      },
    );
    if (dotes_prov.isNotEmpty) {
      dotes_prov.forEach((element) async {
        await ProvDatabase.instance.addDOTes_Prov(
          "7",
          "",
          element["xriffatra"],
          element["xcd_xveicolo"],
          element["ximppag"],
          element["xautista"],
          element["ximpfat"],
          element["xsettimana"],
          element["ximb"],
          element["xacconto"],
          (element["xaccontoF"] == null) ? '' : element["xaccontoF"],
          element["xtipoveicolo"],
          element["xmodifica"],
          element["xurgente"],
          element["xpagata"],
          element["xriford"],
          element["xpagatat"],
          element["xpagataf"],
          (xclidest == '') ? element["xclidest"] : xclidest,
          randomNumber.toString(),
          element["xnumerodocrif"],
          element["datadocrif"],
        );
      });
    }

    if (cd_cf2 != '') {
      final d1b = await ProvDatabase.instance.database;

      doc.forEach(
        (element) async {
          var price = await d1b.rawQuery('''
          SELECT  prezzounitariov from dorig where id_dotes in (select id_dotes from dotes where cd_do = 'CTF') and cd_cf = '${cd_cf2.toString()}' and cd_ar = '${element["cd_ar"].toString()}'   
          ''');
          if (price.isEmpty) {
            price = await d1b.rawQuery('''
          SELECT prezzounitariov from dorig where cd_ar = '${element["cd_ar"].toString()}' and cd_cf = '${cd_cf2.toString()}' order by id_dorig desc
          ''');
          }
          if (price.isEmpty) {
            price = await d1b.rawQuery('''
          SELECT prezzounitariov from dorig where cd_ar = '${element["cd_ar"].toString()}' and cd_cf like 'F%' order by id_dorig desc
          ''');
          }
          await ProvDatabase.instance.addCart(
            cd_cf2.toString(),
            element["cd_ar"].toString(),
            element["qta"].toString(),
            "null".toString(),
            "null".toString(),
            "null".toString(),
            "null".toString(),
            "null".toString(),
            (price[0]["prezzounitariov"].toString() != 'null')
                ? price[0]["prezzounitariov"].toString()
                : '0',
            "null".toString(),
            "null".toString(),
            "null".toString(),
            element["scontoriga"].toString(),
            "null".toString(),
            "null".toString(),
            element['note'].toString(),
            "send",
            element["xconfezione"].toString(),
            "null".toString(),
            element["dataconsegna"].toString(),
            "null".toString(),
            randomNumero,
            "1".toString(),
            "<rows><row nota=\"1\"></row></rows>".toString(),
            element["note_agg"].toString(),
            randomNumber.toString(),
          );
        },
      );
      if (dotes_prov.isNotEmpty) {
        dotes_prov.forEach((element) async {
          await ProvDatabase.instance.addDOTes_Prov(
            "7",
            "",
            element["xriffatra"],
            element["xcd_xveicolo"],
            element["ximppag"],
            element["xautista"],
            element["ximpfat"],
            element["xsettimana"],
            element["ximb"],
            element["xacconto"],
            (element["xaccontoF"] == null) ? '' : element["xaccontoF"],
            element["xtipoveicolo"],
            element["xmodifica"],
            element["xurgente"],
            element["xpagata"],
            element["xriford"],
            element["xpagatat"],
            element["xpagataf"],
            (xclidest == '') ? element["xclidest"] : xclidest,
            randomNumero,
            element["xnumerodocrif"],
            element["datadocrif"],
          );
        });
      }
    }
    return true;
  } else {
    return false;
  }
}

Column figlio3(
    BuildContext context, List totali, List donota, String id_dotes) {
  return Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              var donota_ins;
              var controller = TextEditingController();
              if (donota.isNotEmpty) {
                controller.text = donota[0]["nota"];
              }
            },
            child: Text(
              (donota.isNotEmpty && donota[0]["nota"] != '')
                  ? '${donota[0]["nota"].trimRight().trimLeft()}'
                  : 'Nessuna nota inserita',
              softWrap: false,
              textScaleFactor: 1.2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: (donota.isNotEmpty) ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'IMPONIBILE ',
          softWrap: false,
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${totali[0]["totimponibilev"]}',
          softWrap: false,
          textScaleFactor: 1.2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'IVA ',
          softWrap: false,
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${totali[0]["totimpostav"]}',
          softWrap: false,
          textScaleFactor: 1.2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TOTALE ',
          softWrap: false,
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${totali[0]["totdocumentov"]}',
          softWrap: false,
          textScaleFactor: 1.2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ]);
}

Column quantitatotale(BuildContext context, List somma_qta) {
  return Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Quantita Totale Documento : ',
          softWrap: false,
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${somma_qta[0]["Qta"]}',
          softWrap: false,
          textScaleFactor: 1.2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ]);
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
              blurRadius: 8,
            )
          ]),
      child: MaterialButton(
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

class buildTree extends StatefulWidget {
  const buildTree({
    super.key,
    required this.id_dotes,
  });

  final String? id_dotes;

  @override
  State<buildTree> createState() => _buildTreeState();
}

class _buildTreeState extends State<buildTree> {
  List id_dotes_prov = [];
  final TreeController _controller = TreeController(allNodesExpanded: false);

  String id_dotes = '';
  String xcd_xveicolo = '';
  String xautista = '';
  String ximb = '';
  String xacconto = '';
  String xaccontoF = '';
  String xsettimana = '';
  String xtipoveicolo = '';
  String xmodifica = '';
  String xurgente = '';
  String xpagata = '';
  String xriford = '';
  String xriffatra = '';
  String ximpfat = '';
  String ximppag = '';
  String xpagatat = '';
  String xpagataf = '';
  String xclidest = '';
  String rifordcli = '';
  String datadocrif = '';

  Future refreshTrasporto_tree() async {
    setState(() {
      isLoading = true;
    });

    final d1b = await ProvDatabase.instance.database;

    id_dotes_prov = await d1b.rawQuery(
        "SELECT * FROM dotes_prov where id_dotes = '${widget.id_dotes}'");

    if (id_dotes_prov.isNotEmpty) {
      id_dotes = id_dotes_prov[0]["id_dotes"];
      if (xcd_xveicolo == '') xcd_xveicolo = id_dotes_prov[0]["xcd_xveicolo"];
      if (xautista == '') xautista = id_dotes_prov[0]["xautista"];
      if (ximb == '') ximb = id_dotes_prov[0]["ximb"];
      if (xacconto == '') xacconto = id_dotes_prov[0]["xacconto"];
      if (xaccontoF == '') {
        xaccontoF = (id_dotes_prov[0]["xaccontoF"] != null)
            ? id_dotes_prov[0]["xaccontoF"]
            : '0.00';
      }
      if (xsettimana == '') xsettimana = id_dotes_prov[0]["xsettimana"];
      if (xtipoveicolo == '') xtipoveicolo = id_dotes_prov[0]["xtipoveicolo"];
      if (xmodifica == '') xmodifica = id_dotes_prov[0]["xmodifica"];
      if (xurgente == '') xurgente = id_dotes_prov[0]["xurgente"];
      if (xpagata == '') xpagata = id_dotes_prov[0]["xpagata"];
      if (xriford == '') xriford = id_dotes_prov[0]["xriford"];
      if (xriffatra == '') xriffatra = id_dotes_prov[0]["xriffatra"];
      if (ximpfat == '') ximpfat = id_dotes_prov[0]["ximpfat"];
      if (ximppag == '') ximppag = id_dotes_prov[0]["ximppag"];
      if (xpagatat == '') xpagatat = id_dotes_prov[0]["xpagatat"];
      if (xpagataf == '') xpagataf = id_dotes_prov[0]["xpagataf"];
      if (xclidest == '') xclidest = id_dotes_prov[0]["xclidest"];
      if (rifordcli == '') rifordcli = id_dotes_prov[0]["xnumerodocrif"];
      if (datadocrif == '') datadocrif = id_dotes_prov[0]["datadocrif"];
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshTrasporto_tree();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : TreeView(
            treeController: _controller,
            indent: 0,
            iconSize: 18,
            nodes: [
              TreeNode(
                content: const Text(
                  'Personalizzazioni',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  TreeNode(
                      content: TextButton(
                    onLongPress: () async {
                      await Clipboard.setData(
                          ClipboardData(text: xcd_xveicolo));
// ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Testo Copiato negli Appunti!'),
                        action: SnackBarAction(
                          label: 'Chiudi',
                          onPressed: () {},
                        ),
                      ));
                    },
                    onPressed: () async {},
                    child: Text(
                      'Autoveicolo:$xcd_xveicolo',
                      textScaleFactor: 1.3,
                    ),
                  )),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                              ClipboardData(
                                text: xautista,
                              ),
                            );
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Autista: $xautista ',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: TextButton(
                        onLongPress: () async {
                          await Clipboard.setData(
                              ClipboardData(text: xtipoveicolo));
// ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Testo Copiato negli Appunti!'),
                            action: SnackBarAction(
                              label: 'Chiudi',
                              onPressed: () {},
                            ),
                          ));
                        },
                        onPressed: () async {},
                        child: Text(
                          'Tipo Veicolo: $xtipoveicolo ',
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.lightBlue,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'Riferimento Fattura Trasportatore : $xriffatra',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: ximpfat));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Fatt Tra: $ximpfat',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: ximppag));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Importo Pagato Trasportatore: $ximppag',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(ClipboardData(text: ximb));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Imballo : $ximb',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xurgente));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Urgente:$xurgente',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xmodifica));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Modifica:$xmodifica',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xsettimana));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Settimana:$xsettimana',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: TextButton(
                        onLongPress: () async {
                          await Clipboard.setData(
                              ClipboardData(text: xclidest));
// ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Testo Copiato negli Appunti!'),
                            action: SnackBarAction(
                              label: 'Chiudi',
                              onPressed: () {},
                            ),
                          ));
                        },
                        onPressed: () async {
                          var controller = TextEditingController();
                          controller.text = xclidest;
                          xclidest = await showDialog(
                            context: context,
                            builder: (context2) {
                              TextEditingController controller =
                                  TextEditingController();
                              return AlertDialog(
                                title: const Text(
                                  'Inserisci l\'Autoveicolo desiderato',
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () async {
                                      print(controller.text);
                                      Navigator.of(context2)
                                          .pop(controller.text);
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'helvetica_neue_light',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                                content: TextField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(300),
                                  ],
                                  onTap: (() async {
                                    controller.text =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CercaCliente(),
                                      ),
                                    );
                                  }),
                                  controller: controller..text,
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Inserisci l\'xclidest desiderato',
                                    labelText:
                                        'Inserisci l\'xclidest desiderato',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Text(
                          'Cliente Destinatario : $xclidest',
                          textScaleFactor: 1.3,
                          style: TextStyle(
                              color:
                                  (xclidest == '') ? Colors.red : Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: rifordcli));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Riferimento Ordine Cliente: $rifordcli',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xriford));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Nostro RifOrd:$xriford',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xacconto));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Acconto:$xacconto',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xaccontoF));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'AccontoF: $xaccontoF',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xpagata));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'Pagata:$xpagata',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xpagatat));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'PagataT:$xpagatat',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: xpagataf));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'PagataF:$xpagataf',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TreeNode(
                    content: Flexible(
                      child: FittedBox(
                        child: TextButton(
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: datadocrif));
// ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  const Text('Testo Copiato negli Appunti!'),
                              action: SnackBarAction(
                                label: 'Chiudi',
                                onPressed: () {},
                              ),
                            ));
                          },
                          onPressed: () async {},
                          child: Text(
                            'DataDocRif: $datadocrif',
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}

Future send_mail(var json) async {
  final response = await http.post(
    Uri.parse('https://bohagent.cloud/api/b2b/set_mail/PROV1234'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(json),
  );

  if (response.statusCode == 200) {
    return 1;
  } else {
    return 0;
  }
}

Future updateNoteAgg(String NoteAgg, String id_dorig) async {
  if (NoteAgg == '') NoteAgg = 'null';

  NoteAgg = NoteAgg.replaceAll('\'', '').replaceAll('&', '');

  final response = await http.post(
    Uri.parse('https://bohagent.cloud/api/b2b/update_NOTE/$id_dorig/PROV1234'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{"NoteAgg": NoteAgg}),
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    return response;
  }
}

Future updateDataCons(String datacons, String id_dotes) async {
  if (datacons == '') datacons = 'null';

  datacons = datacons.replaceAll('\'', '').replaceAll('&', '');
  if (datacons != 'null') {
    var Query =
        'UPDATE DOTES set DataConsegna = \'${datacons.toString()}\' where id_dotes = ${id_dotes.toString()}';
    final response = await http.post(
      Uri.parse('https://b2bincloud.it/admin/insert_xquery/7'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        "query": Query,
        "id_dotes": "SELECT TOP 1 id_dotes FROM DOTES where cd_do = 'OVC'",
        "id_dotes_ovc": "SELECT TOP 1 id_dotes FROM DOTES where cd_do = 'OVC'"
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      return response;
    }
  }
}

Future ins_nota(String nota, String id_dotes) async {
  String xQuery =
      'UPDATE DOTES set NoteXML = \'<rows><row nota=\\"1\\">${nota.replaceAll('\'', '').replaceAll('\\', '').replaceAll('/', '')}</row></rows>\' WHERE id_dotes = \'$id_dotes\'';

  final response = await http.post(
    Uri.parse('https://b2bincloud.it/admin/insert_xquery/7'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      "query": xQuery,
      "id_dotes": "SELECT TOP 1 id_dotes FROM DOTES where cd_do = 'OVC'",
      "id_dotes_ovc": "SELECT TOP 1 id_dotes FROM DOTES where cd_do = 'OVC'"
    }),
  );

  log(jsonEncode(<String, String>{
    "query": xQuery,
    "id_dotes": "SELECT TOP 1 id_dotes FROM DOTES where cd_do = 'OVC'",
    "id_dotes_ovc": "SELECT TOP 1 id_dotes FROM DOTES where cd_do = 'OVC'"
  }));
  if (response.statusCode == 200) {
    log('TUTTO OK ');
    log(response.toString());
    return 'ok';
  } else {
    log(response.toString());
    return 'not ok';
  }
}
