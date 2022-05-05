import 'package:currency_exchange_app/service/currency_hive.dart';
import 'package:flutter/material.dart';
import './screens/home_page.dart';

Future<void> main() async {
  await CurrencyHive.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
