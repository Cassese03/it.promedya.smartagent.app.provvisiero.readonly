import 'package:flutter/material.dart';
import 'package:provvisiero_readonly/page/cliente.dart';
import 'package:provvisiero_readonly/db/databases.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';

List<CameraDescription>? cameras;

Future main() async {
  await bugsnag.start(
    apiKey: 'ffaf375a9cc42dba13955e432eac1315',
  );
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  // await SystemChrome.setPreferredOrientations([
  // DeviceOrientation.portraitUp,
  // DeviceOrientation.portraitDown,
  // ]);
  await ProvDatabase.instance.check_database(
    'cart',
    'note_agg',
  );
  await ProvDatabase.instance.check_database(
    'cart',
    'xlegato',
  );
  await ProvDatabase.instance.check_database(
    'dotes',
    'numerodocrif',
  );
  bugsnag.runZoned(
    () => runApp(
      const MyApp(),
    ),
  );

  //runApp(
  //  const MyApp(),
  //);

  //runApp(
  //  DevicePreview(
  //    enabled: !kReleaseMode,
  //    builder: (context) => const MyApp(),
  //  ),
  //);
}

class MyApp extends StatelessWidget {
  static String title = 'Provvisiero';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // ignore: deprecated_member_use
            textScaleFactor: 1.1,
          ),
          child: child!,
        ),
        debugShowCheckedModeBanner: false,
        title: title,
        locale: const Locale(
          'it',
        ),
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const ClientiPage(),
      );
}
