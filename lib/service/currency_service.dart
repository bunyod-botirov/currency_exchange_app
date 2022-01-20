import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/currency_model.dart';

class ServiceCurrency {
  static Future<List<CurrencyRateModel>> getCurrencyRate() async {
    Uri url = Uri.parse("https://nbu.uz/uz/exchange-rates/json/");
    dynamic response = await http.get(url);
    return (jsonDecode(response.body) as List)
        .map((e) => CurrencyRateModel.fromJson(e))
        .toList();
  }
}
