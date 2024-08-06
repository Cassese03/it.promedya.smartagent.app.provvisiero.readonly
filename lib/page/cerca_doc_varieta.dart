// ignore_for_file: unused_field, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/page/cliente.dart';
import 'package:provvisiero_readonly/page/dettaglio_docu.dart';
import '../db/databases.dart';

class CercaDocVarieta extends StatefulWidget {
  static const String id = '/CercaDocVarieta';

  final String varieta;

  const CercaDocVarieta({super.key, required this.varieta});

  @override
  State<CercaDocVarieta> createState() => _CercaDocVarietaState();
}

class _CercaDocVarietaState extends State<CercaDocVarieta> {
  TextEditingController textController = TextEditingController();
  List doc = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    refreshDocumenti();
  }

  Future refreshDocumenti() async {
    setState(() {
      isLoading = true;
    });

    final db = await ProvDatabase.instance.database;

    doc = await db.rawQuery(
      '''
      SELECT DISTINCT d.*,dp.*,(select descrizione from cf where cd_cf = d.cd_cf) as descrizione_cf
      from dotes d 
	    left join dotes_prov dp on dp.id_dotes = d.id_dotes 
      left join dorig do on do.id_dotes = d.id_dotes 
      where do.cd_ar in (SELECT cd_ar from ar where xcd_xvarieta = '${widget.varieta}') 
      and d.id_ditta = '7' 
	    and d.cd_do like 'O%' and d.cd_cf like 'F%' 
      and (SELECT SUM(dorig.qta) from dorig where id_dotes = d.id_dotes ) = (SELECT SUM(dorig.qtaevadibile) from dorig where id_dotes = d.id_dotes )
      order by CAST(d.datadoc as DATE) desc 
      ''',
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
            'Varieta ${widget.varieta}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.lightBlue,
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClientiPage(),
                  ),
                );
              },
            )
          ],
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: doc.isNotEmpty
                      ? doc
                          .map(
                            (e) => Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DocuPage(
                                          id_dotes: e['id_dotes'].toString(),
                                        ),
                                      ),
                                    ),
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.feed_outlined),
                                            const Spacer(
                                              flex: 2,
                                            ),
                                            Expanded(
                                              flex: 90,
                                              child: RichText(
                                                overflow: TextOverflow.clip,
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: ' ${e["cd_do"]} ',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                        text: ' N° '),
                                                    TextSpan(
                                                      text:
                                                          ' ${e["numerodoc"].toString().replaceAll(' ', '')}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          ' ${(e["xsettimana"] != 'null') ? '(${e["xsettimana"].toString().replaceAll(' ', '')})' : ''}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          ' ${(e["xnumerodocrif"] != 'null') ? '- ${e["xnumerodocrif"].toString().replaceAll(' ', '')} ' : ''}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '- ${e["descrizione_cf"]}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(
                                              flex: 3,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList()
                      : [
                          const Center(
                            child: Text('Nessun Documento Trovato'),
                          ),
                        ],
                ),
              ),
      );
    }
  }
}
