// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../db/databases.dart';

String prezzo = '1.00';
String prezzototale = '0.00';
bool isLoading = false;
String cd_ar = '';

class ProductPage extends StatefulWidget {
  static const String id = '/ProductPage';
  final String image;
  const ProductPage(
      {super.key, required this.image, required this.prod, this.cd_cf});
  final int prod;
  final String? cd_cf;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late List colonne;
  String noteAgg = '';
  late List righe;
  bool internet = false;
  final int _quantita = 1;
  final double _sconto_riga = 0.00;
  List articolo = [];
  List arcodcf = [];
  List giacenza = [];
  bool isLoading = true;
  late Timer timer;
  late String xstato;
  @override
  void initState() {
    super.initState();
    refreshAR();
    calcolaprezzo();
    if (mounted) {
      timer = Timer.periodic(
          const Duration(seconds: 1), (Timer t) => _prezzototale());
    }
  }

  Future calcolaprezzo() async {
    setState(() {
      isLoading = true;
    });
    final db = await ProvDatabase.instance.database;
    List cdAr2 = await db.rawQuery(
        'SELECT * from ar where id_ditta = \'7\' and id  =  ${widget.prod}');
    String cdAr1 = cdAr2[0]["cd_ar"];
    List check = await db.rawQuery(
        'SELECT * FROM dorig WHERE id_ditta = \'7\' AND id_dotes in (SELECT id_dotes from dotes where cd_do = \'CTC\') AND cd_ar = \'$cdAr1\' order by id DESC LIMIT 1');

    if (check.isEmpty) {
      check = await db.rawQuery(
          'SELECT * FROM dorig WHERE id_ditta = \'7\' AND cd_cf = \'${widget.cd_cf}\' AND cd_ar = \'$cdAr1\' order by id DESC LIMIT 1');
    }
    if (check.isEmpty) {
      check = await db.rawQuery(
          "SELECT * FROM dorig WHERE id_ditta = '7' AND id_dotes in (SELECT id_dotes from dotes where cd_do = 'CLC' AND cd_cf = '${widget.cd_cf}') AND cd_ar = '$cdAr1'  order by id DESC LIMIT 1");
    }
    if (check.isEmpty) {
      prezzo = '1';
    } else {
      if (check[0]["cd_do"] != 'CLC') {
        prezzo = check[0]["prezzounitariov"];
      } else {
        prezzo = check[0]["prezzounitariov"] - check[0]["prezzoaddizionalev"];
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future _prezzototale() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var prezzototalex = ((_quantita).toDouble() * double.parse(prezzo));
    if (_sconto_riga > 0) {
      var sconto = (prezzototalex / 100) * _sconto_riga;
      prezzototale = (prezzototalex - sconto).toString();
    } else {
      prezzototale = prezzototalex.toString();
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future refreshAR() async {
    setState(() {
      isLoading = true;
    });
    final db = await ProvDatabase.instance.database;
    var id = widget.prod;
    articolo = await db
        .rawQuery('SELECT * from ar where id_ditta = \'7\' and id  = $id');
    cd_ar = articolo[0]["cd_ar"];

    articolo = await db
        .rawQuery('SELECT * from ar where id_ditta = \'7\' and id  = $id');

    internet = await InternetConnectionChecker().hasConnection;
    colonne = await db.rawQuery("PRAGMA table_info(mggiac)", null);
    righe = await db.rawQuery(
        "SELECT * FROM mggiac where cd_ar = '${articolo[0]["cd_ar"]}'", null);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
// return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(children: [
//             // Column(
//             //   children: colonne.map((e) => Text(e.toString())).toList(),
//             // ),
//             // Divider(),
//             // Column(
//             //   children: righe.map((e) => Text(e.toString())).toList(),
//             // ),

//             Column(
//               children: righe
//                   .map(
//                     (e) => Text(
//                       e["cd_mg"].toString(),
//                     ),
//                   )
//                   .toList(),
//             )
// //  Column(
// //                 children: ((righe
// //                             .map((e) => e)
// //                             .toList()
// //                             .map((e) => e.entries)
// //                             .toList() as List<dynamic>)
// //                         .first
// //                         .toList() as List<MapEntry<String, dynamic>>)
// //                     .map((e) => Text("Key ${e.key} - Value ${e.value}"))
// //                     .toList())
//           ]),
//         ),
//       ),
//     );

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                articolo[0]["cd_ar"],
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.lightBlue,
              actions: const [],
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 35,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                ),
                              ),
                              child: FractionallySizedBox(
                                heightFactor: 0.9,
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 15,
                                      child: Center(
                                        child: Text(
                                          '${articolo[0]["cd_ar"]}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    (articolo[0]["dms"] != 'null')
                                        ? Expanded(
                                            flex: 10,
                                            child: ElevatedButton(
                                              onPressed: (() async {
                                                if (articolo[0]["dms"] !=
                                                    'null') {
                                                  launchUrl(
                                                    Uri.parse(
                                                      (articolo[0]["dms"]
                                                          .toString()),
                                                    ),
                                                  );
                                                }
                                              }),
                                              child: const Text('Allegato'),
                                            ),
                                          )
                                        : Expanded(
                                            flex: 10,
                                            child: ElevatedButton(
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll<
                                                        Color>(Colors.red),
                                              ),
                                              child:
                                                  const Text('Nessun Allegato'),
                                              onPressed: () {},
                                            ),
                                          ),
                                    const Spacer(
                                      flex: 5,
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: (() async {
                                              return showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  String? quantita;
                                                  final screenWidth =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width;
                                                  return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          12.0,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.lightBlue,
                                                      content: SafeArea(
                                                        child: (Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            color: Color(
                                                                0x00ffffff),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        12.0)),
                                                          ),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            child: Container(
                                                              /* height:
                                                       (MediaQuery.of(context)
                                                               .size
                                                               .height) /
                                                           3,*/
                                                              color:
                                                                  Colors.grey,
                                                              /*padding:
                                                       EdgeInsets.fromLTRB(
                                                           0, 2, 0, 2),*/
                                                              width:
                                                                  screenWidth,
                                                              child: DataTable(
                                                                  headingRowColor:
                                                                      WidgetStateColor.resolveWith((states) =>
                                                                          Colors
                                                                              .lightBlue),
                                                                  border: const TableBorder
                                                                      .symmetric(
                                                                    outside: BorderSide(
                                                                        width:
                                                                            1),
                                                                    inside: BorderSide(
                                                                        width:
                                                                            1),
                                                                  ),
                                                                  dataRowColor:
                                                                      WidgetStateProperty.all(
                                                                          Colors
                                                                              .white),
                                                                  columns: [
                                                                    for (var element
                                                                        in colonne)
                                                                      if (element[
                                                                              "name"] !=
                                                                          'id')
                                                                        if (element["name"] !=
                                                                            'id_ditta')
                                                                          if (element["name"] !=
                                                                              'cd_ar')
                                                                            if (element["name"] !=
                                                                                'disponibile')
                                                                              DataColumn(
                                                                                  label: Text(
                                                                                (element["name"].toString() == 'cd_mg') ? 'Magazzino' : element["name"].toString(),
                                                                                style: const TextStyle(color: Colors.black),
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                  ],
                                                                  rows: [
                                                                    for (var element
                                                                        in righe)
                                                                      DataRow(
                                                                          cells: [
                                                                            for (var i = 0;
                                                                                i < colonne.length;
                                                                                i++)
                                                                              if (colonne[i]["name"] != 'id')
                                                                                if (colonne[i]["name"] != 'id_ditta')
                                                                                  if (colonne[i]["name"] != 'cd_ar')
                                                                                    if (colonne[i]["name"] != 'disponibile')
                                                                                      DataCell(
                                                                                        Text(
                                                                                          element[colonne[i]["name"]].toString(),
                                                                                          style: const TextStyle(color: Colors.black),
                                                                                          textAlign: TextAlign.center,
                                                                                        ),
                                                                                      ),
                                                                          ]),
                                                                  ]),
                                                            ),
                                                          ),
                                                        )),
                                                      ));
                                                },
                                              );
                                            }),
                                            child: const Text("Giacenza"),
                                          ),
                                          Row(children: [
                                            const Text('Prezzo: '),
                                            ElevatedButton(
                                              onPressed: (() async {}),
                                              child: Text(prezzo),
                                            ),
                                          ])
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      flex: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          (articolo[0]["xcd_xcalibro"] !=
                                                  'null')
                                              ? Row(children: [
                                                  const Text("Varieta' "),
                                                  ElevatedButton(
                                                    onPressed: (() {}),
                                                    child: Text(
                                                      '${articolo[0]["xcd_xvarieta"]}',
                                                    ),
                                                  ),
                                                ])
                                              : const Spacer(),
                                          (articolo[0]["xcd_xcalibro"] !=
                                                  'null')
                                              ? Row(children: [
                                                  const Text('Calibro '),
                                                  ElevatedButton(
                                                    onPressed: (() {}),
                                                    child: Text(
                                                      '${articolo[0]["xcd_xcalibro"]}',
                                                    ),
                                                  ),
                                                ])
                                              : const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'DESCRIZIONE',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Text('${articolo[0]["descrizione"]}'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 40,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Spacer(),
                                    Expanded(
                                      child: Text(
                                        'Solo AMMINISTRAZIONE.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
  }
}
