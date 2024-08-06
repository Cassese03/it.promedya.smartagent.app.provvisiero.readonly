import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/altri_doc.dart';

class CercaArticolo extends StatefulWidget {
  const CercaArticolo({super.key});

  @override
  State<CercaArticolo> createState() => _CercaArticoloState();
}

List articolo = [];

class _CercaArticoloState extends State<CercaArticolo> {
  @override
  void initState() {
    super.initState();

    refresharticolo();
  }

  Future refresharticolo() async {
    setState(() {
      isLoading = true;
    });
    final db = await ProvDatabase.instance.database;

    articolo = await db.rawQuery('SELECT * FROM ar');
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
          'Cerca Articolo',
        ),
        actions: [
          AnimSearchBar2(
              helpText: 'Cerca Articolo...',
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
              width: 380,
              textController: textController,
              onSuffixTap: () async {
                setState(() {
                  isLoading = true;
                });
                String ricerca = textController.text;
                final db = await ProvDatabase.instance.database;

                if (ricerca == '') {
                  articolo = await db.rawQuery('SELECT * FROM ar');
                } else {
                  articolo = await db.rawQuery(
                      'SELECT * FROM ar where descrizione like \'%$ricerca%\' or cd_ar like \'%$ricerca%\'');
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
          : ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (() => Navigator.of(context).pop(
                        articolo[index]["cd_ar"].toString(),
                      )),
                  leading: Text(
                    articolo[index]["cd_ar"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  title: Text(
                    articolo[index]["descrizione"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.lightBlue,
                    ),
                  ),
                );
              },
              itemCount: articolo.length,
            ),
    );
  }
}
