import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_database/page/home_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  // Init ffi loader if needed.
  if (Platform.isWindows) {
    sqfliteFfiInit();
    // databaseFactory = databaseFactoryFfi;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(context),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

void unFocus(BuildContext context) {
  final FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}
