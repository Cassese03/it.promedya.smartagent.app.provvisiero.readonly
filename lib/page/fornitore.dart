import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/aggiorna.dart';
import 'package:provvisiero_readonly/page/ar.dart';
import 'package:provvisiero_readonly/page/drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animations/loading_animations.dart';
import 'dettagliocd_cf.dart';

class FornitorePage extends StatefulWidget {
  const FornitorePage({super.key});

  @override
  _FornitorePageState createState() => _FornitorePageState();
}

class _FornitorePageState extends State<FornitorePage> {
  late List cf;
  late List cf2;
  var formato = NumberFormat("#,##0.00", "it_IT");
  double valore = 0, valore2 = 0;
  bool isLoading = false;
  bool isDownloading = false;
  bool isSending = false;
  TextEditingController textController = TextEditingController();

  Future<DateTime> _recuperaUltimoAggiornamento() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('ultimoAggiornamento');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      return DateTime.fromMillisecondsSinceEpoch(1640979000000, isUtc: true);
    }
  }

  void mostraAlertDialog(String titolo, String contenuto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titolo),
          content: Text(contenuto),
          actions: <Widget>[
            TextButton(
              child: const Text('Chiudi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aggiorna'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AggiornaPage(),
                    ));
              },
            ),
          ],
        );
      },
    );
  }

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
        'xconfezione': cart.confenzione.toString(),
        'note_agg': cart.note_agg.toString(),
      }),
    );
    // print(response.body);
    // print(response.statusCode);
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

  Future refreshProv() async {
    setState(() => isLoading = true);
    DateTime ultimaData = await _recuperaUltimoAggiornamento();

    if (DateTime.now().difference(ultimaData).inMinutes > 360) {
      setState(() {
        mostraAlertDialog(
            'Attenzione! Ultimo Aggiornamento fatto piú di 6 ora fa.',
            'Vuoi fare ora l\'aggiornamento ? ');
      });
    }
    cf = await ProvDatabase.instance.readAllCF_NOPAGF();
    valore = await ProvDatabase.instance.valAllCF_NOPAGF();
    cf2 = await ProvDatabase.instance.readAllCF_NODOCF();
    valore2 = await ProvDatabase.instance.valAllCF_NODOCF();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Fornitori',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.lightBlue,
          actions: [
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
                width: 380,
                textController: textController,
                onSuffixTap: () async {
                  String ricerca = textController.text;
                  if (ricerca != '') {
                    cf = await ProvDatabase.instance
                        .readAllCFFilterF(filtro: ricerca);
                    cf2 = [];
                  } else {
                    cf = await ProvDatabase.instance.readAllCF_NOPAGF();
                    cf2 = await ProvDatabase.instance.readAllCF_NODOCF();
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
                      Image.asset('assets/logo.png'),
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
                          Image.asset('assets/logo.png'),
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
                      : Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                color: Colors.redAccent,
                                child: ListTile(
                                  title: Text(
                                    'Fornitore con Scadenze Aperte - ${formato.format(valore)}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 50,
                                child: ListView(
                                  children: [
                                    for (var index = 0;
                                        index < cf.length;
                                        index++)
                                      ListTile(
                                        leading: Text(cf[index].cd_cf,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        title: Text(cf[index].descrizione,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.info_outline,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    (DettaglioClientePage(
                                                        cd_cf:
                                                            cf[index].cd_cf)),
                                              ),
                                            );
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => (ARPage(
                                                  cd_cf: cf[index].cd_cf)),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.redAccent,
                                child: ListTile(
                                    title: Text(
                                  'Fornitore con Documenti Aperti - ${formato.format(valore2)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                              Expanded(
                                flex: 50,
                                child: ListView(
                                  children: [
                                    for (var index = 0;
                                        index < cf2.length;
                                        index++)
                                      ListTile(
                                        leading: Text(cf2[index].cd_cf,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        title: Text(cf2[index].descrizione,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            textAlign: TextAlign.center),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.info_outline,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      (DettaglioClientePage(
                                                          cd_cf: cf2[index]
                                                              .cd_cf)),
                                                ));
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => (ARPage(
                                                cd_cf: cf2[index].cd_cf,
                                              )),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
        ),
      );
}
