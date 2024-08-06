import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provvisiero_readonly/alert/temp_data_picker.dart';
import 'package:provvisiero_readonly/page/dettaglio_docu.dart';
import 'package:week_of_year/week_of_year.dart';
import 'package:provvisiero_readonly/page/cliente.dart';
import '../db/databases.dart';

bool isLoading = false;

class DocumentiPage extends StatefulWidget {
  static const String id = '/DocumentiPage';

  const DocumentiPage({super.key, required this.date});

  final String date;

  @override
  State<DocumentiPage> createState() => _DocumentiPageState();
}

class _DocumentiPageState extends State<DocumentiPage>
    with SingleTickerProviderStateMixin {
  late List ovc = [];
  late List oaf = [];
  late List datacons = [];
  late List datadoc = [];
  String settimana = '';
  /*
    late List ddt = [];
    late List ftv = [];
  */
  bool isLoading = true;
  late TabController _tabController;
  String Data = '';
  @override
  void initState() {
    super.initState();

    Data = widget.date.toString();

    refreshDocumenti();

    _tabController = TabController(vsync: this, length: 2);
  }

  Future refreshDocumenti() async {
    setState(() {
      isLoading = true;
    });

    final db = await ProvDatabase.instance.database;

    var trans = DateFormat("dd-MM-yyyy").parse(Data).toString();

    String id = trans.substring(0, 19);

    final date = DateFormat("yyyy-MM-dd").parse(id);

    settimana = date.weekOfYear.toString();

    ovc = await db.rawQuery('''
        SELECT *, (SELECT descrizione from cf where cd_cf = d.cd_cf ) as descrizione,
        (SELECT noteagg from dorig where id_dotes = d.id_dotes order by noteagg asc limit 1) as noteagg,
        (select SUM(qta) from dorig where id_dotes = d.id_dotes) as qta, 
        (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes) as qtaevadibile
        from dotes d
        left join dotes_prov dp on dp.id_dotes = d.id_dotes  
        where d.id_ditta = '7' and (d.dataconsegna  = '$id' or (d.dataconsegna = '' and dp.xsettimana = '$settimana')) and d.cd_do = 'OVC' 
        ''');

    oaf = await db.rawQuery(
        '''SELECT *, (SELECT descrizione from cf where cd_cf = d.cd_cf) as descrizione,
        (SELECT noteagg from dorig where id_dotes = d.id_dotes order by noteagg asc limit 1) as noteagg,
        (select SUM(qta) from dorig where id_dotes = d.id_dotes) as qta, 
        (select SUM(qtaevadibile) from dorig where id_dotes = d.id_dotes) as qtaevadibile
        from dotes d inner join dotes_prov dp on dp.id_dotes = d.id_dotes 
        where d.id_ditta = '7' 
        and  (d.dataconsegna  = '$id' or (d.dataconsegna = '' and dp.xsettimana = '$settimana')) and (d.cd_do like '%OF%' or d.cd_do = 'OAF')
        ''');

    datacons = await db.rawQuery('''SELECT d.dataconsegna
        from dotes d inner join dotes_prov dp on dp.id_dotes = d.id_dotes 
        where d.id_ditta = '7' 
        and (d.cd_do like '%OF%' or d.cd_do = 'OAF' or d.cd_do = 'OVC') and d.dataconsegna is not null and d.dataconsegna != 'null'
        ''');

    datadoc = await db.rawQuery('''SELECT d.datadoc
        from dotes d inner join dotes_prov dp on dp.id_dotes = d.id_dotes 
        where d.id_ditta = '7' 
        and (d.cd_do like '%OF%' or d.cd_do = 'OAF' or d.cd_do = 'OVC') and d.datadoc is not null and d.datadoc != 'null'
        ''');

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    var docs = [...datadoc, ...datacons];
    var docs2 = docs
        .map(
            (e) => {"dataconsegna": e["dataconsegna"], "datadoc": e["datadoc"]})
        .toList();

    int lastDate = int.parse(DateFormat('yyyy').format(DateTime.now())) + 1;
    int firstDate = int.parse(DateFormat('yyyy').format(DateTime.now())) - 2;
    final DateTime? picked = await showDatePickerByLorenzo(
      context: context,
      initialDate: DateFormat("dd-MM-yyyy").parse(Data),
      firstDate: DateTime(firstDate, 1),
      lastDate: DateTime(lastDate),
      days: docs2,
      helpText: 'Settimana - ${DateTime.now().weekOfYear.toString()}',
    );

    if (picked != null) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentiPage(
              date: DateFormat('dd-MM-yyyy').format(picked).toString(),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientiPage(),
                    ));
              }
            },
          ),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                color: Colors.white,
                onPressed: () {
                  DateTime picked = DateFormat("dd-MM-yyyy").parse(widget.date);
                  picked = picked.add(const Duration(days: -1));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentiPage(
                        date:
                            DateFormat('dd-MM-yyyy').format(picked).toString(),
                      ),
                    ),
                  );
                },
              ),
              Text(
                '${widget.date} - $settimana',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  DateTime picked = DateFormat("dd-MM-yyyy").parse(widget.date);
                  picked = picked.add(const Duration(days: 1));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocumentiPage(
                        date:
                            DateFormat('dd-MM-yyyy').format(picked).toString(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.lightBlue,
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              color: Colors.white,
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    flex: 90,
                    child: DefaultTabController(
                      length: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.grey.shade200],
                        )),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: TabBar(
                                  controller: _tabController,
                                  tabs: [
                                    Tab(
                                      /*icon: IconButton(
                                            icon: Icon(Icons.calendar_month),
                                            color: Colors.lightBlue,
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                          ),*/
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.lightBlue,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: (ovc.isEmpty)
                                                    ? 'OVC'
                                                    : 'OVC (${ovc.length})',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.lightBlue,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: (ovc.isEmpty)
                                                    ? 'OAF'
                                                    : 'OAF (${oaf.length})',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    /*Tab(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.lightBlue,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: (ddt.isEmpty)
                                                    ? 'DDT'
                                                    : 'DDT (${ddt.length})',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.lightBlue,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: (ftv.isEmpty)
                                                  ? 'FTV'
                                                  : 'FTV (${ftv.length})',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    ovc.isEmpty
                                        ? const Tab(
                                            text:
                                                'NESSUN OVC IN QUESTA GIORNATA .',
                                          )
                                        : Tab(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: ListView(
                                                children: [
                                                  for (var element in ovc)
                                                    ListTile(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) => DocuPage(
                                                              id_dotes: element[
                                                                      "id_dotes"]
                                                                  .toString()),
                                                        ));
                                                      },
                                                      leading: const Icon(
                                                          Icons.feed_outlined),
                                                      title: RichText(
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: (element["qtaevadibile"] !=
                                                                          element[
                                                                              "qta"] ||
                                                                      element["qta"] ==
                                                                          0)
                                                                  ? Colors.black
                                                                  : (element["cd_do"] ==
                                                                          'NAE')
                                                                      ? Colors
                                                                          .black
                                                                      : (element["noteagg"] !=
                                                                              'null')
                                                                          ? Colors
                                                                              .blue
                                                                          : (element["dataconsegna"] != '' || element["dataconsegna"] != null)
                                                                              ? Colors.green
                                                                              : Colors.red),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    '${element["cd_do"]} ',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            TextSpan(
                                                                text:
                                                                    ' N° ${element["numerodoc"]} - ${element["descrizione"]}'),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                        icon: const Icon(
                                                            Icons.info_outline),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                DocuPage(
                                                                    id_dotes:
                                                                        element[
                                                                            "id_dotes"]),
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    oaf.isEmpty
                                        ? const Tab(
                                            text:
                                                'NESSUN OAF IN QUESTA GIORNATA .',
                                          )
                                        : Tab(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: ListView(
                                                children: [
                                                  for (var element in oaf)
                                                    ListTile(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) => DocuPage(
                                                              id_dotes: element[
                                                                      "id_dotes"]
                                                                  .toString()),
                                                        ));
                                                      },
                                                      leading: const Icon(
                                                          Icons.feed_outlined),
                                                      title: RichText(
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: (element["qtaevadibile"] !=
                                                                        element[
                                                                            "qta"] ||
                                                                    element["qta"] ==
                                                                        0)
                                                                ? Colors.black
                                                                : (element["cd_do"] ==
                                                                        'NAE')
                                                                    ? Colors
                                                                        .black
                                                                    : (element["noteagg"] !=
                                                                            'null')
                                                                        ? Colors
                                                                            .blue
                                                                        : (element["dataconsegna"] != '' ||
                                                                                element["dataconsegna"] != null)
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    '${element["cd_do"]} ',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            TextSpan(
                                                                text:
                                                                    ' N° ${element["numerodoc"]} - ${element["descrizione"]}'),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                        icon: const Icon(
                                                            Icons.info_outline),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                DocuPage(
                                                                    id_dotes:
                                                                        element[
                                                                            "id_dotes"]),
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    /*ddt.isEmpty
                                        ? Tab(
                                            text: 'NESSUN DDT IN QUESTA GIORNATA .',
                                          )
                                        : Tab(
                                            child: Container(
                                              width:
                                                  MediaQuery.of(context).size.width,
                                              height:
                                                  MediaQuery.of(context).size.height,
                                              child: ListView(
                                                children: [
                                                  for (var element in ddt)
                                                    ListTile(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              DocuPage(
                                                                  id_dotes: element[
                                                                          "id_dotes"]
                                                                      .toString()),
                                                        ));
                                                      },
                                                      leading:
                                                          Icon(Icons.feed_outlined),
                                                      title: RichText(
                                                        text: TextSpan(
                                                          style: const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    '${element["cd_do"]} ',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            TextSpan(
                                                                text:
                                                                    ' N° ${element["numerodoc"]} - ${element["descrizione"]}'),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                        icon:
                                                            Icon(Icons.info_outline),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                DocuPage(
                                                                    id_dotes: element[
                                                                        "id_dotes"]),
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    ftv.isEmpty
                                        ? Tab(
                                            text:
                                                'NESSUNA FATTURA IN QUESTA GIORNATA .',
                                          )
                                        : Tab(
                                            child: Container(
                                              width:
                                                  MediaQuery.of(context).size.width,
                                              height:
                                                  MediaQuery.of(context).size.height,
                                              child: ListView(
                                                children: [
                                                  for (var element in ftv)
                                                    ListTile(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              DocuPage(
                                                                  id_dotes: element[
                                                                          "id_dotes"]
                                                                      .toString()),
                                                        ));
                                                      },
                                                      leading:
                                                          Icon(Icons.feed_outlined),
                                                      title: RichText(
                                                        text: TextSpan(
                                                          style: const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    '${element["cd_do"]} ',
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            TextSpan(
                                                                text:
                                                                    ' N° ${element["numerodoc"]} - ${element["descrizione"]}'),
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: IconButton(
                                                        icon:
                                                            Icon(Icons.info_outline),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                DocuPage(
                                                                    id_dotes: element[
                                                                        "id_dotes"]),
                                                          ));
                                                        },
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                 */
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
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
                              flex: 7,
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
                              flex: 18,
                              child: Text(
                                'EVASO',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
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
                              flex: 18,
                              child: Text(
                                'NOTE AGG. PRESENTI',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
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
                              flex: 18,
                              child: Text(
                                'SENZA DATA CONSEGNA SENZA NOTE AGG.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: SizedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              flex: 18,
                              child: Text(
                                'CON DATA CONSEGNA SENZA NOTE AGG.',
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
