import 'package:flutter/material.dart';
import '../model/currency_model.dart';
import '../service/currency_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromController = TextEditingController();
  String _popupValue = "USD";
  String _selectedCurrency = "0";
  double _toLabelText = 0.0;
  bool _isFrom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Currency Exchanger",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: inputGetterPart(context),
          ),
          Expanded(
            flex: 8,
            child: infoListPart(),
          ),
        ],
      ),
    );
  }

  Column inputGetterPart(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Row(
          children: <Widget>[
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: FutureBuilder(
                future: ServiceCurrency.getCurrencyRate(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CurrencyRateModel>> snapshot) {
                  return TextFormField(
                    controller: _fromController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: "From",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                    onTap: () {
                      for (int i = 0; i < snapshot.data!.length; i++) {
                        if (_popupValue == snapshot.data![i].code) {
                          _selectedCurrency =
                              snapshot.data![i].cbPrice.toString();
                          break;
                        }
                      }
                    },
                    onChanged: (value) {
                      workWhenCurrencyChanged(value);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            !_isFrom ? popupMenuButton() : const Text("UZS"),
            const Spacer(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              splashRadius: 20,
              icon: const Icon(
                Icons.change_circle_outlined,
                color: Colors.black54,
                size: 26,
              ),
              onPressed: () {
                _isFrom = !_isFrom;
                if (_fromController.text.isNotEmpty) {
                  workWhenCurrencyChanged(_fromController.text);
                }
                setState(() {});
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: _toLabelText.toStringAsFixed(2),
                  labelText: "To",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            _isFrom ? popupMenuButton() : const Text("UZS"),
            const Spacer(),
          ],
        ),
        const Spacer(),
        Divider(
          thickness: MediaQuery.of(context).size.height * 0.001,
          height: 0,
        ),
      ],
    );
  }

  void workWhenCurrencyChanged(value) {
    if (!_isFrom) {
      value.isNotEmpty
          ? _toLabelText = double.parse(_selectedCurrency) * double.parse(value)
          : _toLabelText = 0;
    } else {
      value.isNotEmpty
          ? _toLabelText = double.parse(value) / double.parse(_selectedCurrency)
          : _toLabelText = 0;
    }
  }

  FutureBuilder<List<CurrencyRateModel>> popupMenuButton() {
    return FutureBuilder(
      future: ServiceCurrency.getCurrencyRate(),
      builder: (BuildContext context,
          AsyncSnapshot<List<CurrencyRateModel>> snapshot) {
        return PopupMenuButton(
          child: Row(
            children: <Widget>[
              Text(_popupValue),
              const Icon(
                Icons.arrow_drop_down,
                size: 20,
              ),
            ],
          ),
          itemBuilder: (context) {
            return List.generate(
              snapshot.data!.length,
              (index) {
                return PopupMenuItem(
                  child: Text(
                    snapshot.data![index].code.toString(),
                  ),
                  value: snapshot.data![index].code.toString(),
                );
              },
            );
          },
          onSelected: (value) {
            _popupValue = value.toString();
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (_popupValue == snapshot.data![i].code) {
                _selectedCurrency = snapshot.data![i].cbPrice.toString();
                break;
              }
            }
            if (_fromController.text.isNotEmpty) {
              _toLabelText = double.parse(_fromController.text) *
                  double.parse(_selectedCurrency);
            }
            setState(() {});
          },
        );
      },
    );
  }
}

FutureBuilder<List<CurrencyRateModel>> infoListPart() {
  return FutureBuilder(
    future: ServiceCurrency.getCurrencyRate(),
    builder: (BuildContext context,
        AsyncSnapshot<List<CurrencyRateModel>> snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ExpansionTile(
                title: Text(snapshot.data![index].title.toString()),
                trailing: Text(snapshot.data![index].code.toString()),
                children: <Widget>[
                  Card(
                    child: Container(
                      color: const Color(0xFFF0F0F0),
                      child: Column(
                        children: <Widget>[
                          _info(
                            context,
                            snapshot,
                            index,
                            "1 UZS",
                            "${snapshot.data![index].cbPrice} ${snapshot.data![index].code}",
                          ),
                          _info(
                            context,
                            snapshot,
                            index,
                            "Buy Price",
                            "${snapshot.data![index].nbuBuyPrice}",
                          ),
                          _info(
                            context,
                            snapshot,
                            index,
                            "Cell Price",
                            "${snapshot.data![index].nbuCellPrice}",
                          ),
                          _info(
                            context,
                            snapshot,
                            index,
                            "Last Updated",
                            "${snapshot.data![index].date}",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    },
  );
}

Card _info(
  BuildContext context,
  AsyncSnapshot<List<CurrencyRateModel>> snapshot,
  int index,
  String firstText,
  String thirdText,
) {
  return Card(
    child: ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            firstText,
            style: const TextStyle(
              color: Colors.blueGrey,
            ),
          ),
          Text(
            thirdText.isEmpty ? "Nothing" : thirdText,
            style: const TextStyle(
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    ),
  );
}
