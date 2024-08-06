import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/alert/anim_search_widget2.dart';
import 'package:provvisiero_readonly/page/dettaglio_docu.dart';
import '../db/databases.dart';

bool isLoading = false;

class RifOrdPage extends StatefulWidget {
  static const String id = '/RifOrdPage';

  const RifOrdPage({super.key});

  @override
  State<RifOrdPage> createState() => _RifOrdPageState();
}

class _RifOrdPageState extends State<RifOrdPage>
    with SingleTickerProviderStateMixin {
  late List riford = [];
  List tot_vett = [];
  TextEditingController textController = TextEditingController();
  bool isLoading = true;
  late TabController _tabController;
  String Data = '';
  @override
  void initState() {
    super.initState();

    refreshDocumenti();

    _tabController = TabController(vsync: this, length: 1);
  }

  Future refreshDocumenti() async {
    setState(() {
      isLoading = true;
    });

    final db = await ProvDatabase.instance.database;

    riford = await db.rawQuery(
        'SELECT *, (SELECT xriford from dotes_prov where id_dotes = dotes.id_dotes LIMIT 1) as xriford FROM dotes where id_dotes in (SELECT id_dotes from dotes_prov where xriford != \'null\' and xriford != \'\' )');
    setState(() {
      isLoading = false;
    });
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
                Navigator.pop(context);
              }
            },
          ),
          centerTitle: true,
          title: const Text(
            'Ns Ord Rif',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.lightBlue,
          actions: [
            AnimSearchBar2(
                helpText: 'Inserire ns ord rif...',
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
                  final db = await ProvDatabase.instance.database;

                  if (ricerca == '') {
                    riford = await db.rawQuery(
                        'SELECT *, (SELECT xriford from dotes_prov where id_dotes = dotes.id_dotes LIMIT 1) as xriford FROM dotes where id_dotes in (SELECT id_dotes from dotes_prov where xriford != \'null\' and xriford != \'\' )');
                  } else {
                    riford = await db.rawQuery(
                        'SELECT *, (SELECT xriford from dotes_prov where id_dotes = dotes.id_dotes LIMIT 1) as xriford FROM dotes where id_dotes in (SELECT id_dotes from dotes_prov where xriford LIKE \'%$ricerca%\' )');
                  }
                  textController.clear();

                  setState(
                    () => isLoading = false,
                  );
                })
          ],
        ),
        body: isLoading
            ? const CircularProgressIndicator()
            : DefaultTabController(
                length: 1,
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
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.lightBlue,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: (riford.isEmpty)
                                          ? 'Documenti RifOrd'
                                          : 'Documenti RifOrd (${riford.length})',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              riford.isEmpty
                                  ? const Tab(
                                      text: 'NESSUN DOCUMENTO CON RIFORD.',
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 8.0),
                                      shrinkWrap: true,
                                      itemCount: riford.length,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Card(
                                                child: ListTile(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DocuPage(
                                                          id_dotes: riford[
                                                                      index]
                                                                  ["id_dotes"]
                                                              .toString(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  leading: const Icon(
                                                      Icons.feed_outlined),
                                                  title: RichText(
                                                    text: TextSpan(
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                '${riford[index]["cd_do"]} ',
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        TextSpan(
                                                            text:
                                                                ' N° ${riford[index]["numerodoc"]} -  ${riford[index]["xriford"]}'),
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
                                                                id_dotes: riford[
                                                                        index][
                                                                    "id_dotes"]),
                                                      ));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
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
