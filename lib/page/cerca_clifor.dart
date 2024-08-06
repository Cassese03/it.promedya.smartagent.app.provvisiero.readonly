import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/altri_doc.dart';

class CercaClifor extends StatefulWidget {
  const CercaClifor({super.key});

  @override
  State<CercaClifor> createState() => _CercaCliforState();
}

List clienti = [];

class _CercaCliforState extends State<CercaClifor> {
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

    clienti = await db.rawQuery(
        'select \'\' as cd_cf, \'Rimuovi CF\' as descrizione UNION ALL SELECT cd_cf, descrizione FROM cf');

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
          'Cerca Cliente / Fornitore',
        ),
        actions: [
          AnimSearchBar2(
            helpText: 'Cerca Cliente o Fornitore ...',
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
            closeSearchOnSuffixTap: true,
            onSuffixTap: () async {
              setState(() {
                isLoading = true;
              });
              String ricerca = textController.text;
              final db = await ProvDatabase.instance.database;

              if (ricerca == '') {
                clienti = await db.rawQuery(
                    '(select \'\' as cd_cf, \'Rimuovi CF\' as descrizione) UNION ALL (SELECT cd_cf, descirzione FROM cf)');
              } else {
                clienti = await db.rawQuery(
                    'SELECT DISTINCT * FROM cf where descrizione like \'%$ricerca%\' or cd_cf like \'%$ricerca%\'');
              }
              textController.clear();
              setState(() {
                isLoading = false;
              });
            },
          )
        ],
        centerTitle: true,
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                String value = clienti[index]["cd_cf"].toString();
                return ListTile(
                  onTap: (() => Navigator.of(context).pop(
                        value,
                      )),
                  leading: Text(
                    '${clienti[index]["cd_cf"]} - ${clienti[index]["descrizione"]}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
              itemCount: clienti.length,
            ),
    );
  }
}
