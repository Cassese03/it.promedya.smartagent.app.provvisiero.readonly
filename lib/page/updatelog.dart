import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

bool isLoading = false;

class UpdateLogPage extends StatefulWidget {
  static const String id = '/LogPage';

  const UpdateLogPage({super.key});
  @override
  State<UpdateLogPage> createState() => _UpdateLogPageState();
}

class _UpdateLogPageState extends State<UpdateLogPage> {
  TextEditingController textController = TextEditingController();
  bool isLoading = true;

  var notesJson = [];

  @override
  void initState() {
    super.initState();

    refreshLog();
  }

  Future refreshLog() async {
    setState(() {
      isLoading = true;
    });
    var url =
        'https://bohagent.cloud/api/b2b/get_provvisiero/xlogUpdate/PROV1234';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      notesJson = json.decode(response.body);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onTap: () async {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              centerTitle: true,
              title: const Text(
                'Update Log Giornaliero',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.lightBlue,
            ),
            body: isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ...notesJson.map(
                          (e) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      '${e['type']} Modificato/a',
                                    ),
                                    subtitle: Text(
                                      '${json.decode(e['json'])[0]}',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
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

class FavouriteButton extends StatelessWidget {
  const FavouriteButton(
      {super.key,
      required this.iconSize,
      required this.onPressed,
      required this.isClicked});

  final String isClicked;
  final double iconSize;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          padding: WidgetStateProperty.all(const EdgeInsets.all(0)),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80))),
          backgroundColor: WidgetStateProperty.all(
              (isClicked == 'true') ? Colors.green : Colors.grey),
          elevation: WidgetStateProperty.all(4),
          shadowColor: WidgetStateProperty.all(Colors.green)),
      onPressed: onPressed,
      child: Center(
        child: Icon(
          Icons.circle,
          size: iconSize,
          color: (isClicked == 'true') ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
