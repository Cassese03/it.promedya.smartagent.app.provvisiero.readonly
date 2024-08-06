import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/altri_doc.dart';
import 'package:provvisiero_readonly/page/cerca_doc_varieta.dart';

class CercaVarieta extends StatefulWidget {
  const CercaVarieta({super.key});

  @override
  State<CercaVarieta> createState() => _CercaVarietaState();
}

List varieta = [];

class _CercaVarietaState extends State<CercaVarieta> {
  @override
  void initState() {
    super.initState();

    refreshvarieta();
  }

  Future refreshvarieta() async {
    setState(() {
      isLoading = true;
    });
    final db = await ProvDatabase.instance.database;

    varieta = await db.rawQuery(
        'SELECT DISTINCT xcd_xvarieta FROM ar WHERE xcd_xvarieta != \'null\'');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Cerca Varieta',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            AnimSearchBar2(
                helpText: 'Cerca Varieta...',
                closeSearchOnSuffixTap: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                color: Colors.lightBlue,
                width: MediaQuery.of(context).size.width - 10,
                textController: textController,
                onSuffixTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String ricerca = textController.text;
                  final db = await ProvDatabase.instance.database;

                  if (ricerca == '') {
                    varieta = await db.rawQuery(
                        'SELECT DISTINCT xcd_xvarieta FROM ar where xcd_xvarieta != \'null\'');
                  } else {
                    varieta = await db.rawQuery(
                        'SELECT DISTINCT xcd_xvarieta FROM ar where xcd_xvarieta != \'null\' and xcd_xvarieta like \'%$ricerca%\' or descrizione like \'%$ricerca%\'');
                  }
                  textController.clear();
                  setState(() {
                    isLoading = false;
                  });
                })
          ],
          centerTitle: true,
        ),
        body: (isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: varieta.map(
                    (e) {
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CercaDocVarieta(
                                        varieta: e['xcd_xvarieta'].toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      e['xcd_xvarieta'].toString(),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                ),
              )
        // ListView.builder(
        //     itemBuilder: (context, index) {
        //       return ListTile(
        //         onTap: (() => Navigator.of(context).pop(
        //               varieta[index]["cd_xvarieta"].toString(),
        //             )),
        //         leading: Text(
        //           varieta[index]["cd_xvarieta"],
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         title: Text(
        //           varieta[index]["descrizione"],
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       );
        //     },
        //     itemCount: varieta.length,
        //   ),
        );
  }
}
