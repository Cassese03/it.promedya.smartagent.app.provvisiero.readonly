import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/altri_doc.dart';

class CercaVettore extends StatefulWidget {
  const CercaVettore({super.key});

  @override
  State<CercaVettore> createState() => _CercaVettoreState();
}

List vettore = [];

class _CercaVettoreState extends State<CercaVettore> {
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

    vettore = await db.rawQuery('SELECT * FROM dovettore');
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
          'Cerca Vettore',
        ),
        actions: [
          AnimSearchBar2(
              helpText: 'Cerca Vettore...',
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
                  vettore = await db.rawQuery('SELECT * FROM dovettore');
                } else {
                  vettore = await db.rawQuery(
                      'SELECT * FROM dovettore where descrizione like \'%$ricerca%\' or cd_dovettore like \'%$ricerca%\'');
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
                        vettore[index]["descrizione"].toString(),
                      )),
                  leading: Text(
                    vettore[index]["cd_dovettore"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    vettore[index]["descrizione"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              itemCount: vettore.length,
            ),
    );
  }
}
