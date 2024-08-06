// ignore_for_file: unused_field, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/page/dettaglio_docu.dart';
import '../db/databases.dart';
import 'package:collection/collection.dart' as c;

bool isLoading = false;

class AltriPage extends StatefulWidget {
  static const String id = '/AltriPage';

  const AltriPage({super.key, required this.date});

  final String date;

  @override
  State<AltriPage> createState() => _AltriPageState();
}

class _AltriPageState extends State<AltriPage>
    with SingleTickerProviderStateMixin {
  late List fut = [];
  late var grouptra = {};
  late var tra = [];
  List tot_vett = [];
  TextEditingController textController = TextEditingController();
  bool isLoading = true;
  late TabController _tabController;
  String Data = '';
  @override
  void initState() {
    super.initState();

    Data = widget.date.toString();

    refreshDocumenti();

    _tabController = TabController(vsync: this, length: 1);
  }

  Future refreshDocumenti() async {
    setState(() {
      isLoading = true;
    });

    final db = await ProvDatabase.instance.database;

    var trans = DateFormat("dd-MM-yyyy").parse(Data).toString();

    String id = trans.substring(0, 19);

    // fut = await db.rawQuery(
    //     'SELECT DISTINCT d.datadoc,d.cd_cf, (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione from dotes d where d.id_ditta = \'7\' and d.datadoc  > \'$id\' order by d.datadoc ');

    tra = await db.rawQuery(
      '''SELECT f.*,
      (SELECT iif(SUM(CAST(dp2.ximpfat as decimal (10,2))) is null,0,SUM(CAST(dp2.ximpfat as decimal (10,2))))
      FROM dotes_prov dp2
      LEFT JOIN dotes d ON dp2.id_dotes = d.id_dotes
      WHERE (dp2.xpagatat = 'null' or dp2.xpagatat IS NULL) AND (dp2.xriffatra = 'null' or dp2.xriffatra IS NULL) AND d.cd_do = 'OVC' AND dp2.xautista = f.xautista) 
      AS tot_pagare,
      (SELECT iif(SUM(CAST(dp2.ximpfat as decimal (10,2))) is null,0,SUM(CAST(dp2.ximpfat as decimal (10,2))))
      FROM dotes_prov dp2
      LEFT JOIN dotes d ON dp2.id_dotes = d.id_dotes
      WHERE (dp2.xpagatat = 'null' or dp2.xpagatat IS NULL) AND (dp2.xriffatra != 'null' and dp2.xriffatra != '' and dp2.xriffatra != ' ' and dp2.xriffatra IS NOT NULL ) AND d.cd_do = 'OVC' AND dp2.xautista = f.xautista) 
      AS tot_pagare_P
       FROM (SELECT d.*,dp.*,dotes2.cd_do as doc_evaso,
       iif(dp.xriffatra != 'null',(SELECT cd_do from dotes where replace(numerodocrif,' ','') = dp.xriffatra),'' )  as Doc_Trasporto,
      iif(dp.xriffatra != 'null',(SELECT numerodoc from dotes where replace(numerodocrif,' ','') = dp.xriffatra),'') as NumeroDoc_Trasporto,           
      (select SUM(qta) from dorig where id_dotes = d.id_dotes) as qta, 
      (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes) as qtaevadibile,
      (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione 
      from dotes d 
      left join dotes_prov dp on dp.id_dotes = d.id_dotes 
      left join dorig do on do.id_dotes = d.id_dotes 
      left join dorig d2 on d2.id_dorig_evade = do.id_dorig 
      left join dotes dotes2 on d2.id_dotes = dotes2.id_dotes 
      where d.id_ditta = '7' and d.cd_do = 'OVC' and dp.xautista != 'null' and d.datadoc >= '2023-10-09'
      and d.id_dotes in (SELECT id_dotes FROM dotes_prov where (xpagatat = 'null' or xpagatat IS NULL)) 
      order by dp.xautista desc,dp.xsettimana asc) f
      ''',
    );

    //print(tra);

    //grouptra = c.groupBy(tra, (tra) => (tra as List<dynamic>)["xautista"]);

    grouptra = c.groupBy(
      tra,
      (p0) => (p0 as Map<String, Object?>)["xautista"],
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String old_vet = '';
    if (isLoading == true) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return Scaffold(
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
            widget.date,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.lightBlue,
          actions: [
            AnimSearchBar2(
                helpText: 'Inserire il codice di riferimneto ORDINE...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                color: Colors.lightBlue,
                width: 380,
                textController: textController,
                onSuffixTap: () async {
                  //Data = widget.date.toString();
                  //var trans = DateFormat("dd-MM-yyyy").parse('$Data').toString();
                  //String id = trans.substring(0, 19);
                  String ricerca = textController.text;
                  final db = await ProvDatabase.instance.database;

                  if (ricerca != '') {
                    tra = await db.rawQuery(
                      '''SELECT f.*,
                        (SELECT iif(SUM(CAST(dp2.ximpfat as decimal (10,2))) is null,0,SUM(CAST(dp2.ximpfat as decimal (10,2))))
                        FROM dotes_prov dp2
                        LEFT JOIN dotes d ON dp2.id_dotes = d.id_dotes
                        WHERE (dp2.xpagatat = 'null' or dp2.xpagatat IS NULL) AND (dp2.xriffatra = 'null' or dp2.xriffatra IS NULL) AND d.cd_do = 'OVC' AND dp2.xautista = f.xautista) 
                        AS tot_pagare,
                        (SELECT iif(SUM(CAST(dp2.ximpfat as decimal (10,2))) is null,0,SUM(CAST(dp2.ximpfat as decimal (10,2))))
                        FROM dotes_prov dp2
                        LEFT JOIN dotes d ON dp2.id_dotes = d.id_dotes
                        WHERE (dp2.xpagatat = 'null' or dp2.xpagatat IS NULL) AND (dp2.xriffatra != 'null' and dp2.xriffatra != '' and dp2.xriffatra != ' ' and dp2.xriffatra IS NOT NULL ) AND d.cd_do = 'OVC' AND dp2.xautista = f.xautista) 
                        AS tot_pagare_P
                        FROM (SELECT d.*,dp.*,dotes2.cd_do as doc_evaso,
                        iif(dp.xriffatra != 'null',(SELECT cd_do from dotes where replace(numerodocrif,' ','') = dp.xriffatra),'' )  as Doc_Trasporto,
                        iif(dp.xriffatra != 'null',(SELECT numerodoc from dotes where replace(numerodocrif,' ','') = dp.xriffatra),'') as NumeroDoc_Trasporto,           
                        (select SUM(qta) from dorig where id_dotes = d.id_dotes) as qta, 
                        (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes) as qtaevadibile,
                        (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione 
                        from dotes d 
                        left join dotes_prov dp on dp.id_dotes = d.id_dotes 
                        left join dorig do on do.id_dotes = d.id_dotes 
                        left join dorig d2 on d2.id_dorig_evade = do.id_dorig 
                        left join dotes dotes2 on d2.id_dotes = dotes2.id_dotes 
                        where d.id_ditta = '7' and d.cd_do = 'OVC' and dp.xriford like '%$ricerca%' and dp.xautista != 'null' and d.datadoc >= '2023-10-09'
                        and d.id_dotes in (SELECT id_dotes FROM dotes_prov where (xpagatat = 'null' or xpagatat IS NULL)) 
                        order by dp.xautista desc,dp.xsettimana asc) f
                      ''',
                    );
                  } else {
                    tra = await db.rawQuery('''SELECT f.*,
                          (SELECT iif(SUM(CAST(dp2.ximpfat as decimal (10,2))) is null,0,SUM(CAST(dp2.ximpfat as decimal (10,2))))
                          FROM dotes_prov dp2
                          LEFT JOIN dotes d ON dp2.id_dotes = d.id_dotes
                          WHERE (dp2.xpagatat = 'null' or dp2.xpagatat IS NULL) AND (dp2.xriffatra = 'null' or dp2.xriffatra IS NULL) AND d.cd_do = 'OVC' AND dp2.xautista = f.xautista) 
                          AS tot_pagare,
                          (SELECT iif(SUM(CAST(dp2.ximpfat as decimal (10,2))) is null,0,SUM(CAST(dp2.ximpfat as decimal (10,2))))
                          FROM dotes_prov dp2
                          LEFT JOIN dotes d ON dp2.id_dotes = d.id_dotes
                          WHERE (dp2.xpagatat = 'null' or dp2.xpagatat IS NULL) AND (dp2.xriffatra != 'null' and dp2.xriffatra != '' and dp2.xriffatra != ' ' and dp2.xriffatra IS NOT NULL ) AND d.cd_do = 'OVC' AND dp2.xautista = f.xautista) 
                          AS tot_pagare_P
                          FROM (SELECT d.*,dp.*,dotes2.cd_do as doc_evaso,
                          iif(dp.xriffatra != 'null',(SELECT cd_do from dotes where replace(numerodocrif,' ','') = dp.xriffatra),'' )  as Doc_Trasporto,
                          iif(dp.xriffatra != 'null',(SELECT numerodoc from dotes where replace(numerodocrif,' ','') = dp.xriffatra),'') as NumeroDoc_Trasporto,           
                          (select SUM(qta) from dorig where id_dotes = d.id_dotes) as qta, 
                          (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes) as qtaevadibile,
                          (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione 
                          from dotes d 
                          left join dotes_prov dp on dp.id_dotes = d.id_dotes 
                          left join dorig do on do.id_dotes = d.id_dotes 
                          left join dorig d2 on d2.id_dorig_evade = do.id_dorig 
                          left join dotes dotes2 on d2.id_dotes = dotes2.id_dotes 
                          where d.id_ditta = '7' and d.cd_do = 'OVC' and dp.xautista != 'null' and d.datadoc >= '2023-10-09'
                          and d.id_dotes in (SELECT id_dotes FROM dotes_prov where (xpagatat = 'null' or xpagatat IS NULL)) 
                          order by dp.xautista desc,dp.xsettimana asc) f
                          ''');
                  }
                  grouptra = c.groupBy(
                    tra,
                    (p0) => (p0 as Map<String, Object?>)["xautista"],
                  );
                  textController.clear();

                  setState(
                    () => isLoading = false,
                  );
                })
          ],
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    flex: 90,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 8.0),
                      shrinkWrap: true,
                      children: grouptra.entries
                          .map(
                            (e) => SizedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Card(
                                    color: Colors.lightBlue,
                                    child: ListTile(
                                      onTap: () {},
                                      title: Center(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${e.key.toString()} - ${(e.value as List).first["tot_pagare"]} € (${(e.value as List).first["tot_pagare_P"]}€)',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: (e.value as List)
                                        .map(
                                          (e) => Card(
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DocuPage(
                                                      id_dotes: e["id_dotes"]
                                                          .toString(),
                                                    ),
                                                  ),
                                                );
                                              },
                                              leading: const Icon(
                                                  Icons.feed_outlined),
                                              title: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: (e["xriffatra"] !=
                                                                null &&
                                                            e["xriffatra"]
                                                                    .toString() !=
                                                                'null')
                                                        ? Colors.black
                                                        : (e["qtaevadibile"] !=
                                                                    e["qta"] ||
                                                                e["qtaevadibile"] ==
                                                                    0)
                                                            ? (e["doc_evaso"] !=
                                                                    'null')
                                                                ? Colors.green
                                                                : Colors.red
                                                            : Colors.red,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            '${e["cd_do"]} - ${e["doc_evaso"]} ',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    TextSpan(
                                                        text:
                                                            ' N° ${e["numerodoc"]} [${e["xriford"]}] (${e["xsettimana"]})  - ${e["descrizione"]}'),
                                                    // TextSpan(
                                                    //   text:
                                                    //       ' | ${e["NumeroDoc_Trasporto"]} | ${e["Doc_Trasporto"]}',
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              trailing: IconButton(
                                                icon: const Icon(
                                                    Icons.info_outline),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        DocuPage(
                                                            id_dotes:
                                                                e["id_dotes"]),
                                                  ));
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: SizedBox(
                      //height: MediaQuery.of(context).size.height / 18,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 3,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 20,
                              child: Text(
                                'EVASO IN FATTURA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 20,
                              child: Text(
                                'NON EVASO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 20,
                              child: Text(
                                'EVASO NON IN FATTURA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        //       DefaultTabController(
        //           length: 2,
        //           child: Container(
        //             decoration: BoxDecoration(
        //                 gradient: LinearGradient(
        //               begin: Alignment.topCenter,
        //               end: Alignment.bottomCenter,
        //               colors: [Colors.white, Colors.grey.shade200],
        //             )),
        //             child: SingleChildScrollView(
        //               physics: const BouncingScrollPhysics(),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 children: [
        //                   TabBar(
        //                     controller: _tabController,
        //                     tabs: [
        //                       //   Tab(
        //                       //     child: RichText(
        //                       //       text: TextSpan(
        //                       //         style: const TextStyle(
        //                       //           fontSize: 14.0,
        //                       //           color: Colors.lightBlue,
        //                       //         ),
        //                       //         children: <TextSpan>[
        //                       //           TextSpan(
        //                       //               text: (fut.isEmpty)
        //                       //                   ? 'Futuri'
        //                       //                   : 'Futuri (${fut.length})',
        //                       //               style: const TextStyle(
        //                       //                   fontWeight: FontWeight.bold)),
        //                       //         ],
        //                       //       ),
        //                       //     ),
        //                       //   ),
        //                       Tab(
        //                         child: RichText(
        //                           text: TextSpan(
        //                             style: const TextStyle(
        //                               fontSize: 14.0,
        //                               color: Colors.lightBlue,
        //                             ),
        //                             children: <TextSpan>[
        //                               TextSpan(
        //                                   text: (tra.isEmpty)
        //                                       ? 'Trasporti'
        //                                       : 'Trasporti (${tra.length})',
        //                                   style: const TextStyle(
        //                                       fontWeight: FontWeight.bold)),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                   SizedBox(
        //                     width: MediaQuery.of(context).size.width,
        //                     height: MediaQuery.of(context).size.height,
        //                     child: TabBarView(
        //                       controller: _tabController,
        //                       children: [
        //                         tra.isEmpty
        //                             ? const Tab(
        //                                 text: 'NESSUN  DI TRASPORTO.',
        //                               )
        //                             :
        //                       ],
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
      );
    }
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
