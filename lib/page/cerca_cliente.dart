import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/altri_doc.dart';

class CercaCliente extends StatefulWidget {
  const CercaCliente({super.key});

  @override
  State<CercaCliente> createState() => _CercaClienteState();
}

List clienti = [];

class _CercaClienteState extends State<CercaCliente> {
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

    clienti = await db.rawQuery('SELECT * FROM cf WHERE cd_cf like \'C%\'');

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
          'Cerca Cliente',
        ),
        actions: [
          AnimSearchBar2(
            helpText: 'Cerca Cliente...',
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
                clienti = await db
                    .rawQuery('SELECT * FROM cf where cd_cf like  \'C%\'');
              } else {
                clienti = await db.rawQuery(
                    'SELECT DISTINCT * FROM cf where cd_cf like  \'C%\' and descrizione like \'%$ricerca%\' or cd_cf like \'%$ricerca%\'');
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
                String value =
                    '${clienti[index]["descrizione"].toString()} - ${clienti[index]["indirizzo"].toString()} - ${clienti[index]["localita"].toString()}(${clienti[index]["cd_provincia"].toString()}) - ${clienti[index]["cap"].toString()} - ${clienti[index]["telefono"].toString()}'
                        .replaceAll('\'', '')
                        .replaceAll('/', '  ')
                        .replaceAll('\\', '  ')
                        .replaceAll('&', 'e');
                return ListTile(
                  onTap: (() => Navigator.of(context).pop(
                        (value.length > 300) ? value.substring(0, 300) : value,
                      )),
                  leading: Text(
                    clienti[index]["descrizione"],
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
