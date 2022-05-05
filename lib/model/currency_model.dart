import 'package:hive_flutter/hive_flutter.dart';

part 'currency_model.g.dart';

@HiveType(typeId: 1)
class CurrencyRateModel {
  CurrencyRateModel({
    this.title,
    this.code,
    this.cbPrice,
    this.nbuBuyPrice,
    this.nbuCellPrice,
    this.date,
  });

  @HiveField(0)
  String? title;
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? cbPrice;
  @HiveField(3)
  String? nbuBuyPrice;
  @HiveField(4)
  String? nbuCellPrice;
  @HiveField(5)
  String? date;

  factory CurrencyRateModel.fromJson(Map<String, dynamic> name) =>
      CurrencyRateModel(
        title: name["title"],
        code: name["code"],
        cbPrice: name["cb_price"],
        nbuBuyPrice: name["nbu_buy_price"],
        nbuCellPrice: name["nbu_cell_price"],
        date: name["date"],
      );
}
