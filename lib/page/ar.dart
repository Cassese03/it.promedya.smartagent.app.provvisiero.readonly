// ignore_for_file: prefer_conditional_assignment, unnecessary_null_comparison, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/model/cf.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provvisiero_readonly/model/dotes_prov.dart';
import 'package:provvisiero_readonly/model/dorig.dart';
import 'package:provvisiero_readonly/model/dotes.dart';
import 'package:provvisiero_readonly/model/dototali.dart';
import 'package:provvisiero_readonly/model/ls.dart';
import 'package:provvisiero_readonly/model/lsarticolo.dart';
import 'package:provvisiero_readonly/model/lsrevisione.dart';
import 'package:provvisiero_readonly/model/lsscaglione.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ar.dart';
import '../model/mggiac.dart';
import 'package:loading_animations/loading_animations.dart';
import '../model/sc.dart';
import 'dettaglio.dart';
import 'drawer.dart';

class ARPage extends StatefulWidget {
  const ARPage({super.key, this.cd_cf});

  final String? cd_cf;
  @override
  _ARPageState createState() => _ARPageState();
}

class _ARPageState extends State<ARPage> {
  late List<AR> articoli;
  bool isLoading = false;
  bool isDownloading = false;
  bool isSending = false;
  TextEditingController textController = TextEditingController();
  late bool internet;

  @override
  void initState() {
    super.initState();

    refreshProv();
  }

  Future<http.Response> sendCart(cart) async {
    final response = await http.post(
      Uri.parse('https://bohagent.cloud/api/b2b/set_provvisiero_cart/PROV1234'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'cd_ar': cart.cd_ar.toString(),
        'id_ditta': '7',
        'cd_cf': cart.cd_cf.toString(),
        //'cd_cfsede': cart.cd_cfsede.toString(),
        //'cd_cfdest': cart.cd_cfdest.toString(),
        //'cd_agente_1': cart.cd_agente_1.toString(),
        'qta': '${cart.qta}',
        'xcolli': '0',
        'xbancali': '0',
        'prezzo_unitario': cart.prezzo_unitario.toString(),
        'cd_aliquota': '22',
        'aliquota': '22',
        //'totale': '0',
        //'imposta': '0',
        //'da_inviare': '0',
        'note': '',
        'scontoriga': '0',
        'xconfezione': cart.confezione.toString(),
        'note_agg': cart.note_agg.toString(),
      }),
    );
    //print(response.body);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return response;
    }
  }

  // ignore: non_constant_identifier_names

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

  Future<List<AR>> get_ar(String lastAr) async {
    if (lastAr == null) lastAr = '0';

    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/ar/PROV1234/$lastAr';

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
    if (lastDotes == null) lastDotes = '0';

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

  Future<List<DORig>> get_dorig(String lastDorig) async {
    if (lastDorig == null) lastDorig = '0';

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
    if (lastDotes == null) lastDotes = '0';

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

  Future<List<DOTes_Prov>> get_dotes_prov(String lastDotesProv) async {
//    print('https://bohagent.cloud/api/b2b/get_provvisiero/dotes_provvisiero/PROV1234/$last_dotes_prov');
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

  Future refreshProv() async {
    setState(() => isLoading = true);

    internet = await InternetConnectionChecker().hasConnection;

    articoli = await ProvDatabase.instance.readAllAR();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Articoli',
          style: TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.lightBlue,
        actions: [
          /*
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              showSearch(context: context, delegate: MySearchDelegate());
            },
          )*/
          AnimSearchBar2(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              suffixIcon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              color: Colors.lightBlue,
              width: MediaQuery.of(context).size.width,
              textController: textController,
              onSuffixTap: () async {
                String ricerca = textController.text;
                final db = await ProvDatabase.instance.database;
                if (ricerca != '') {
                  articoli = await ProvDatabase.instance
                      .readAllARFilter(filtro: ricerca);
                } else {
                  articoli = await ProvDatabase.instance.readAllAR();
                }
                textController.clear();

                setState(() => isLoading = false);
              })
        ],
      ),
      drawer: const MyDrawer(),
      body: Center(
          child: isSending
              ? Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text('Creazione Ordini da Carrello in corso'),
                      //Image.asset('assets/logo.png'),
                      const SizedBox(
                        height: 50,
                        width: double.infinity,
                      ),
                      LoadingJumpingLine.circle()
                    ],
                  ),
                )
              : isDownloading
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
                  : isLoading
                      ? const CircularProgressIndicator()
                      : articoli.isEmpty
                          ? const Stack(
                              children: [
                                Text(
                                  'Nessun Articolo',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              ],
                            )
                          : Container(
                              color: Colors.lightBlue,
                              child: GridView.builder(
                                itemCount: articoli.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: (1 / 1),
                                ),
                                itemBuilder: (
                                  context,
                                  index,
                                ) {
                                  return GestureDetector(
                                      onTap: () {
                                        int prod = articoli[index].id ?? 0;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductPage(
                                                  image:
                                                      articoli[index].immagine,
                                                  prod: prod,
                                                  cd_cf: widget.cd_cf),
                                            ));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(32),
                                        child: Container(
                                          color: Colors.blueAccent,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: LayoutBuilder(
                                              builder: (context, constraints) {
                                                return FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: SizedBox(
                                                    width: constraints.maxWidth,
                                                    height:
                                                        constraints.maxHeight,
                                                    child: Text(
                                                      articoli[index]
                                                          .descrizione,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          //   Column(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.spaceEvenly,
                                          //     children: [
                                          //       ClipRRect(
                                          //         borderRadius:
                                          //             BorderRadius.circular(32),
                                          //         child: Container(
                                          //             child: articoli[index]
                                          //                         .immagine !=
                                          //                     'null'
                                          //                 ? internet
                                          //                     ? Image.network(
                                          //                         articoli[index]
                                          //                             .immagine,
                                          //                         width: 120,
                                          //                         height: 100,
                                          //                         fit:
                                          //                             BoxFit.fill,
                                          //                       )
                                          //                     : Image.asset(
                                          //                         'assets/nophoto.jpg',
                                          //                         width: 120,
                                          //                         height: 100,
                                          //                         fit:
                                          //                             BoxFit.fill,
                                          //                       )
                                          //                 : Image.asset(
                                          //                     'assets/nophoto.jpg',
                                          //                     width: 120,
                                          //                     height: 100,
                                          //                     fit: BoxFit.fill,
                                          //                   )),
                                          //       ),
                                          //       Text(articoli[index].descrizione,
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //           style: const TextStyle(
                                          //               fontSize: 16,
                                          //               color: Colors.white),
                                          //           textAlign: TextAlign.center),
                                          //     ],
                                          //   ),
                                        ),
                                      ));
                                },
                              ))));
}

//class MySearchDelegate extends SearchDelegate {}
