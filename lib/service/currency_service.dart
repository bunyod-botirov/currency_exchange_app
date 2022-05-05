import 'package:currency_exchange_app/service/currency_hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/currency_model.dart';

class ServiceCurrency {
  static Future<void> getCurrencyRate() async {
    try {
      Uri url = Uri.parse("https://nbu.uz/uz/exchange-rates/json/");
      dynamic response = await http.get(url);
      await CurrencyHive.putToHive((jsonDecode(response.body) as List)
          .map((e) => CurrencyRateModel.fromJson(e))
          .toList());
    } catch (e) {
      // No Internet
    }
  }
}
