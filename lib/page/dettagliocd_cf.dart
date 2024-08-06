// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_local_variable, unnecessary_null_comparison, unused_field, duplicate_ignore

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../alert/alert_field2.dart';
import '../alert/anim_search_widget3.dart';
import '../db/databases.dart';
import 'dettaglio_docu.dart';
import 'package:flutter/services.dart';

String prezzo = '1.00';
String prezzototale = '0.00';
double totale = 0.00;
bool isLoading = false;
String cd_cf = '';

class DettaglioClientePage extends StatefulWidget {
  static const String id = '/ClientePage';
  // ignore: use_key_in_widget_constructors
  const DettaglioClientePage({required this.cd_cf
      //required this.Cliente,
      });
  final String cd_cf;

  @override
  State<DettaglioClientePage> createState() => _DettaglioClientePageState();
}

class _DettaglioClientePageState extends State<DettaglioClientePage>
    with SingleTickerProviderStateMixin {
  final int _quantity = 1;
  late List cliente = [];
  List doc = [];
  List sc = [];
  double tot_sc = 0.00;
  bool isLoading = true;
  late Timer timer;
  late TabController _tabController;
  String filter = 'all';

  @override
  void initState() {
    super.initState();

    refreshCF();
    //_prezzototale();
    if (mounted) {
      timer = Timer.periodic(
          const Duration(seconds: 1), (Timer t) => _prezzototale());
    }
    _tabController = TabController(vsync: this, length: 2);
  }

  Future _prezzototale() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    prezzototale = (_quantity.toDouble() * double.parse(prezzo)).toString();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future refreshCF() async {
    setState(() {
      isLoading = true;
    });

    //prezzototale = (_quantity.toDouble() * double.parse(prezzo)).toString();

    final db = await ProvDatabase.instance.database;
    var id = widget.cd_cf;

    doc = await db.rawQuery(
        'SELECT d.*,p.xsettimana,p.xnumerodocrif, (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione, (SELECT noteagg from dorig where id_dotes = d.id_dotes order by noteagg asc limit 1) as noteagg, (select SUM(qta) from dorig where id_dotes = d.id_dotes) as qta, (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes) as qtaevadibile from dotes d left join dotes_prov p on d.id_dotes = p.id_dotes left join dototali dt on dt.id_dotes = p.id_dotes where d.id_ditta = \'7\' and d.cd_cf  = \'$id\' order by cd_do,CAST(numerodoc AS int) desc');
    sc = await db.rawQuery(
        'SELECT *, (SELECT descrizione from cf where cd_cf = s.cd_cf ) as descrizione from sc s where s.cd_cf  = \'$id\' order by pagata asc ');
    List SC_DAPAGARE = await db.rawQuery(
        'SELECT Cd_CF, importoe AS TOT from sc where cd_cf  = \'$id\' and pagata = \'0\'');
    List SC_PAGATE = await db.rawQuery(
        'SELECT Cd_CF, importoe AS TOT from sc where cd_cf  = \'$id\' and pagata = \'1\' GROUP BY cd_cf ');

    for (var sc in SC_DAPAGARE) {
      tot_sc = tot_sc + double.parse(sc["TOT"]);
    }
    List<Map<String, Object?>> totaleOrdine;
    if (widget.cd_cf.substring(0, 1) == 'C') {
      totaleOrdine = await db.rawQuery(
          'SELECT COALESCE(SUM(dt.totdocumentov),0) as ordine from dotes d left join dototali dt on dt.id_dotes = d.id_dotes where d.id_ditta = \'7\' and d.cd_cf  = \'$id\' and UPPER(d.cd_do) in (\'OVC\',\'DDT\',\'DDS\') and (select SUM(qta) from dorig where id_dotes = d.id_dotes) = (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes)');
    } else {
      totaleOrdine = await db.rawQuery(
          'SELECT COALESCE(SUM(dt.totdocumentov),0) as ordine from dotes d left join dototali dt on dt.id_dotes = d.id_dotes where d.id_ditta = \'7\' and d.cd_cf  = \'$id\' and (upper(d.cd_do) in (\'OAF\',\'DCF\',\'SCO\') or upper(d.cd_do) like \'OF%\' or upper(d.cd_do) like \'CM%\') and (select SUM(qta) from dorig where id_dotes = d.id_dotes) = (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes)');
    }

    totale = (double.parse(totaleOrdine[0]["ordine"].toString()));

    cliente = await db.rawQuery(
        'SELECT * from cf where id_ditta = \'7\' and cd_cf  = \'$id\'');
    cd_cf = cliente[0]["cd_cf"];

    setState(() {
      isLoading = false;
    });
  }

  Future filterDO(String filter) async {
    final db = await ProvDatabase.instance.database;
    var id = widget.cd_cf;
    filter = filter.substring(0, 1);
    filter = filter.toUpperCase();
    if (filter != 'A') {
      doc = await db.rawQuery(
          'SELECT d.*,p.xsettimana,p.xnumerodocrif, (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione, (SELECT noteagg from dorig where id_dotes = d.id_dotes order by noteagg asc limit 1) as noteagg from dotes d left join dotes_prov p on d.id_dotes = p.id_dotes  where d.tipodocumento = \'$filter\' and d.id_ditta = \'7\' and d.cd_cf  = \'$id\' order by cd_do,CAST(numerodoc AS int) desc');
    } else {
      doc = await db.rawQuery(
          'SELECT d.*,p.xsettimana,p.xnumerodocrif, (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione, (SELECT noteagg from dorig where id_dotes = d.id_dotes order by noteagg asc limit 1) as noteagg from dotes d left join dotes_prov p on d.id_dotes = p.id_dotes where d.id_ditta = \'7\' and d.cd_cf  = \'$id\' order by cd_do,CAST(numerodoc AS int) desc');
    }
  }

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const List<String> list = <String>['all', 'ordini', 'bolla', 'fattura'];

    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
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
              actions: [
                AnimSearchBar3(
                  initialinput: filter,
                  dropdown: DropdownButton<String>(
                    value: filter,
                    onChanged: (value) {
                      setState(() {
                        filter = value!.toString();
                        filterDO(filter);
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                        onTap: () => setState(() {
                          filter = value.toString();
                          filterDO(filter);
                        }),
                      );
                    }).toList(),
                  ),
                  helpText: 'Inserire numerodoc...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  suffixIcon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  color: Colors.lightBlue,
                  //-(((MediaQuery.of(context).size.width) / 100) * 10)
                  width: MediaQuery.of(context).size.width,
                  textController: textController,
                  onSuffixTap: () async {
                    String ricerca = textController.text;
                    final db = await ProvDatabase.instance.database;

                    if (ricerca == '') {
                      doc = await db.rawQuery(
                          'SELECT d.*,p.xsettimana,p.xnumerodocrif, (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione, (SELECT noteagg from dorig where id_dotes = d.id_dotes order by noteagg asc limit 1) as noteagg from dotes d left join dotes_prov p on d.id_dotes = p.id_dotes where d.id_ditta = \'7\' and d.cd_cf  = \'${widget.cd_cf}\' order by id desc');
                    } else {
                      doc = await db.rawQuery(
                          'SELECT d.*,p.xsettimana,p.xnumerodocrif, (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione , (SELECT noteagg from dorig where id_dotes = d.id_dotes order by noteagg asc limit 1) as noteagg from dotes d left join dotes_prov p on d.id_dotes = p.id_dotes where d.id_ditta = \'7\' and d.cd_cf  = \'${widget.cd_cf}\' and REPLACE(numerodoc,\' \',\'\') = \'$ricerca\' order by id desc');
                    }
                    textController.clear();

                    setState(() {
                      filter = 'all';
                      isLoading = false;
                    });
                  },
                )
              ],
              centerTitle: true,
              title: Text(
                cd_cf,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.lightBlue,
            ),
            body: isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      Expanded(
                        flex: 90,
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MainClientePageClienteCard(
                                cd_cf: cliente[0]['cd_cf'],
                              ),
                              /*  
                              MainClientePageClienteCard(
                                cd_cf: cliente[0]['cd_cf'],
                              ).px(36), 
                              */
                              Expanded(
                                child: Column(
                                  children: [
                                    TabBar(
                                      controller: _tabController,
                                      tabs: const [
                                        Tab(
                                            icon: Icon(
                                          Icons.lock_clock,
                                          color: Colors.lightBlue,
                                        )),
                                        Tab(
                                            icon: Icon(
                                                Icons.document_scanner_outlined,
                                                color: Colors.lightBlue)),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          sc.isEmpty
                                              ? const Tab(
                                                  text:
                                                      'NESSUNA SCADENZA INSERITA.')
                                              : Tab(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: FractionallySizedBox(
                                                      heightFactor: 0.95,
                                                      child: ListView(
                                                        children: [
                                                          for (var element
                                                              in sc)
                                                            ListTile(
                                                              onTap: () async {
                                                                String
                                                                    id_dotes =
                                                                    '';
                                                                // ignore: unnecessary_null_comparison
                                                                if (element["id_dotes"]
                                                                        .toString() !=
                                                                    null) {
                                                                  id_dotes = element[
                                                                          "id_dotes"]
                                                                      .toString();
                                                                  final db = await ProvDatabase
                                                                      .instance
                                                                      .database;

                                                                  var check = await db
                                                                      .rawQuery(
                                                                          'SELECT id_dotes from dotes where id_dotes = \'${element["id_dotes"].toString()}\'');

                                                                  if (check
                                                                      .isNotEmpty) {
                                                                    id_dotes = element[
                                                                            "id_dotes"]
                                                                        .toString();
                                                                  } else {
                                                                    id_dotes =
                                                                        '';
                                                                  }
                                                                } else {
                                                                  id_dotes = '';
                                                                }
                                                                if (id_dotes
                                                                    .isNotEmpty) {
                                                                  print(
                                                                      id_dotes);
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                          MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        DocuPage(
                                                                            id_dotes:
                                                                                id_dotes),
                                                                  ));
                                                                } else {
                                                                  await showDialog(
                                                                      builder:
                                                                          (context) =>
                                                                              const AlertField2(
                                                                                title: 'Errore documento',
                                                                                content: 'Impossibile aprire il documento associato,in quanto non è stato importato.',
                                                                                textButton: 'Ok',
                                                                              ),
                                                                      context:
                                                                          context);
                                                                }
                                                              },
                                                              leading: const Icon(
                                                                  Icons
                                                                      .lock_clock),
                                                              title: RichText(
                                                                text: TextSpan(
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: (element["pagata"] ==
                                                                            '0')
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                        text: (element["pagata"] ==
                                                                                '0')
                                                                            ? 'Da Pagare: '
                                                                            : 'Pagato: ',
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                    TextSpan(
                                                                        text: element[
                                                                            "importoe"]),
                                                                  ],
                                                                ),
                                                              ),
                                                              trailing:
                                                                  IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .info_outline),
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                            ),
                                                          ListTile(
                                                            onTap: () {},
                                                            leading: const Icon(
                                                                Icons
                                                                    .feed_outlined),
                                                            title: RichText(
                                                              text: TextSpan(
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                children: <TextSpan>[
                                                                  const TextSpan(
                                                                      text:
                                                                          'Totale: ',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  TextSpan(
                                                                      text:
                                                                          '$tot_sc'),
                                                                ],
                                                              ),
                                                            ),
                                                            trailing:
                                                                IconButton(
                                                              icon: const Icon(Icons
                                                                  .info_outline),
                                                              onPressed: () {},
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          doc.isEmpty
                                              ? const Tab(
                                                  text:
                                                      'NESSUN DOCUMENTO INSERITO.')
                                              : Tab(
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    child: ListView(
                                                      children: [
                                                        for (var element in doc)
                                                          ListTile(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                      MaterialPageRoute(
                                                                builder: (context) => DocuPage(
                                                                    id_dotes: element[
                                                                            "id_dotes"]
                                                                        .toString()),
                                                              ));
                                                            },
                                                            leading: const Icon(
                                                                Icons
                                                                    .feed_outlined),
                                                            title: RichText(
                                                              text: TextSpan(
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: (element["qtaevadibile"] !=
                                                                              element[
                                                                                  "qta"] ||
                                                                          element["qta"] ==
                                                                              0)
                                                                      ? Colors
                                                                          .black
                                                                      : (element["cd_do"] == 'NAE' ||
                                                                              element["cd_do"] == 'SOC' ||
                                                                              element["cd_do"] == 'AUF' ||
                                                                              element["cd_do"] == 'NCF' ||
                                                                              element["cd_do"] == 'NDC' ||
                                                                              element["cd_do"].substring(0, 1) == 'F')
                                                                          ? Colors.black
                                                                          : (element["noteagg"] != 'null')
                                                                              ? Colors.blue
                                                                              : Colors.red,
                                                                ),
                                                                children: <TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        '${element["cd_do"]} ',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  const TextSpan(
                                                                      text:
                                                                          ' N° '),
                                                                  TextSpan(
                                                                    text:
                                                                        ' ${element["numerodoc"].toString().replaceAll(' ', '')}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        ' ${(element["xsettimana"] != 'null') ? '(${element["xsettimana"].toString().replaceAll(' ', '')})' : ''}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        ' ${(element["xnumerodocrif"] != 'null') ? '- ${element["xnumerodocrif"].toString().replaceAll(' ', '')} ' : ''}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        '- ${element["descrizione"]}',
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            trailing:
                                                                IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .info_outline,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                        MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DocuPage(
                                                                          id_dotes:
                                                                              element["id_dotes"]),
                                                                ));
                                                              },
                                                            ),
                                                          ),
                                                        ListTile(
                                                          leading: const Icon(
                                                            Icons.feed_outlined,
                                                          ),
                                                          title: RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Totale Economico : ${totale.toStringAsFixed(2)} €',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 20,
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
                                    'EVASO',
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
                                    'SENZA NOTE AGG.',
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
                                        color: Colors.blue,
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
                                    'NOTE AGG. PRESENTI',
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
          );
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

class MainClientePageClienteCard extends StatefulWidget {
  const MainClientePageClienteCard({
    super.key,
    required this.cd_cf,
  });

  final String? cd_cf;

  @override
  State<MainClientePageClienteCard> createState() =>
      _MainClientePageClienteCardState();
}

class _MainClientePageClienteCardState
    extends State<MainClientePageClienteCard> {
  int _selectedColor = 0;
  final int _selectedImageIndex = 0;
  late List cliente;
  bool isLoading = false;

  void _updateColor(int index) {
    setState(() {
      _selectedColor = index;
    });
  }

  @override
  void initState() {
    super.initState();

    refreshCF();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshCF() async {
    setState(() {
      isLoading = true;
    });

    final db = await ProvDatabase.instance.database;
    var id = widget.cd_cf;
    cliente = await db.rawQuery('SELECT * from cf where cd_cf  = \'$id\'');

    //print(cliente);

    setState(() {
      isLoading = false;
    });
  }

  final Cliente = _DettaglioClientePageState();
  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const CircularProgressIndicator()
        : Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const SizedBox(
                height: 100,
                width: double.infinity,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FittedBox(
                            child: Text(
                              '${cliente[0]["descrizione"]}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          //],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FittedBox(
                            child: InkWell(
                              child: Text(
                                '${cliente[0]["indirizzo"]}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                                maxLines: 2,
                                softWrap: false,
                              ),
                              onTap: () async {
                                Uri url = Uri.parse(
                                    'https://www.google.it/maps/search/${cliente[0]!["indirizzo"].toString().replaceAll(' ', '+')}+${cliente[0]!["localita"].toString().replaceAll(' ', '+')}+${cliente[0]!["cd_provincia"].toString().replaceAll(' ', '+')}');
                                await _launch(url);
                              },
                            ),
                          ),
                          //],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Localita :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                            maxLines: 2,
                            softWrap: false,
                          )),
                          Text(
                            '${cliente[0]["localita"]} (${cliente[0]["cd_provincia"]})  - ${cliente[0]["cd_nazione"]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                            maxLines: 2,
                            softWrap: false,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Cap :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                            maxLines: 2,
                            softWrap: false,
                          )),
                          Text(
                            '${cliente[0]["cap"]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                            maxLines: 2,
                            softWrap: false,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 20,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FittedBox(
                            child: InkWell(
                              child: (cliente[0]["mail"] == 'null')
                                  ? Text(
                                      '${cliente[0]["localita"]} (${cliente[0]["cd_provincia"]})  - ${cliente[0]["cd_nazione"]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                      maxLines: 2,
                                      softWrap: false,
                                    )
                                  : Text(
                                      '${cliente[0]["mail"]}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                      maxLines: 2,
                                      softWrap: false,
                                    ),
                              onTap: () async {
                                if (cliente[0]["mail"] != 'null') {
                                  await Clipboard.setData(
                                      ClipboardData(text: cliente[0]["mail"]));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                        'Testo Copiato negli Appunti!'),
                                    action: SnackBarAction(
                                      label: 'Chiudi',
                                      onPressed: () {},
                                    ),
                                  ));
                                }
                              },
                            ),
                          ),
                          //],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Cellulare :',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                            maxLines: 2,
                            softWrap: false,
                          )),
                          InkWell(
                            child: (cliente[0]["telefono"] == 'null')
                                ? Text(
                                    '${cliente[0]["telefono"]}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    softWrap: false,
                                  )
                                : Text(
                                    '${cliente[0]["telefono"]}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                    maxLines: 2,
                                    softWrap: false,
                                  ),
                            onTap: () async {
                              if (cliente[0]["telefono"] != 'null') {
                                await Clipboard.setData(
                                  ClipboardData(text: cliente[0]["telefono"]),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      'Testo Copiato negli Appunti!'),
                                  action: SnackBarAction(
                                    label: 'Chiudi',
                                    onPressed: () {},
                                  ),
                                ));
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
  }
}

Future<void> _launch(Uri url) async {
  var context;
  await canLaunchUrl(url)
      ? await launchUrl(url, mode: LaunchMode.externalApplication)
      : await showDialog(
          builder: (context) => const AlertField2(
            textButton: 'Ok',
            content: 'Errore. Impossibile Aprire il file.',
            title: 'Errore Momentaneo',
          ),
          context: context,
        );
  throw 'Could not launch $url';
}
