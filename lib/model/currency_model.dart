class CurrencyRateModel {
  CurrencyRateModel({
    this.title,
    this.code,
    this.cbPrice,
    this.nbuBuyPrice,
    this.nbuCellPrice,
    this.date,
  });

  String? title;
  String? code;
  String? cbPrice;
  String? nbuBuyPrice;
  String? nbuCellPrice;
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
