import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provvisiero_readonly/page/aggiorna.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:provvisiero_readonly/page/ar.dart';
import 'package:provvisiero_readonly/page/drawer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_animations/loading_animations.dart';
import 'dettagliocd_cf.dart';

class ClientiPage extends StatefulWidget {
  const ClientiPage({super.key});

  @override
  _ClientiPageState createState() => _ClientiPageState();
}

class _ClientiPageState extends State<ClientiPage> {
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
    /* String ciao = jsonEncode(<String, String>{
      'cd_ar': cart.cd_ar.toString(),
      'id_ditta': '7',
      'cd_cf': cart.cd_cf.toString(),
      'cd_cfsede': cart.cd_cfsede.toString(),
      'cd_cfdest': cart.cd_cfdest.toString(),
      'cd_agente_1': cart.cd_agente_1.toString(),
      'qta': '${cart.qta}',
      // 'xcolli': cart.xcolli.toString(),
      // 'xbancali': cart.xbancali.toString(),
      // 'prezzo_unitario': cart.prezzo_unitario.toString(),
      'cd_aliquota': cart.cd_aliquota.toString(),
      //'aliquota': cart.aliquota.toString(),
      //'totale': cart.totale.toString(),
      //'imposta': cart.imposta.toString(),
      //'da_inviare': cart.da_inviare.toString(),
      'note': cart.note.toString(),
      //'scontoriga': cart.sconto_riga.toString(),
    });
    print(ciao);*/

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

  Future refreshProv() async {
    setState(() => isLoading = true);
    cf = await ProvDatabase.instance.readAllCF_NOPAG();
    valore = await ProvDatabase.instance.valAllCF_NOPAG();
    cf2 = await ProvDatabase.instance.readAllCF_NODOC();
    valore2 = await ProvDatabase.instance.valAllCF_NODOC();
    DateTime ultimaData = await _recuperaUltimoAggiornamento();

    if (DateTime.now().difference(ultimaData).inMinutes > 360) {
      setState(() {
        mostraAlertDialog(
          'Attenzione! Ultimo Aggiornamento fatto piú di 6 ora fa.',
          'Vuoi fare ora l\'aggiornamento ? ',
        );
      });
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Clienti',
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
                width: MediaQuery.of(context).size.width,
                textController: textController,
                onSuffixTap: () async {
                  String ricerca = textController.text;
                  if (ricerca != '') {
                    cf = await ProvDatabase.instance
                        .readAllCFFilter(filtro: ricerca);
                  } else {
                    cf = await ProvDatabase.instance.readAllCF_NOPAG();
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
                          color: Colors.white, //white70
                          child: Column(
                            children: [
                              Container(
                                color: Colors.redAccent,
                                child: ListTile(
                                  title: Text(
                                    'Clienti con Scadenze Aperte - ${formato.format(valore)}',
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
                                            textAlign: TextAlign.left),
                                        title: Text(cf[index].descrizione,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            textAlign: TextAlign.left),
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
                                              ));
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.redAccent,
                                child: ListTile(
                                    title: Text(
                                  'Clienti con Documenti Aperti - ${formato.format(valore2)}',
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
                                            textAlign: TextAlign.left),
                                        title: Text(cf2[index].descrizione,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                            textAlign: TextAlign.left),
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
                                                    cd_cf: cf2[index].cd_cf)),
                                              ));
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
