import 'package:currency_exchange_app/service/currency_hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
    ServiceCurrency.getCurrencyRate();
    Box data = CurrencyHive.currencyBox;
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
      body: Builder(
        builder: (BuildContext context) {
          if (data.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: inputGetterPart(context, data),
                ),
                Expanded(
                  flex: 8,
                  child: infoListPart(data),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Column inputGetterPart(BuildContext context, Box snapshot) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Row(
          children: <Widget>[
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
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
                  for (int i = 0; i < snapshot.length; i++) {
                    if (_popupValue == snapshot.getAt(i).code) {
                      _selectedCurrency = snapshot.getAt(i).cbPrice.toString();
                      break;
                    }
                  }
                },
                onChanged: (value) {
                  workWhenCurrencyChanged(value);
                  setState(() {});
                },
              ),
            ),
            const Spacer(),
            !_isFrom ? popupMenuButton(snapshot) : const Text("UZS"),
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
            _isFrom ? popupMenuButton(snapshot) : const Text("UZS"),
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

  PopupMenuButton popupMenuButton(Box snapshot) {
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
          snapshot.length,
          (index) {
            return PopupMenuItem(
              child: Text(
                snapshot.getAt(index).code.toString(),
              ),
              value: snapshot.getAt(index).code.toString(),
            );
          },
        );
      },
      onSelected: (value) {
        _popupValue = value.toString();
        for (int i = 0; i < snapshot.length; i++) {
          if (_popupValue == snapshot.getAt(i).code) {
            _selectedCurrency = snapshot.getAt(i).cbPrice.toString();
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
  }

  ListView infoListPart(Box snapshot) {
    return ListView.builder(
      itemCount: snapshot.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ExpansionTile(
            title: Text(snapshot.getAt(index).title.toString()),
            trailing: Text(snapshot.getAt(index).code.toString()),
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
                        "${snapshot.getAt(index).cbPrice} ${snapshot.getAt(index).code}",
                      ),
                      _info(
                        context,
                        snapshot,
                        index,
                        "Buy Price",
                        "${snapshot.getAt(index).nbuBuyPrice}",
                      ),
                      _info(
                        context,
                        snapshot,
                        index,
                        "Cell Price",
                        "${snapshot.getAt(index).nbuCellPrice}",
                      ),
                      _info(
                        context,
                        snapshot,
                        index,
                        "Last Updated",
                        "${snapshot.getAt(index).date}",
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

  Card _info(
    BuildContext context,
    Box snapshot,
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
}
