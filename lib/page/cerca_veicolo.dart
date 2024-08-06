import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/altri_doc.dart';

class CercaVeicolo extends StatefulWidget {
  const CercaVeicolo({super.key});

  @override
  State<CercaVeicolo> createState() => _CercaVeicoloState();
}

List veicolo = [];

class _CercaVeicoloState extends State<CercaVeicolo> {
  @override
  void initState() {
    super.initState();

    refreshVeicolo();
  }

  Future refreshVeicolo() async {
    setState(() {
      isLoading = true;
    });
    final db = await ProvDatabase.instance.database;

    veicolo = await db.rawQuery('SELECT * FROM xVeicolo');
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
          'Cerca Veicolo',
        ),
        actions: [
          AnimSearchBar2(
              helpText: 'Cerca Veicolo...',
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
                  veicolo = await db.rawQuery('SELECT * FROM xveicolo');
                } else {
                  veicolo = await db.rawQuery(
                      'SELECT * FROM xveicolo where descrizione like \'%$ricerca%\' or cd_xveicolo like \'%$ricerca%\'');
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
                        veicolo[index]["cd_xveicolo"].toString(),
                      )),
                  leading: Text(
                    veicolo[index]["cd_xveicolo"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    veicolo[index]["descrizione"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              itemCount: veicolo.length,
            ),
    );
  }
}
