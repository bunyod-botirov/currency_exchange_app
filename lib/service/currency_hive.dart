import 'package:currency_exchange_app/model/currency_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrencyHive {
  static late Box currencyBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CurrencyRateModelAdapter());
    currencyBox = await Hive.openBox('currencyBox');
  }

  static Future<void> putToHive(List data) async {
    currencyBox.clear();
    for (CurrencyRateModel item in data) {
      currencyBox.add(item);
    }
  }
}
